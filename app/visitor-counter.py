from flask import Flask, request, send_from_directory
from datetime import datetime
import csv
import os

app = Flask(__name__)
csv_file = 'visitors.csv'
version_file = 'version.txt'

# Create CSV file with headers if it doesn't exist
if not os.path.exists(csv_file):
    with open(csv_file, 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['IP', 'Visit Time'])

@app.route('/')
def home():
    visitor_ip = request.remote_addr
    visit_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    with open(csv_file, 'a', newline='') as file:
        writer = csv.writer(file)
        writer.writerow([visitor_ip, visit_time])

    with open(csv_file, 'r') as file:
        reader = csv.reader(file)
        visit_count = sum(1 for row in reader) - 1  # Exclude header

    return f'<img src="/static/img/SpacelySprocketsInc.png" alt="Spacely Sprockets Inc"><br/><h1>Welcome! You are visitor number {visit_count}.</h1>'

@app.route('/version')
def version():
    with open(version_file, 'r') as file:
        version = file.read().strip()
    return {'version': version}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
