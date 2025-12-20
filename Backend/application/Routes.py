from application.db import db
from flask import jsonify,request
from application.__init__ import app
import cloudinary.uploader
import jwt
from fuzzywuzzy import fuzz
import os
from bson.objectid import ObjectId
from bson.json_util import dumps
import json


secret = os.getenv("SECRET_KEY")




@app.route("/addmusic",methods=['POST'])
def addmusic():
    try:
        title=request.form.get("title")
      
        language=request.form.get("language")
        type=request.form.get("type")
        image=request.files.get("image")
        audio=request.files.get("audio")
        auth_header= request.headers.get('Authorization')
        img_result=cloudinary.uploader.upload(image,resource_type="image",folder="Melodix_images")
        audio_result=cloudinary.uploader.upload(audio,resource_type="video",folder="Melodix_Songs")
        
        token = auth_header.split(" ")[1]

       
        decoded = jwt.decode(
            token,
            secret,
            algorithms=["HS256"]
        )  
        artist=db.Artist.find_one({"Email":decoded['Email']})
        singer=artist['Username']
        data={"Title":title,"Singer":singer,"Language":language,"Type":type,"Image":img_result["secure_url"],"Song":audio_result["secure_url"]}
        
        result=db.Songs.insert_one(data)
        db.Artist.update_one({"_id":artist['_id']},{"$push":{"SongsCreated":result.inserted_id}})

        inserted_doc=db.Songs.find_one({"_id":result.inserted_id})
        inserted_doc["_id"] = str(inserted_doc["_id"])
        return jsonify({"message":'data added successfully',"result":inserted_doc}),200
    except Exception as e:
        return jsonify({"error":str(e)}),500


@app.route("/getallmusic",methods=["GET"])
def getallmusic():
    try:
        songs=list(db.Songs.find())

        for music in songs:
            music["_id"]=str(music["_id"])

        return jsonify({"message":"fetteched successfully","data":songs}),200
    except Exception as e:
        return jsonify({"error":str(e)}),500


@app.route("/searchmusic", methods=["POST"])
def searchmusic():
    try:
        data = request.json

        if not data:
            return jsonify({"message": "No data provided"}), 401

        title = data.get("Title")

        if not title:
            return jsonify({"message": "Title is required"}), 401

       
        all_songs = list(db.Songs.find({}, {"_id": 1, "Title": 1}))

        matched_songs = []

        
        threshold = 65

        for song in all_songs:
            score = fuzz.partial_ratio(title.lower(), song["Title"].lower())

            if score >= threshold:
                matched_songs.append(song)

        if not matched_songs:
            return jsonify({"message": "No result found"}), 401

       
        final_songs = []
        for s in matched_songs:
            full = db.Songs.find_one({"_id": s["_id"]})
            full["_id"] = str(full["_id"])
            final_songs.append(full)

        return jsonify({
            "message": "found successfully",
            "data": final_songs
        }), 200

    except Exception as e:
        return jsonify({"error": str(e),"message":"no result found"}), 500
    

@app.route("/registeruser",methods=['POST'])
def RegisterUser():
    try:
        user=request.get_json()

        if not user.get('Fullname') or not user.get('Username') or not user.get('Password') or not user.get('Email'):
            return jsonify({"message":"all fields required "}),401
        
        already_registered_Email=db.Users.find_one({"Email":user.get('Email')})
        already_registered_Username=db.Users.find_one({"Username":user.get('Username')})
        if already_registered_Email :
            return jsonify({"message":"Email already Registered"}),401
        else :
            if already_registered_Username:
                return jsonify({"message":"Username already Registered"}),401
        user['Profile']="https://res.cloudinary.com/dlkvtlln0/image/upload/v1765517183/profile_melodix_ry44ei.webp"
        check=db.Users.insert_one(user)

        inserted_data=db.Users.find_one({"_id":check.inserted_id})

        if not check:
            return jsonify({"message":"db insertion failed"}),401
        
        return jsonify({"message":"user registered Successfully","data":str(inserted_data)}),200
    except Exception as e:
        return jsonify({"error":str(e)}),500

