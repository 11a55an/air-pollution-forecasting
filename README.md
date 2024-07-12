# Envirocast: Realtime Air Monitoring and Forecasting

Envirocast is a real-time air monitoring and forecasting system that provides monitoring and forecasting of indoor and outdoor environmental parameters. The system includes an IoT component for data collection, a machine learning component for forecasting, and a mobile app developed with Flutter for user interface and alerts.

## Features

- **Real-time Monitoring:**
  - Indoor Parameters: Temperature, Humidity, Dust, LPG, Natural Gas, Carbon Monoxide.
  - Outdoor Parameters: Temperature, Carbon Monoxide, Sulfur Dioxide, Nitrogen Dioxide, Ozone, PM2.5, PM10, AQI.

- **Hourly Forecasting:**
  - Outdoor parameters forecasted for the next 7 days.

- **Alerts:**
  - Notifications when monitored parameters reach harmful levels.

## Components

### IoT
- **Hardware Used:** Arduino Uno, MQ5, MQ7, MQ135, DHT11, GP2Y101AU0F sensors, ESP32 Wi-Fi Module.
- **Functionality:** Collects real-time data from sensors and sends it to Firebase.

### Machine Learning
- **Dataset:** Gujrat, Pakistan dataset (Feb 2022 - June 2024).
- **Models Trained:** Moving Averages, ARIMA, SARIMA, FB Prophet, LSTM, and 1D-CNNs.
- **Best Models:** 1D-CNN models (8 models trained for 8 parameters).
- **Deployment:** Models deployed on AWS.

### Mobile App
- **Framework:** Developed using Flutter.
- **Features:** Provides a user-friendly interface for monitoring, forecasting, and receiving alerts.

## Repository Structure

- **envirocast_IOT:** Includes Arduino code for sensor interfacing.
- **envirocast_ML:** Contains notebooks/scripts for data preprocessing, model training, and evaluation.
- **envirocast_App:** Flutter code for the mobile application.

## Screenshots

![Splash Screen](https://github.com/11a55an/air-pollution-forecasting/blob/main/envirocast_App/screenshots/splash.png)
![Home Screen](https://github.com/11a55an/air-pollution-forecasting/blob/main/envirocast_App/screenshots/home.png)
![Indoor Screen](https://github.com/11a55an/air-pollution-forecasting/blob/main/envirocast_App/screenshots/indoor.png)
![Outdoor Screen](https://github.com/11a55an/air-pollution-forecasting/blob/main/envirocast_App/screenshots/outdoor.png)
![Forecast Screen](https://github.com/11a55an/air-pollution-forecasting/blob/main/envirocast_App/screenshots/forecast.png)
![Detail Screen](https://github.com/11a55an/air-pollution-forecasting/blob/main/envirocast_App/screenshots/detail.png)

## Contributors

- [Meerab Irfan](https://github.com/Meer03)
- [Hassan Tahir](https://github.com/11a55an)
- [Sheraz Ahmed](https://github.com/SherazAhmed100)
