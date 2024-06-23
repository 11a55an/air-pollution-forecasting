from flask import Flask, jsonify
import requests
import pandas as pd
from datetime import date, timedelta
import schedule
import time
from sklearn.preprocessing import MinMaxScaler
import numpy as np
from keras.models import load_model
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

df = pd.read_csv("data_imputed_3.csv")

# AQI Data
aqi = df[['aqi']]
valuesAQI = aqi.values
valuesAQI = valuesAQI.astype('float32')
scalerAQI = MinMaxScaler(feature_range=(0, 1))
scaled_AQI = scalerAQI.fit_transform(valuesAQI)
pollAQI = np.array(df["aqi"])
aqi_model = load_model("1dcnn_aqi.keras")

# CO Data
co = df[['co']]
valuesCO = co.values
valuesCO = valuesCO.astype('float32')
scalerCO = MinMaxScaler(feature_range=(0, 1))
scaled_CO = scalerCO.fit_transform(valuesCO)
pollCO = np.array(df["co"])
co_model = load_model("1dcnn_co.keras")

# NO2 Data
no2 = df[['no2']]
valuesNO = no2.values
valuesNO = valuesNO.astype('float32')
scalerNO = MinMaxScaler(feature_range=(0, 1))
scaled_NO = scalerNO.fit_transform(valuesNO)
pollNO = np.array(df["no2"])
no_model = load_model("1dcnn_no2.keras")

# O3 Data
o3 = df[['o3']]
valuesO3 = o3.values
valuesO3 = valuesO3.astype('float32')
scalerO3 = MinMaxScaler(feature_range=(0, 1))
scaled_O3 = scalerO3.fit_transform(valuesO3)
pollO3 = np.array(df["o3"])
o3_model = load_model("1dcnn_o3.keras")

# PM10 Data
pm10 = df[['o3']]
valuesPM10 = pm10.values
valuesPM10 = valuesPM10.astype('float32')
scalerPM10 = MinMaxScaler(feature_range=(0, 1))
scaled_PM10 = scalerPM10.fit_transform(valuesPM10)
pollPM10 = np.array(df["pm10"])
pm10_model = load_model("1dcnn_pm10.keras")

# PM25 Data
pm25 = df[['pm25']]
valuesPM25 = pm25.values
valuesPM25 = valuesPM25.astype('float32')
scalerPM25 = MinMaxScaler(feature_range=(0, 1))
scaled_PM25 = scalerPM25.fit_transform(valuesPM25)
pollPM25 = np.array(df["pm25"])
pm25_model = load_model("1dcnn_pm25.keras")

# SO2 Data
so2 = df[['so2']]
valuesSO2 = so2.values
valuesSO2 = valuesSO2.astype('float32')
scalerSO2 = MinMaxScaler(feature_range=(0, 1))
scaled_SO2 = scalerSO2.fit_transform(valuesSO2)
pollSO2 = np.array(df["so2"])
so2_model = load_model("1dcnn_so2.keras")

# Temp Data
temp = df[['temp']]
valuesTemp = temp.values
valuesTemp = valuesTemp.astype('float32')
scalerTemp = MinMaxScaler(feature_range=(0, 1))
scaled_Temp = scalerTemp.fit_transform(valuesTemp)
pollTemp = np.array(df["temp"])
temp_model = load_model("1dcnn_temp.keras")

# Forecast Next 168 Steps
def forecast_next_steps(model, data, n_steps=168):
    predicted_value = model.predict(data.reshape(1, 168, 1))
    predicted_value = predicted_value
    # forecast = []
    # data = np.array(data).reshape((1, 1, len(data)))
    # # Reverse the array
    # data = data[::-1]

    # for _ in range(n_steps):
    #     # Make prediction
    #     yhat = model.predict(data, verbose=0)
        
    #     # Append the prediction to forecast
    #     forecast.append(yhat[0, 0])
        
    #     # Update data with the new predicted value
    #     yhat = yhat.reshape((1, 1, 1))  # Reshape yhat to 3D
    #     data = np.append(data[:, :, 1:], yhat, axis=2)

    # # Convert forecast back to original scale
    # forecast = np.array(forecast)
    return predicted_value

