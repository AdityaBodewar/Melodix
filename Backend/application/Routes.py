from application.db import db
from flask import jsonify,request
from application.__init__ import app
import cloudinary.uploader


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


