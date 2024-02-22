from flask import Flask, render_template, request
import joblib
import numpy as np

app = Flask(__name__)

# Load the saved model
model = joblib.load('linear_regression_model.pkl')

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    years_experience = float(request.form['years_experience'])
    years_ahead = int(request.form['years_ahead'])

    # Combine current years of experience with years ahead
    total_years = years_experience + years_ahead

    # Prepare input data for prediction
    input_data = np.array([[total_years]])

    # Make prediction
    predicted_salary = model.predict(input_data)

    return render_template('result.html', predicted_salary=predicted_salary[0], years_ahead=years_ahead)

if __name__ == '__main__':
    app.run(debug=False)