@app.route("/registerArtist",methods=['POST'])
def registerArtist():
    try :
        artist=request.get_json()

        if not artist.get('Fullname') or not artist.get('Username') or not artist.get('Password') or not artist.get('Email') or not artist.get('Type'):
            return jsonify({"message":"all fields required "}),401
        already_registered_Email=db.Artist.find_one({"Email":artist.get('Email')})
        already_registered_Username=db.Artist.find_one({"Username":artist.get('Username')})
        if already_registered_Email :
            return jsonify({"message":"Email already Registered"}),401
        else :
            if already_registered_Username:
                return jsonify({"message":"Username already Registered"}),401
        artist['Profile']="https://res.cloudinary.com/dlkvtlln0/image/upload/v1765517183/profile_melodix_ry44ei.webp"
        artist['SongsCreated']=[]
        check=db.Artist.insert_one(artist)

        inserted_data=db.Artist.find_one({'_id':check.inserted_id})
        if not check:
            return jsonify({"message":"db insertion failed"}),401
        return jsonify({"message":"Artist registered Successfully","data":str(inserted_data)}),200
    except Exception as e:
        return jsonify({"error":str(e)}),500

@app.route("/login",methods=['POST'])
def login():
    try :
        data=request.get_json()

        if not data.get('Password') or not data.get('Email'):
            return jsonify({"error":" enter email and password both "}),401
        
        check_user_if_Registerd=db.Users.find_one({"Email":data.get('Email')})
        check_Artist_if_Registered=db.Artist.find_one({"Email":data.get('Email')})
        check_Admin_if_Registered=db.Admin.find_one({"Email":data.get('Email')})

        if check_Admin_if_Registered:
            if data.get('Email') == check_Admin_if_Registered.get('Email') and data.get('Password')== check_Admin_if_Registered.get('Password'):
                user=db.Admin.find_one({"Email":data.get("Email")})
                payload={"Email":data.get('Email'),"Role":"Admin","user_id":str(user["_id"])}
                token=jwt.encode(payload,secret,algorithm="HS256")
                return jsonify({"message":"Admin Login Successfully","Token":token,"Role":"Admin"}),200
            else:
                return jsonify({"error":"wrong Password"}),401
   
        elif check_Artist_if_Registered:
            if data.get('Email') == check_Artist_if_Registered.get('Email') and data.get('Password')== check_Artist_if_Registered.get('Password'):
                user=db.Artist.find_one({"Email":data.get("Email")})
                payload={"Email":data.get('Email'),"Role":"Artist","user_id":str(user["_id"])}
                token=jwt.encode(payload,secret,algorithm="HS256")
                return jsonify({"message":"Artist Login successfully ","Token":token,"Role":"Artist"}),200
            else:
                return jsonify({"error":"wrong Password"}),401
        elif check_user_if_Registerd :
            if data.get('Email') == check_user_if_Registerd.get('Email') and data.get('Password')== check_user_if_Registerd.get('Password'):
                user=db.Users.find_one({"Email":data.get("Email")})
                payload={"Email":data.get('Email'),"Role":"User","user_id":str(user["_id"])}
                token=jwt.encode(payload,secret,algorithm="HS256")
                return jsonify({"message":"User Login Successfully","Token":token,"Role":"User"}),200
            else:
                return jsonify({"error":"wrong Password"}),401
        else:
            return jsonify({"message":"Email not registered "}),401
    except Exception as e:
        return jsonify({"error":str(e)})
    

