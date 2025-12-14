from flask import Flask
import os

app = Flask(__name__)

@app.route("/health")
def health():
    return "hello from python", 200

@app.route("/")
def index():
    return "hello from python"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)