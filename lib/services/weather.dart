import 'package:flutter_clima_weather_app/services/location.dart';
import 'package:flutter_clima_weather_app/services/networking.dart';

const String myAPIKey = '73e204a4944fd55e0d93bbc54d8346cc';
const String openWeatherMapURL =
    'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  String latitude = '';
  String longitude = '';

  Future<dynamic> getCityName(String cityName) async {
    var url = '$openWeatherMapURL?q=$cityName&appid=$myAPIKey&units=metric';

    NetworkingHelper networkingHelper = NetworkingHelper(url: url);
    var weatherData = await networkingHelper.getData(); // dynamic data
    return weatherData;
  }

  Future getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    latitude = location.latitude.toString();
    longitude = location.longitude.toString();

    NetworkingHelper networkingHelper = NetworkingHelper(
        url:
            '$openWeatherMapURL?lat=$latitude&lon=$longitude&appid=$myAPIKey&units=metric');

    var weatherData = await networkingHelper.getData(); // dynamic data
    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need scarf and gloves';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
