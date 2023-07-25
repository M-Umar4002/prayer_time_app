import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/prayer_time.dart';

class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  PrayerTime time = PrayerTime();
  TextEditingController cityController = TextEditingController();
  String selectedCity = 'Karachi';

  @override
  void initState() {
    getPrayerTime();
    super.initState();
  }

  Future<void> getPrayerTime() async {
    http.Response response = await http.get(
        Uri.parse("https://dailyprayer.abdulrcs.repl.co/api/$selectedCity"));
    print(response.statusCode);
    print(response.body);

    setState(() {
      time = PrayerTime.fromJson(jsonDecode(response.body));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bg.png"), fit: BoxFit.cover)),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                height: 55,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: _showCityNameTextField()),
            time.city != null
                ? Text(
                    "${time.city}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                : CircularProgressIndicator(),
            const SizedBox(
              height: 10,
            ),
            time.date != null
                ? Text(
                    "${time.date}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                : CircularProgressIndicator(),
            Spacer(),
            _timeCard("Fajr",
                time.today?.fajr != null ? "${time.today?.fajr}" : 'Loading'),
            _timeCard(
                "Sunrise",
                time.today?.sunrise != null
                    ? "${time.today?.sunrise}"
                    : 'Loading'),
            _timeCard("Dhuhr",
                time.today?.dhuhr != null ? "${time.today?.dhuhr}" : 'Loading'),
            _timeCard("Asr",
                time.today?.asr != null ? "${time.today?.asr}" : 'Loading'),
            _timeCard(
                "Maghrib",
                time.today?.maghrib != null
                    ? "${time.today?.maghrib}"
                    : 'Loading'),
            _timeCard("Ishaa",
                time.today?.ishaA != null ? "${time.today?.ishaA}" : 'Loading'),
            const SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }

  Widget _timeCard(String name, String time) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black.withOpacity(0.4)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            const Icon(
              Icons.timer_outlined,
              color: Colors.white,
              size: 25,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        Text(
          time,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ]),
    );
  }

  Widget _showCityNameTextField() {
    return TextField(
      controller: cityController,
      cursorColor: Colors.white,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.white)),
          hintText: 'Type your city',
          hintStyle: TextStyle(color: Colors.white),
          suffix: IconButton(
              onPressed: () {
                setState(() {
                  selectedCity = cityController.text;
                  getPrayerTime();
                  cityController.clear();
                });
              },
              icon: Icon(
                Icons.send,
                color: Colors.white,
              ))),
    );
  }
}
