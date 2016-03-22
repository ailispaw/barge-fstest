from flask import Flask
app = Flask(__name__)

TEXT = "STARTING-TEXT"


@app.route('/')
def hello_world():
    return TEXT

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
