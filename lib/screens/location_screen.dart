import 'package:flutter/material.dart';
import 'package:flutter_clima_weather_app/screens/city_screen.dart';
import 'package:flutter_clima_weather_app/utilities/constants.dart';
import 'package:flutter_clima_weather_app/services/weather.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});

  final locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int? weatherID;
  int? mainTemp;
  String? nameCity;
  String weatherIcon = '';
  String weatherMessage = '';
  WeatherModel weather = WeatherModel();

  @override
  void initState() {
    super.initState();
    firstUI(widget.locationWeather);
  }

  void firstUI(dynamic weatherData) {
    if (weatherData == null) {
      print("Cannot reach the database!");
    } else {
      weatherID = weatherData["weather"][0]["id"];
      double temp = weatherData["main"]["temp"];
      mainTemp = temp.toInt();
      nameCity = weatherData["name"];
      weatherIcon = weather.getWeatherIcon(weatherID ?? 0);
      weatherMessage = weather.getMessage(mainTemp ?? 0);
    }
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        final snackBar = SnackBar(
            content: Text('Failed to get weather data from server.'),
            action: SnackBarAction(
              label: 'Reload',
              onPressed: () {
                var reload = weather.getLocationWeather();
                reload;
                weatherID = weatherData["weather"][0]["id"];
                double temp = weatherData["main"]["temp"];
                mainTemp = temp.toInt();
                nameCity = weatherData["name"];
                weatherIcon = weather.getWeatherIcon(weatherID ?? 0);
                weatherMessage = weather.getMessage(mainTemp ?? 0);
              },
            ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      weatherID = weatherData["weather"][0]["id"];
      double temp = weatherData["main"]["temp"];
      mainTemp = temp.toInt();
      nameCity = weatherData["name"];
      weatherIcon = weather.getWeatherIcon(weatherID ?? 0);
      weatherMessage = weather.getMessage(mainTemp ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedCityName = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CityScreen();
                      }));
                      var weatherData =
                          await weather.getCityName(typedCityName);
                      if (typedCityName != null) {
                        return updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$mainTemp°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      '$weatherIcon',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$weatherMessage in $nameCity!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// var weatherID = jsonDecode(data)["weather"][0]["id"];
// var mainTemp = jsonDecode(data)["main"]["temp"];
// var nameCity = jsonDecode(data)["name"];
