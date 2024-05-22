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

# AQI Data
aqi = df[['aqi']]
valuesAQI = aqi.values
valuesAQI = valuesAQI.astype('float32')
scalerAQI = MinMaxScaler(feature_range=(0, 1))
scaled_AQI = scalerAQI.fit_transform(valuesAQI)
pollAQI = np.array(df["aqi"])
meanopAQI = pollAQI.mean()
stdopAQI = pollAQI.std()
aqi_model = load_model("1dcnn_aqi.keras")

# CO Data
co = df[['co']]
valuesCO = co.values
valuesCO = valuesCO.astype('float32')
scalerCO = MinMaxScaler(feature_range=(0, 1))
scaled_CO = scalerCO.fit_transform(valuesCO)
pollCO = np.array(df["co"])
meanopCO = pollCO.mean()
stdopCO = pollCO.std()
co_model = load_model("1dcnn_co.keras")

# NO2 Data
no2 = df[['no2']]
valuesNO = no2.values
valuesNO = valuesNO.astype('float32')
scalerNO = MinMaxScaler(feature_range=(0, 1))
scaled_NO = scalerNO.fit_transform(valuesNO)
pollNO = np.array(df["no2"])
meanopNO = pollNO.mean()
stdopNO = pollNO.std()
no_model = load_model("1dcnn_no2.keras")

# O3 Data
o3 = df[['o3']]
valuesO3 = o3.values
valuesO3 = valuesO3.astype('float32')
scalerO3 = MinMaxScaler(feature_range=(0, 1))
scaled_O3 = scalerO3.fit_transform(valuesO3)
pollO3 = np.array(df["o3"])
meanopO3 = pollO3.mean()
stdopO3 = pollO3.std()
o3_model = load_model("1dcnn_o3.keras")

# PM10 Data
pm10 = df[['o3']]
valuesPM10 = pm10.values
valuesPM10 = valuesPM10.astype('float32')
scalerPM10 = MinMaxScaler(feature_range=(0, 1))
scaled_PM10 = scalerPM10.fit_transform(valuesPM10)
pollPM10 = np.array(df["pm10"])
meanopPM10 = pollPM10.mean()
stdopPM10 = pollPM10.std()
pm10_model = load_model("1dcnn_pm10.keras")

# PM25 Data
pm25 = df[['pm25']]
valuesPM25 = pm25.values
valuesPM25 = valuesPM25.astype('float32')
scalerPM25 = MinMaxScaler(feature_range=(0, 1))
scaled_PM25 = scalerPM25.fit_transform(valuesPM25)
pollPM25 = np.array(df["pm25"])
meanopPM25 = pollPM25.mean()
stdopPM25 = pollPM25.std()
pm25_model = load_model("1dcnn_pm25.keras")

# SO2 Data
so2 = df[['so2']]
valuesSO2 = so2.values
valuesSO2 = valuesSO2.astype('float32')
scalerSO2 = MinMaxScaler(feature_range=(0, 1))
scaled_SO2 = scalerSO2.fit_transform(valuesSO2)
pollSO2 = np.array(df["so2"])
meanopSO2 = pollSO2.mean()
stdopSO2 = pollSO2.std()
so2_model = load_model("1dcnn_so2.keras")

# Temp Data
temp = df[['temp']]
valuesTemp = temp.values
valuesTemp = valuesTemp.astype('float32')
scalerTemp = MinMaxScaler(feature_range=(0, 1))
scaled_Temp = scalerTemp.fit_transform(valuesTemp)
pollTemp = np.array(df["temp"])
meanopTemp = pollTemp.mean()
stdopTemp = pollTemp.std()
temp_model = load_model("1dcnn_temp.keras")

# Forecast Next 168 Steps
def forecast_next_steps(model, data, n_steps=168):
    predicted_value = model.predict(data.reshape(1, 168, 1))[0]
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

# Fetch Temperature Data
def fetch_temp_data():
    dateToday = date.today()
    datePrev = dateToday - timedelta(days=8)
    
    print("Fetching data from", datePrev, "to", dateToday)
    
    # Define the API endpoint and parameters
    api_url = "https://api.weatherbit.io/v2.0/history/hourly"
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
        global dataTemp
        dataTemp = response.json()
        print("Data fetched successfully:")
        dataTemp = dataTemp['data']
        dataTemp = pd.DataFrame(dataTemp)
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
@app.route('/aqi', methods=['POST'])
def aqi():
    aqi = data[['aqi']]
    aqi_data = aqi[-168:]
    aqi_data = scalerAQI.transform(aqi_data)
    forecast = forecast_next_steps(aqi_model,aqi_data)
    forecast = forecast * stdopAQI + meanopAQI
    return jsonify(forecast.tolist())

# CO
@app.route('/co', methods=['POST'])
def co():
    co = data[['co']]
    co_data = co[-168:]
    co_data = scalerCO.transform(co_data)
    forecast = forecast_next_steps(co_model,co_data)
    forecast = forecast * stdopCO + meanopCO
    return jsonify(forecast.tolist())

# NO2
@app.route('/no2', methods=['POST'])
def no2():
    no2 = data[['no2']]
    no2_data = no2[-168:]
    no2_data = scalerNO.transform(no2_data)
    forecast = forecast_next_steps(no_model,no2_data)
    forecast = forecast * stdopNO + meanopNO
    return jsonify(forecast.tolist())

# O3
@app.route('/o3', methods=['POST'])
def o3():
    o3 = data[['o3']]
    o3_data = o3[-168:]
    o3_data = scalerO3.transform(o3_data)
    forecast = forecast_next_steps(o3_model,o3_data)
    forecast = forecast * stdopO3 + meanopO3
    return jsonify(forecast.tolist())

# PM10
@app.route('/pm10', methods=['POST'])
def pm10():
    pm10 = data[['pm10']]
    pm10_data = pm10[-168:]
    pm10_data = scalerPM10.transform(pm10_data)
    forecast = forecast_next_steps(pm10_model,pm10_data)
    forecast = forecast * stdopPM10 + meanopPM10
    return jsonify(forecast.tolist())

# PM2.5
@app.route('/pm25', methods=['POST'])
def pm25():
    pm25 = data[['pm10']]
    pm25_data = pm25[-168:]
    pm25_data = scalerPM25.transform(pm25_data)
    forecast = forecast_next_steps(pm25_model,pm25_data)
    forecast = forecast * stdopPM25 + meanopPM25
    return jsonify(forecast.tolist())

# SO2
@app.route('/so2', methods=['POST'])
def so2():
    so2 = data[['so2']]
    so2_data = so2[-168:]
    so2_data = scalerSO2.transform(so2_data)
    forecast = forecast_next_steps(so2_model,so2_data)
    forecast = forecast * stdopSO2 + meanopSO2
    return jsonify(forecast.tolist())

# Temp
@app.route('/temp', methods=['POST'])
def temp():
    temp = dataTemp[['app_temp']]
    temp_data = temp[-168:]
    temp_data = scalerTemp.transform(temp_data)
    forecast = forecast_next_steps(temp_model,temp_data)
    forecast = forecast * stdopTemp + meanopTemp
    return jsonify(forecast.tolist())

# Schedule the task to run every hour
# schedule.every().hour.do(fetch_weather_data)

# # Keep the script running
# while True:
# schedule.run_pending()
# time.sleep(1)

if __name__ == '__main__':
    app.run(debug=True)