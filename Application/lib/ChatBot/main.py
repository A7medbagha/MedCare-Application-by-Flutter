from flask import Flask, request, jsonify
import sqlite3
import schedule
import threading
import time
from functions import extract_medicine, check_medicine, get_current_medicine


app = Flask(__name__)

abnormal_diabetes_patients = []
abnormal_hypertension_patients = []

def get_db_connection():
    conn = sqlite3.connect('patients.db')
    conn.row_factory = sqlite3.Row
    return conn

@app.route('/answer', methods=['GET'])
def get_data():
    patient_id = request.args.get('id')
    question = request.args.get('question')
    medicine = extract_medicine(question)
    current_medicine = get_current_medicine(patient_id)
    if medicine:
        if check_medicine(current_medicine,medicine):
            response = {
                "answer": f"Depends on your current condition No, you can't take {medicine} with {current_medicine}.",
            }
        else:
            response = {
                "answer": f"Depends on your current condition yes, you can take {medicine} with {current_medicine}.",
            }
        return jsonify(response)

@app.route('/get_data', methods=['GET'])
def get_data():
    patient_id = request.args.get('id')
    conn = get_db_connection()
    cursor = conn.cursor()
    
    cursor.execute('SELECT * FROM diabetes WHERE id = ?', (patient_id,))
    diabetes_patient = cursor.fetchone()
    
    if diabetes_patient:
        return jsonify(dict(diabetes_patient))
    
    cursor.execute('SELECT * FROM hypertension WHERE id = ?', (patient_id,))
    hypertension_patient = cursor.fetchone()
    
    if hypertension_patient:
        return jsonify(dict(hypertension_patient))
    
    return jsonify({"error": "Patient not found"}), 404


@app.route('/get_abnormal_diabetes', methods=['GET'])
def get_abnormal_diabetes():
    global abnormal_diabetes_patients
    return jsonify(abnormal_diabetes_patients)

@app.route('/get_abnormal_hypertension', methods=['GET'])
def get_abnormal_hypertension():
    global abnormal_hypertension_patients
    return jsonify(abnormal_hypertension_patients)


def check_abnormal_patient():
    global abnormal_diabetes_patients
    global abnormal_hypertension_patients
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute('SELECT * FROM diabetes WHERE final_results = "abnormal"')
    diabetes_abnormal = cursor.fetchall()
    
    cursor.execute('SELECT * FROM hypertension WHERE final_results = "abnormal"')
    hypertension_abnormal = cursor.fetchall()
    
    abnormal_diabetes_patients = [dict(row) for row in diabetes_abnormal]
    abnormal_hypertension_patients = [dict(row) for row in hypertension_abnormal]

    if diabetes_abnormal:
        return jsonify(diabetes_abnormal)
    if hypertension_abnormal:
        return jsonify(hypertension_abnormal)

    conn.close()

def run():
    schedule.every().day.at("22:00").do(check_abnormal_patient)
    while True:
        schedule.run_pending()
        time.sleep(1)


check_thread = threading.Thread(target=run)
check_thread.start()

app.run()