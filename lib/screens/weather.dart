import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tapa_0/screens/home.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  
  @override

  State<WeatherScreen> createState() => WeatherState();
}

class WeatherState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  
  static String API_KEY = '5d23313be9f444028bd73735230409';
  
  String location = 'Kuala Lumpur'; //default location
  String weatherIcon = 'heavycloud.png';
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentDate = '';

  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  String currentWeatherStatus = '';

  String searchWeatherAPI = "https://api.weatherapi.com/v1/forecast.json?key=$API_KEY&days=7&q=";

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

 void initializeNotifications() async {
  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

  Future<void> selectNotification(String? payload) async {
    
        if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
  }

  Future<void> showRainNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name',
            importance: Importance.max, priority: Priority.high);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Rain Alert',
      'It\'s raining in your location!',
      platformChannelSpecifics,
      payload: 'Rain',
    );
  }

  void checkForRain() {
    bool isRaining = currentWeatherStatus.contains('rain') ||
        currentWeatherStatus.contains('showers');
    if (isRaining) {
      showRainNotification();
    }
  }


  void fetchWeatherData(String searchText) async{
    try{
      var searchResult = await http.get(Uri.parse(searchWeatherAPI + searchText));

      final weatherData = Map<String, dynamic>.from(
        json.decode(searchResult.body) ?? 'No data');

        var locationData = weatherData["location"];

        var currentWeather = weatherData["current"];

        setState(() {
          location = getShortLocationName(locationData["name"]);
          
          var parsedDate = DateTime.parse(locationData["localtime"].substring(0, 10));
          var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
          currentDate = newDate;

          //updateWeather
          currentWeatherStatus = currentWeather["condition"]["text"];
          weatherIcon = currentWeatherStatus.replaceAll(' ', '').toLowerCase() + ".png";
          temperature = currentWeather["temp_c"].toInt();
          windSpeed = currentWeather["wind_kph"].toInt();
          humidity = currentWeather["humidity"].toInt();
          cloud = currentWeather["cloud"].toInt();

          //forecast data
          dailyWeatherForecast = weatherData["forecast"]["forecastday"];
          hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
        });
    } catch(e){
      //debugPrint(e);
    }
  }

  static String getShortLocationName(String s){
    List<String> wordList = s.split(" ");

    if(wordList.isNotEmpty){
      if(wordList.length > 1){
        return wordList[0] + " " + wordList[1];
      } else{
        return wordList[0];
      }
    } else{
      return " ";
    }
  }

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    fetchWeatherData(location);
    Timer.periodic(Duration(minutes: 30), (timer) {
      checkForRain();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      
    appBar: AppBar(
      automaticallyImplyLeading: false, 
      centerTitle: true,
      title: Text('Weather'), 
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(4), 
        child: Divider(
          color: Colors.blueGrey, 
          height: 4, 
        ),
      ),
    ),

      resizeToAvoidBottomInset: false,

      backgroundColor: Colors.white,
      body: SingleChildScrollView(
      child: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
        color: const Color(0xff6b9dfc).withOpacity(.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              height: size.height * .7,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [Color(0xff6b9dfc), Color(0xff205cf1)],
                stops: [0.0,1.0]
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff6b9dfc).withOpacity(.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                )
              ],
              borderRadius: BorderRadius.circular(20),
              ),
            
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/pin.png", width: 20),
                        const SizedBox(width: 2,),
                        Text(location, style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),),
                        IconButton(
                          onPressed: (){
                            _cityController.clear();
                            showMaterialModalBottomSheet(
                              context: context, 
                              builder: (context)=> SingleChildScrollView(
                                controller: ModalScrollController.of(context),
                                child: Container(
                                  height: size.height * .7,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20, 
                                    vertical: 10,
                                  ),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      width: 70,
                                      child: Divider(
                                        thickness: 3.5,
                                        color: Color(0xff6b9dfc),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      onChanged: (searchText){
                                        fetchWeatherData(searchText);
                                      },
                                      controller: _cityController,
                                      autofocus: true,
                                      scrollPadding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.search, color: Color(0xff6b9dfc),),
                                        suffixIcon: GestureDetector(
                                          onTap: ()=> _cityController.clear(),
                                          child: Icon(Icons.close, color: Color(0xff6b9dfc),),
                                        ),
                                        hintText: 'Search for a city',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff6b9dfc),
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:MediaQuery.of(context).viewInsets.bottom
                                    ),
                                  ],
                                ),
                                ),
                              )
                            );
                          }, 
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      
                    ),
                  ],
                ),
                SizedBox(
                  height: 160,
                  child: Image.asset("assets/" + weatherIcon),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0
                      ),
                      child: Text(
                        temperature.toString(),
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          foreground: Paint()..shader = const LinearGradient(
                            colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
                            ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                        ),
                      ),
                    ),
                    Text(
                      'o',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()..shader = const LinearGradient(
                            colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
                            ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      ),
                    ),
                  ],
                ),
                Text(
                  currentWeatherStatus,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  currentDate,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Divider(
                    color: Colors.white70,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WeatherItem(
                        value: windSpeed.toInt(),
                        unit: 'km/h',
                        imageUrl: 'assets/windspeed.png',
                      ),
                      WeatherItem(
                        value: humidity.toInt(),
                        unit: '%',
                        imageUrl: 'assets/humidity.png',
                      ),
                      WeatherItem(
                        value: cloud.toInt(),
                        unit: '%',
                        imageUrl: 'assets/cloud.png',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, left: 10),
              height: size.height * .20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Today',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      
                    ],
            ),
            const SizedBox(height: 5),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      itemCount: hourlyWeatherForecast.length,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        String currentTime =
                            DateFormat('HH:mm:ss').format(DateTime.now());
                        String currentHour = currentTime.substring(0, 2);

                        String forecastTime = hourlyWeatherForecast[index]
                                ["time"]
                            .substring(11, 16);
                        String forecastHour = hourlyWeatherForecast[index]
                                ["time"]
                            .substring(11, 13);

                        String forecastWeatherName =
                            hourlyWeatherForecast[index]["condition"]["text"];
                        String forecastWeatherIcon = forecastWeatherName
                                .replaceAll(' ', '')
                                .toLowerCase() +
                            ".png";

                        String forecastTemperature =
                            hourlyWeatherForecast[index]["temp_c"]
                                .round()
                                .toString();
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          margin: const EdgeInsets.only(right: 20),
                          width: 65,
                          decoration: BoxDecoration(
                              // color: currentHour == forecastHour
                              //     ? Colors.white
                              //     : Color(0xff6b9dfc),
                              color: Color(0xff6b9dfc),
                              
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 1),
                                  blurRadius: 5,
                                  color:
                                      Color(0xff6b9dfc).withOpacity(.2),
                                ),
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                forecastTime,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Color(0xffd9dadb),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Image.asset(
                                'assets/' + forecastWeatherIcon,
                                width: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    forecastTemperature,
                                    style: TextStyle(
                                      color: Color(0xffd9dadb),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '°',
                                    style: TextStyle(
                                      color: Color(0xffd9dadb),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      fontFeatures: const [
                                        FontFeature.enable('sups'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                 ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class WeatherItem extends StatelessWidget {
  final int value; 
  final String unit;
  final String imageUrl;
  
  const WeatherItem({
    Key? key, required this.value, required this.unit, required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          height: 50,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.asset(imageUrl),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          value.toString() + unit, style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
      );
  }
}
