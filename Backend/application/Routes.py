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

        payload={"Email":user.get('Email'),"Username":user.get('Username')}

        if not check:
            return jsonify({"message":"db insertion failed"}),401
        else:
         token=jwt.encode(payload,secret,algorithm="HS256")
          
         return jsonify({"message":"user registered Successfully","data":str(inserted_data),"Token":token}),200
    except Exception as e:
        return jsonify({"error":str(e)}),500
