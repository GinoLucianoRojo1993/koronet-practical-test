from flask import Flask
import redis
import psycopg2

app = Flask(__name__)

# Redis configuration
redis_client = redis.StrictRedis(host='redis', port=6379, decode_responses=True)

# PostgreSQL configuration
try:
    conn = psycopg2.connect(
        dbname="koronet_db",
        user="postgres",
        password="password",
        host="database",
        port="5432"
    )
except Exception as e:
    print("Database connection failed:", e)

@app.route('/')
def hello_koronet():
    return "Hi Koronet Team."

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
