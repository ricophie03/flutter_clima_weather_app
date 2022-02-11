import 'package:flutter/material.dart';
import 'package:flutter_clima_weather_app/services/weather.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'location_screen.dart';

const String myAPIKey = '73e204a4944fd55e0d93bbc54d8346cc';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String? latitude;
  String? longitude;
  WeatherModel weatherModel = WeatherModel();

  void getLocationData() async {
    var weatherData = await weatherModel.getLocationWeather();
    Future.delayed(Duration.zero, () {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LocationScreen(
          locationWeather: weatherData,
        );
      }));
    });
  }

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
