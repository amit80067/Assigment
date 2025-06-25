from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def home():
    return jsonify(
        service="Service 2",
        status="running", 
        endpoints=["/ping", "/hello", "/health"]
    )


@app.route("/ping")
def ping():
    return jsonify(status="ok", service="2")


@app.route("/hello")
def hello():
    return jsonify(message="Hello from Service 2")


@app.route("/health")  
def health():
    return jsonify(
        status="healthy",
        service="Service 2", 
        uptime="running",
        timestamp="2025-06-25"
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8002)
