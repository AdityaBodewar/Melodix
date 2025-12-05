import cloudinary
import os
from dotenv import load_dotenv

load_dotenv()


def cloud_Connectione():
    try:

        cloudinary.config(
        cloud_name=os.getenv("CLOUDINARY_CLOUD_NAME"),
        api_key=os.getenv("CLOUDINARY_API_KEY"),
        api_secret=os.getenv("CLOUDINARY_API_SECRET"),
        secure=True
        )

        print("cloud connected successfully")
        return "done"
    except Exception as e:
        return ("cloud connection error",str(e))