# Fetch Pollution Data
def fetch_pollution_data():
    dateToday = date.today() + timedelta(days=1)
    datePrev = dateToday - timedelta(days=8)
    print(dateToday, datePrev)
    
    print("Fetching data from", datePrev, "to", dateToday)
    
    # Define the API endpoint and parameters
    api_url = "https://api.weatherbit.io/v2.0/history/airquality"
    params = {
        "city": "Gujrat",
        "tz": "local",
        "key": "4aa42fc9ef084abf8b9c0656acf29d38",
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

# Fetch Temperature Data
def fetch_temp_data():
    dateToday = date.today()+ timedelta(days=1)
    datePrev = dateToday - timedelta(days=8)
    
    print("Fetching data from", datePrev, "to", dateToday)
    
    # Define the API endpoint and parameters
    api_url = "https://api.weatherbit.io/v2.0/history/hourly"
    params = {
        "city": "Gujrat",
        "tz": "local",
        "key": "4aa42fc9ef084abf8b9c0656acf29d38",
        'start_date': str(datePrev),
        'end_date': str(dateToday)
    }

    # Make the request to the Weatherbit API
    response = requests.get(api_url, params=params)

    # Check if the request was successful
    if response.status_code == 200:
        # Parse the JSON response
        global dataTemp
        dataTemp = response.json()
        print("Data fetched successfully:")
        dataTemp = dataTemp['data']
        dataTemp = pd.DataFrame(dataTemp)
        dataTemp = dataTemp[['app_temp']]
        dataTemp = dataTemp.dropna()
        dataTemp = dataTemp[-168:]
        # dataTemp = dataTemp.tail(168)
        print(dataTemp)
    else:
        print(f"Failed to fetch data. HTTP Status code: {response.status_code}")
        print(response.text)

fetch_pollution_data()
fetch_temp_data()

# Routes
# Index
@app.route('/')
def index():
    # print()
    return "Hello World"

# AQI
def aqi():
    aqi = data[['aqi']]
    aqi_data = aqi[::-1]
    aqi_data = aqi_data[-168:]
    print(aqi_data)
    aqi_data = scalerAQI.transform(aqi_data)
    forecast = forecast_next_steps(aqi_model,aqi_data)
    forecast = scalerAQI.inverse_transform(forecast)
    return forecast.tolist()

# CO
def co():
    co = data[['co']]
    co_data = co[::-1]
    co_data = co_data[-168:]
    co_data = scalerCO.transform(co_data)
    forecast = forecast_next_steps(co_model,co_data)
    forecast = scalerCO.inverse_transform(forecast)
    return forecast.tolist()

# NO2
def no2():
    no2 = data[['no2']]
    no2_data = no2[::-1]
    no2_data = no2_data[-168:]
    no2_data = scalerNO.transform(no2_data)
    forecast = forecast_next_steps(no_model,no2_data)
    forecast = scalerNO.inverse_transform(forecast)
    return forecast.tolist()

# O3
def o3():
    o3 = data[['o3']]
    o3_data = o3[::-1]
    o3_data = o3_data[-168:]
    o3_data = scalerO3.transform(o3_data)
    forecast = forecast_next_steps(o3_model,o3_data)
    forecast = scalerO3.inverse_transform(forecast)
    return forecast.tolist()

# PM10
def pm10():
    pm10 = data[['pm10']]
    pm10_data = pm10[::-1]
    pm10_data = pm10_data[-168:]
    pm10_data = scalerPM10.transform(pm10_data)
    forecast = forecast_next_steps(pm10_model,pm10_data)
    forecast = scalerPM10.inverse_transform(forecast)
    return forecast.tolist()

# PM2.5
def pm25():
    pm25 = data[['pm10']]
    pm25_data = pm25[::-1]
    pm25_data = pm25_data[-168:]
    pm25_data = scalerPM25.transform(pm25_data)
    forecast = forecast_next_steps(pm25_model,pm25_data)
    forecast = scalerPM25.inverse_transform(forecast)
    return forecast.tolist()

# SO2
def so2():
    so2 = data[['so2']]
    so2_data = so2[::-1]
    so2_data = so2_data[-168:]
    so2_data = scalerSO2.transform(so2_data)
    forecast = forecast_next_steps(so2_model,so2_data)
    forecast = scalerSO2.inverse_transform(forecast)
    return forecast.tolist()

# Temp
def temp():
    temp_data = scalerTemp.transform(dataTemp)
    forecast = forecast_next_steps(temp_model,temp_data)
    forecast = scalerTemp.inverse_transform(forecast)
    return forecast.tolist()

# Temp
@app.route('/all', methods=['POST'])
def all():
    temp_forecast = temp()
    aqi_forecast = aqi()
    co_forecast = co()
    no2_forecast = no2()
    o3_forecast = o3()
    so2_forecast = so2()
    pm25_forecast = pm25()
    pm10_forecast = pm10()
    result = {
        "temp": temp_forecast,
        "aqi": aqi_forecast,
        "co": co_forecast,
        "no2": no2_forecast,
        "o3": o3_forecast,
        "so2": so2_forecast,
        "pm25": pm25_forecast,
        "pm10": pm10_forecast
    }
    return jsonify(result)

def sched():
    fetch_pollution_data()
    fetch_temp_data()
# Schedule the task to run every hour
schedule.every().hour.do(sched)

# # Keep the script running
while True:
    schedule.run_pending()
    time.sleep(1)
    if __name__ == '__main__':
        app.run(host="0.0.0.0", port=8080)