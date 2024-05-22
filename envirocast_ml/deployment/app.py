from flask import Flask, jsonify
import requests
import pandas as pd
from datetime import date, timedelta
import schedule
import time
from sklearn.preprocessing import MinMaxScaler
import numpy as np
from keras.models import load_model

app = Flask(__name__)
df = pd.read_csv("../data/data_imputed.csv")
aqi = df[['aqi']]
values = aqi.values
values = values.astype('float32')
scalerAQI = MinMaxScaler(feature_range=(0, 1))
scaled_AQI = scalerAQI.fit_transform(values)
pollAQI = np.array(df["aqi"])

meanopAQI = pollAQI.mean()
stdopAQI = pollAQI.std()
aqi_model = load_model("aqi.keras")
    
def forecast_next_AQI(model, aqi_data, n_steps=168):
    forecast = []
    data = np.array(aqi_data).reshape((1, 1, len(aqi_data)))

    for _ in range(n_steps):
        # Make prediction
        yhat = model.predict(data, verbose=0)
        
        # Append the prediction to forecast
        forecast.append(yhat[0, 0])
        
        # Update data with the new predicted value
        yhat = yhat.reshape((1, 1, 1))  # Reshape yhat to 3D
        data = np.append(data[:, :, 1:], yhat, axis=2)

    # Convert forecast back to original scale
    forecast = np.array(forecast)
    forecast = forecast * stdopAQI + meanopAQI
    return forecast
def fetch_weather_data():
    dateToday = date.today()
    datePrev = dateToday - timedelta(days=8)
    
    print("Fetching data from", datePrev, "to", dateToday)
    
    # Define the API endpoint and parameters
    api_url = "https://api.weatherbit.io/v2.0/history/airquality"
    params = {
        "city": "Gujrat",
        "tz": "local",
        "key": "63ca93ca7ef2414282446bce3531a72c",
        'start_date': str(datePrev),
        'end_date': str(dateToday)
    }

    # Make the request to the Weatherbit API
    response = requests.get(api_url, params=params)

    # Check if the request was successful
    if response.status_code == 200:
        # Parse the JSON response
        global data
        data = response.json()
        print("Data fetched successfully:")
        data = data['data']
        data = pd.DataFrame(data)
        print(data)
    else:
        print(f"Failed to fetch data. HTTP Status code: {response.status_code}")
        print(response.text)

fetch_weather_data()
@app.route('/')
def index():
    # print()
    return "Hello World"

@app.route('/aqi', methods=['POST'])
def aqi():
    aqi = data[['aqi']]
    aqi_data = aqi[-168:]
    # aqi_data = aqi_data.ravel()
    forecast = forecast_next_AQI(aqi_model,aqi_data)
    return jsonify(forecast.tolist())

@app.route('/co', methods=['POST'])
def aqi():
    co = data[['co']]
    co_data = co[-168:]
    forecast = forecast_next_AQI(co_model,co_data)
    return jsonify(forecast.tolist())

# Schedule the task to run every hour
# schedule.every().hour.do(fetch_weather_data)

# # Keep the script running
# while True:
# schedule.run_pending()
# time.sleep(1)

if __name__ == '__main__':
    app.run(debug=True)