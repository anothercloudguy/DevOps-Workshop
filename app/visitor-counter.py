import os
from flask import Flask, render_template, jsonify
import psycopg2
from dotenv import load_dotenv

# Cargar las variables de entorno desde el archivo .env
load_dotenv()

app = Flask(__name__)

def get_db_connection():
    conn = psycopg2.connect(
        host=os.getenv("POSTGRES_HOST"),
        database=os.getenv("POSTGRES_DB"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD")
    )
    return conn

@app.route('/')
def home():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT COUNT(*) FROM visitors')
    count = cur.fetchone()[0]
    cur.close()
    conn.close()
    return render_template('index.html', count=count)

# Used for debugging the db connection
'''
@app.route('/data')
def data():
    db_data = {
        "POSTGRES_HOST": os.getenv("POSTGRES_HOST"),
        "POSTGRES_DB": os.getenv("POSTGRES_DB"),
        "POSTGRES_USER": os.getenv("POSTGRES_USER"),
        "POSTGRES_PASSWORD": os.getenv("POSTGRES_PASSWORD")
    }
    return jsonify(db_data)
'''
    
@app.route('/version')
def version():
    with open('version.txt', 'r') as file:
        version = file.read().strip()
    return f"Version: {version}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
