import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as HTTP;

import 'coin_data.dart';

const apiKey = '0A09BEE0-6367-4C43-BB41-9AC43AEF1F25';
const coinURL = 'https://rest.coinapi.io/v1/exchangerate/BTC';
//https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=0A09BEE0-6367-4C43-BB41-9AC43AEF1F25

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String exchangeValue = '?';

  @override
  void initState() {
    super.initState();
    getExchangeRate(selectedCurrency);
  }

  Future getExchangeRate(String currency) async {
    String url = '$coinURL/$currency?apikey=$apiKey';
    print(url);
    HTTP.Response response = await HTTP.get(url);
    String data = response.body;
    print(data);
    double rate = jsonDecode(data)['rate']; // path - rate
    setState(() {
      exchangeValue = rate.toStringAsFixed(2);
    });
    //return exchangeValue;
  }

  DropdownButton androidDPicker() {
    List<DropdownMenuItem<String>> dropdownValues = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownValues.add(newItem);
    }

    return DropdownButton(
      value: selectedCurrency,
      items: dropdownValues,
      onChanged: (value) {
        setState(
          () {
            selectedCurrency = value;
            print(selectedCurrency);
            getExchangeRate(selectedCurrency);
          },
        );
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerValues = [];
    for (String index in currenciesList) {
      var newItem = Text(
        index,
        style: TextStyle(
          color: Colors.white,
        ),
      );
      pickerValues.add(newItem);
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          print(selectedIndex);
          selectedCurrency = currenciesList[selectedIndex];
          getExchangeRate(selectedCurrency);
        });
      },
      children: pickerValues,
    );
  }

  // ignore: missing_return
//  Widget getPicker() {
//    if (Platform.isIOS) {
//      return iOSPicker();
//    } else if (Platform.isAndroid) {
//      return androidDPicker();
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $exchangeValue $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDPicker(),
          ),
        ],
      ),
    );
  }
}
