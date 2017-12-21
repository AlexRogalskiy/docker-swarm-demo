from db import db
import psutil
from flask import Flask, make_response
import psutil
import time
import socket
app = Flask(__name__)

@app.route("/")
def index():
    logged = {}
    logged['hostname'] = socket.gethostname()
    logged['cpu_perc'] = psutil.cpu_percent()
    logged['mem_perc'] = psutil.virtual_memory().percent
    logged['@timestamp'] = time.time()
    with open("/sys/class/thermal/thermal_zone0/temp") as temp:
            logged['temperature'] = float(temp.read().strip())/1000
            
    db.index(index="demo_sei", doc_type='log', body=logged)

    return make_response("Demo update v2 {}".format(socket.gethostname()), 200)

if __name__ == "__main__":
    app.run("0.0.0.0", port=5000)