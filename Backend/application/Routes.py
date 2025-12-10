from application.db import db
from flask import jsonify,request
from application.__init__ import app
import cloudinary.uploader
import jwt
from fuzzywuzzy import fuzz
import os

secret=os.getenv("SECRET_KEY")

@app.route("/addmusic",methods=['POST'])
def addmusic():
    try:
        title=request.form.get("title")
        singer=request.form.get("singer")
        language=request.form.get("language")
        type=request.form.get("type")
        image=request.files.get("image")
        audio=request.files.get("audio")

        img_result=cloudinary.uploader.upload(image,resource_type="image",folder="Melodix_images")
        audio_result=cloudinary.uploader.upload(audio,resource_type="video",folder="Melodix_Songs")

        data={"Title":title,"Singer":singer,"Language":language,"Type":type,"Image":img_result["secure_url"],"Song":audio_result["secure_url"]}
        
        result=db.Songs.insert_one(data)

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
                payload={"Email":data.get('Email'),"Role":"Admin"}
                token=jwt.encode(payload,secret,algorithm="HS256")
                return jsonify({"message":"Admin Login Successfully","Token":token,"Role":"Admin"}),200
            else:
                return jsonify({"error":"wrong Password"}),401
   
        elif check_Artist_if_Registered:
            if data.get('Email') == check_Artist_if_Registered.get('Email') and data.get('Password')== check_Artist_if_Registered.get('Password'):
                payload={"Email":data.get('Email'),"Role":"Artist"}
                token=jwt.encode(payload,secret,algorithm="HS256")
                return jsonify({"message":"Artist Login successfully ","Token":token,"Role":"Artist"}),200
            else:
                return jsonify({"error":"wrong Password"}),401
        elif check_user_if_Registerd :
            if data.get('Email') == check_user_if_Registerd.get('Email') and data.get('Password')== check_user_if_Registerd.get('Password'):
                payload={"Email":data.get('Email'),"Role":"User"}
                token=jwt.encode(payload,secret,algorithm="HS256")
                return jsonify({"message":"User Login Successfully","Token":token,"Role":"User"}),200
            else:
                return jsonify({"error":"wrong Password"}),401
        else:
            return jsonify({"message":"Email not registered "}),401
    except Exception as e:
        return jsonify({"error":str(e)})