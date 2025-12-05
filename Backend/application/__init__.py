from flask import Flask
from application.db import conn
from application.cloud import cloud_Connectione
from flask_cors import CORS

app=Flask(__name__)
CORS(app)
dbconnection=conn()
cloud_Connectione()

from application import Routes


