from flask import Flask
from application.db import conn
from application.cloud import cloud_Connectione


app=Flask(__name__)
dbconnection=conn()
cloud_Connectione()

from application import Routes


