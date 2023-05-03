import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController countryNameEditingController = TextEditingController();
  String desc = 'No Record';
  String countryName = '';
  Image? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Enter the country name",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: countryNameEditingController,
                  decoration: InputDecoration(
                    hintText: "Country Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                      onPressed: _onPressed, child: const Text("Enter")),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 200,
                  width: 380,
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.purpleAccent)),
                  child: Column(
                    children: [
                      if (image != null) image!,
                      Text(
                        desc,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onPressed() async {
    var api_key = "COw8nlx5TyASa9Adm5nmXZVc1pTMfZDw0JHhCbsQ";
    countryName = countryNameEditingController.text;

    var url =
        Uri.parse('https://api.api-ninjas.com/v1/country?name=$countryName');

    var response = await http.get(url, headers: {'X-Api-Key': api_key});
    var rescode = response.statusCode;

    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);

      setState(() {
        if (parsedJson.length > 0) {
          String name = parsedJson[0]['name'];
          String iso = parsedJson[0]['iso2'];
          if (countryName.toUpperCase() == name.toUpperCase() ||
              countryName.toUpperCase() == iso) {
            String capital = parsedJson[0]['capital'];
            String currency = parsedJson[0]['currency']['code'];
            double gdp_growth = parsedJson[0]['gdp_growth'];

            var flatUrl =
                ("https://flagsapi.com/${iso.toUpperCase()}/flat/64.png");
            image = Image.network(flatUrl);
            desc =
                "$name/$iso\nCapital: $capital\nCurrency: $currency\nGDP growth: $gdp_growth";
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Country Not Found'),
                  content: Text(
                      'Please check that the country name is entered correctly.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
            setState(() {
              desc = "Country Not Found";
              image = null;
            });
          }
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Country Not Found'),
                content: Text(
                    'Please check that the country name is entered correctly.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          setState(() {
            desc = "Country Not Found";
            image = null;
          });
        }
      });
    } else {
      // Show dialog for unsuccessful response
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Something went wrong'),
            content: Text('Something went wrong during http request'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      setState(() {
        desc = "Something went wrong";
        image = null;
      });
    }
  }
}
