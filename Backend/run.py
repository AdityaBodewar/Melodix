from application.__init__ import app
import os
from dotenv import load_dotenv

load_dotenv()


if __name__=="__main__":
    app.run(host="0.0.0.0", port=os.getenv("PORT"),debug=True )