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
  final TextEditingController cityController = TextEditingController();

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
    } catch (e) {
      _weather =
          Weather(cityName: "Not found", temperature: 0, mainCondition: "unknown");
    }
    setState(() {
      isLoading = false;
    });
  }

  _fetchWeatherSearch(String cityName) async {
    setState(() {
      isLoading = true;
    });
    try {
      final weather = await _weatherService.getWeather(cityName);
      _weather = weather;
    } catch (e) {
      _weather =
          Weather(cityName: "Not found", temperature: 0, mainCondition: "unknown");
    }
    setState(() {
      isLoading = false;
    });
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/sun.json";
    switch (mainCondition.toLowerCase()) {
      case 'unknown': 
        return 'assets/unknown.json';
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
      body: Stack(
        children: [
          Center(
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_sharp,
                                    size: 36,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                      _weather?.cityName ??
                                          "Error loading city...",
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontFamily: 'Heavitas',
                                          color: Colors.grey)),
                                ],
                              ),
                              Text("${_weather?.temperature.round()}°C",
                                  style: const TextStyle(
                                      fontSize: 32,
                                      fontFamily: 'Heavitas',
                                      color: Colors.grey)),
                            ])
                          ],
                        ),
                        Lottie.asset(
                            getWeatherAnimation(_weather?.mainCondition)),
                        Container(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Text("${_weather?.mainCondition}",
                            style: const TextStyle(
                                fontSize: 32,
                                fontFamily: 'Heavitas',
                                color: Colors.grey)),
                        )
                      ],
                    )),
          Positioned(
            bottom: 20,
            left: 32,
            child: Row(
              children: [
                Container(
                  width: 260,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 16, top: 3),
                    child: TextField(
                    controller: cityController,
                    decoration: const InputDecoration(
                        hintText: 'Enter city name',
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontFamily: 'Heavitas')),
                    style: const TextStyle(
                        fontFamily: 'Heavitas', color: Colors.grey),
                    onSubmitted: (value) async {
                      _fetchWeatherSearch(cityController.text);
                    },
                  ),
                  )
                ),
                const SizedBox(
                    width: 16), // Add space between the search bar and button
                FloatingActionButton(
                  backgroundColor: Colors.black,
                  onPressed: _fetchWeather,
                  child: const Icon(
                    Icons.refresh,
                    size: 32,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
