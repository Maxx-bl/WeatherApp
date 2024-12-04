import 'package:flutter/material.dart';
import 'package:flutter_apptest/models/weather_model.dart';
import 'package:flutter_apptest/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool isLoading = true;
  final _weatherService = WeatherService("154657d107a3b45374b467c0fbad51f4");
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  _fetchWeather() async {
    setState(() {
      isLoading = true;
    });
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      _weather = weather;
      print(
          "Weather : ${_weather?.cityName} ${_weather?.temperature} ${_weather?.mainCondition}");
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/sun.json";
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/cloud.json';
      case 'snow':
        return 'assets/snow.json';
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'ash':
      case 'sand':
        return 'assets/fog.json';
      case 'rain':
      case 'drizzle':
        return 'assets/rain.json';
      case 'thunderstorm':
      case 'tornado':
      case 'squall':
        return 'assets/thunder.json';
      case 'clear':
      default:
        return 'assets/sun.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 33, 33, 1),              
      body: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on_sharp, size: 40, color: Colors.grey,),
                        Text(_weather?.cityName ?? "Error loading city...", style: const TextStyle(fontSize: 24, fontFamily: 'Heavitas', color: Colors.grey)),
                      ],
                    ),
                    Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                    Text("${_weather?.temperature.round()}°C", style: const TextStyle(fontSize: 32, fontFamily: 'Heavitas', color: Colors.grey)),
                  ],
                )),
      floatingActionButton: FloatingActionButton(
        backgroundColor:Colors.black,
        onPressed: _fetchWeather,
        child: const Icon(Icons.refresh, color: Colors.grey,),
      ),
    );
  }
}
