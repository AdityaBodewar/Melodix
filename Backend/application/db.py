from pymongo import MongoClient
from dotenv import load_dotenv
import os 

load_dotenv()

Mongo_uri=os.getenv("MONGOOSE_URI")

db=None

def conn():
    global db
    try :
        client=MongoClient(Mongo_uri)
        db=client['melodix']
        print("db connected successully")
        return db
    except Exception as e:
        print("db connection failed ",str(e))
        return None
    
    

   