@app.route("/createPlaylist", methods=["POST"])
def createPlaylist():
    try:
        data = request.get_json()
        auth_header = request.headers.get("Authorization")

        if not auth_header:
            return jsonify({"error": "Missing token"}), 401

       
        try:
            token = auth_header.split(" ")[1]
        except:
            return jsonify({"error": "Invalid token format"}), 401

       
        try:
            decoded = jwt.decode(token, secret, algorithms=["HS256"])
        except jwt.ExpiredSignatureError:
            return jsonify({"error": "Token expired"}), 401
        except jwt.InvalidTokenError:
            return jsonify({"error": "Invalid token"}), 401

        user_id_str = decoded.get("user_id")
        if not user_id_str:
            return jsonify({"error": "Invalid payload"}), 400

        user_id = ObjectId(user_id_str)

        playlist_name = data.get("playlist_name")
        if not playlist_name:
            return jsonify({"error": "Playlist name required"}), 400

        result = db.Playlists.insert_one({
            "user_id": user_id,
            "playlist_name": playlist_name,
            "songs": []
        })

        return jsonify({
            "message": "Playlist created successfully",
            "playlist_id": str(result.inserted_id),
            "owner_id": user_id_str
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/addSongToPlaylist", methods=["POST"])
def addSongToPlaylist():
    try:
        data = request.get_json()
        auth_header = request.headers.get("Authorization")

        if not auth_header:
            return jsonify({"error": "Missing token"}), 401

        token = auth_header.split(" ")[1]
        decoded = jwt.decode(token, secret, algorithms=["HS256"])
        user_id = ObjectId(decoded.get("user_id"))

        playlist_id = data.get("playlist_id")
        song_id = data.get("song_id")
        if not playlist_id or not song_id:
            return jsonify({"error": "playlist_id and song_id required"}), 400

        playlist_obj_id = ObjectId(playlist_id)
        song_obj_id = ObjectId(song_id)

        playlist = db.Playlists.find_one({"_id": playlist_obj_id})
        if not playlist:
            return jsonify({"error": "Playlist not found"}), 404

        if playlist["user_id"] != user_id:
            return jsonify({"error": "Cannot edit someone else's playlist"}), 403

       
        if song_obj_id in playlist.get("songs", []):
            return jsonify({"message": "Song already in playlist"}), 200

        db.Playlists.update_one(
            {"_id": playlist_obj_id},
            {"$push": {"songs": song_obj_id}}
        )

        return jsonify({
            "message": "Song added successfully",
            "playlist_id": playlist_id,
            "song_id": song_id
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/myPlaylists", methods=["GET"])
def myPlaylists():
    try:
        auth_header = request.headers.get("Authorization")
        if not auth_header:
            return jsonify({"error": "Missing token"}), 401

        token = auth_header.split(" ")[1]
        decoded = jwt.decode(token, secret, algorithms=["HS256"])
        user_id = ObjectId(decoded.get("user_id"))

        playlists = db.Playlists.find({"user_id": user_id})

        playlist_list = []
        for p in playlists:
            playlist_list.append({
                "playlist_id": str(p["_id"]),
                "playlist_name": p["playlist_name"],
                "song_count": len(p.get("songs", []))
            })

        return jsonify({"playlists": playlist_list}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/playlist/<playlist_id>", methods=["GET"])
def get_playlist(playlist_id):
    try:
        auth_header = request.headers.get("Authorization")
        if not auth_header:
            return jsonify({"error": "Missing token"}), 401

        try:
            token = auth_header.split(" ")[1]
        except:
            return jsonify({"error": "Invalid token format"}), 401

        try:
            decoded = jwt.decode(token, secret, algorithms=["HS256"])
        except jwt.ExpiredSignatureError:
            return jsonify({"error": "Token expired"}), 401
        except jwt.InvalidTokenError:
            return jsonify({"error": "Invalid token"}), 401

        user_id_str = decoded.get("user_id")
        if not user_id_str:
            return jsonify({"error": "Invalid payload"}), 400

        user_id = ObjectId(user_id_str)

        
        playlist = db.Playlists.find_one({"_id": ObjectId(playlist_id), "user_id": user_id})
        if not playlist:
            return jsonify({"error": "Playlist not found"}), 404

       
        songs = []
        for song_id in playlist.get("songs", []):
            song = db.Songs.find_one({"_id": ObjectId(song_id)})
            if song:
                song["_id"] = str(song["_id"])
                songs.append(song)

        playlist_data = {
            "playlist_id": str(playlist["_id"]),
            "playlist_name": playlist.get("playlist_name"),
            "songs": songs
        }

        return jsonify({"playlist": playlist_data}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/getallartist",methods=['GET'])
def getAllArtist():
    try:
        artist=list(db.Artist.find())

        artist = json.loads(dumps(artist))
        return jsonify({"message":"retrived successfully","artist":artist})
    except Exception as e:
        return  jsonify({"error":str(e)})


@app.route("/getsongofartist/<id>", methods=['GET'])
def getsongofartist(id):
    try:
        artist_id = ObjectId(id)

        artist = db.Artist.find_one({"_id": artist_id})
        if not artist:
            return jsonify({"error": "Artist not found"}), 404

        song_ids = artist.get("SongsCreated", [])
        
        songs = []
        for song_id in song_ids:
            song = db.Songs.find_one({"_id": ObjectId(song_id)})
            if song:
                song["_id"] = str(song["_id"])
                songs.append(song)

        return jsonify({"data": songs}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    


@app.route("/login_flutter", methods=['POST'])
def login_flutter():
    try:
        data = request.get_json()

        if not data.get('Email') or not data.get('Password'):
            return jsonify({"message": "Enter email and password"}), 401

        email = data.get('Email')
        password = data.get('Password')

        user = db.Users.find_one({"Email": email})
        artist = db.Artist.find_one({"Email": email})
        admin = db.Admin.find_one({"Email": email})

       
        def generate_token(role):
            payload = {"Email": email, "Role": role,"user_id":str(user["_id"])}

            token = jwt.encode(payload, str(secret), algorithm="HS256")
            if isinstance(token, bytes):
                token = token.decode("utf-8")
            return token

        if admin:
            if password == admin.get("Password"):
                return jsonify({
                    "message": "Admin Login Successfully",
                    "Token": token,
                    "Role": "Admin",
        
                }), 200
            return jsonify({"message": "Wrong Password"}), 401

        if artist:
            if password == artist.get("Password"):
                return jsonify({
                "message": "Artist Login Successfully",
                "Token": token,
                "Role": "Artist"
}), 200
 

        if user:
            if password == user.get("Password"):
                return jsonify({
                    "message": "User Login Successfully",
                    "Token": generate_token("User", user),
                    "Role": "User"
                }), 200
            return jsonify({"message": "Wrong Password"}), 401

        return jsonify({"message": "Email not registered"}), 401
    
    except Exception as e:
        print("LOGIN ERROR:", e)
        return jsonify({"error": str(e)}), 500


@app.route("/profile", methods=["GET"])
def get_profile():
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        return jsonify({"message": "Authorization header missing"}), 401

    token = auth_header.split(" ")[1]
    try:
        decoded = jwt.decode(token, secret, algorithms=["HS256"])
    except jwt.ExpiredSignatureError:
        return jsonify({"message": "Token expired"}), 401
    except jwt.InvalidTokenError:
        return jsonify({"message": "Invalid token"}), 401

    role = decoded.get("Role", "User").lower()

    if role == "artist":
        collection = db.Artist
    elif role == "admin":
        collection = db.Admin
    else:
        collection = db.Users

    user_id = decoded.get('user_id')
    if not user_id:
        return jsonify({"message": "user_id missing in token"}), 400

   
    try:
        user_id_obj = ObjectId(user_id)
    except:
        user_id_obj = user_id 

    print(f"Fetching {role} with _id: {user_id_obj}")
    user = collection.find_one({"_id": user_id_obj})
    if not user:
        return jsonify({"message": f"{role} not found"}), 404

   
    if isinstance(user.get("_id"), ObjectId):
        user['_id'] = str(user['_id'])
        user["Role"] = decoded.get("Role") 

    return jsonify(user), 200


@app.route("/profile", methods=["PUT"])
def update_profile():
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        return jsonify({"message": "Authorization header missing"}), 401

    token = auth_header.split(" ")[1]
    try:
        decoded = jwt.decode(token, secret, algorithms=["HS256"])
    except jwt.ExpiredSignatureError:
        return jsonify({"message": "Token expired"}), 401
    except jwt.InvalidTokenError:
        return jsonify({"message": "Invalid token"}), 401

   
    role = decoded.get("Role", "User")
    if role.lower() == "artist":
        collection = db.Artist
    elif role.lower() == "admin":
        collection = db.Admin
    else:
        collection = db.Users

    user = collection.find_one({"_id": ObjectId(decoded['user_id'])})
    if not user:
        return jsonify({"message": f"{role} not found"}), 404

    
    fullname = request.form.get("Fullname")
    email = request.form.get("Email")
    username = request.form.get("Username")

   
    image_file = request.files.get("Image")
    image_url = user.get("Image", "") 

    if image_file:
       
        result = cloudinary.uploader.upload(image_file, folder=f"profile_pics/{role}")
        image_url = result.get("secure_url")  

   
    collection.update_one(
        {"_id": ObjectId(decoded['user_id'])},
        {"$set": {
            "Fullname": fullname,
            "Email": email,
            "Username": username,
            "Image": image_url
        }}
    )

    return jsonify({"message": f"{role} profile updated successfully", "Image": image_url}), 200