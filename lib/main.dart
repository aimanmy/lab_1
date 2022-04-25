import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitcoin CryptoCurrency APP',
      theme : ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bitcoin CryptoCurrency APP'),
        ),
        body: const MyBitcoinPage(),
      ),
    );
  }
}

class MyBitcoinPage extends StatefulWidget {
  const MyBitcoinPage({ Key? key }) : super(key: key);

  @override
  State<MyBitcoinPage> createState() => _MyBitcoinPageState();
}

class _MyBitcoinPageState extends State<MyBitcoinPage> {
  TextEditingController textEditingController = TextEditingController();

  String cryptoUnit= "btc", fiatUnit = "usd", desc = "",nameValue ="", unitValue = "", nameValue2 ="", unitValue2 = "";
  double valueRate2 = 0.0, numText=0.0 ,resultChange = 0.0; 
  double holdValue = 0.0;

  List <String> cryptoList = [
    //Crypto
    "btc","eth", "ltc","bch","bnb","eos","xrp","xlm","link","dot","yfi","bits","sats",
    
  ];
  List <String> fiatList=[
    //fiat
    "usd","aed","ars","aud","bdt","bhd","bmd","brl","cad","chf","clp","cny","czk","dkk","eur",
    "gbp","hkd","huf","idr","ils","inr","jpy","krw","kwd","lkr","mmk","mxn","myr","ngn","nok",
    "nzd","php","pkr","pln","rub","sar","sek","sgd","thb","try","twd","uah","vef","vnd","zar",
    "xdr","xag","xau",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              SingleChildScrollView(child: Flexible(flex:5, child: Image.asset('assets/images/coin_image.png',scale:2))),
              const Text(
                "Bitcoin CryptoCurrency", 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(controller: textEditingController,
              decoration: InputDecoration(
                hintText: "Enter Value",
                border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0))),
                keyboardType: const TextInputType.numberWithOptions(),),

              const SizedBox(height:10),
              const Text("CRYPTO UNIT",style: TextStyle(fontSize: 12,fontWeight:FontWeight.bold)),

              DropdownButton(
                itemHeight: 60,
                value : cryptoUnit,
                onChanged: (newValue){
                  setState((){
                    cryptoUnit = newValue.toString();
                  });
                },
                items: cryptoList.map((cryptoUnit){
                  return DropdownMenuItem(
                    child: Text(
                      cryptoUnit,
                    ),
                    value: cryptoUnit,
                  );
                }).toList(),
              ),
        
              const SizedBox(height:10),
              const Text("EXCHANGE TO",style: TextStyle(fontSize: 12,fontWeight:FontWeight.bold)),
              DropdownButton(
                value : fiatUnit,
                itemHeight: 60,
                onChanged: (newValue){
                  setState((){
                    fiatUnit = newValue.toString();
                  });
                },
                items: fiatList.map((fiatUnit){
                  return DropdownMenuItem(
                    child: Text(
                      fiatUnit,
                    ),
                    value: fiatUnit,
                  );
                }).toList(),
        
              ),
              ElevatedButton(
                onPressed: _loadCurrency, child: const Text("LOAD CURRENCY")),
                const SizedBox(height: 10),
                Text(desc,style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        )
      )
    );
  }

  Future<void> _loadCurrency() async {
    var url = Uri.parse('https://api.coingecko.com/api/v3/exchange_rates');
    var response = await http.get(url);
    var resocde = response.statusCode;

    if(resocde == 200){
      var jsonData = response.body;
      var parsedData = json.decode(jsonData);
      nameValue = parsedData['rates'][cryptoUnit.toString()]['name'];
      unitValue = parsedData['rates'][cryptoUnit.toString()]['unit'];
      valueRate2 = parsedData['rates'][fiatUnit.toString()]['value'];
      nameValue2 = parsedData['rates'][fiatUnit.toString()]['name'];
      unitValue2 = parsedData['rates'][fiatUnit.toString()]['unit'];
      setState((){
        numText = double.parse(textEditingController.text); 
        resultChange = valueRate2 * numText;
        desc = "The Exchange Currency From $numText $cryptoUnit($nameValue Currency) to $fiatUnit ($nameValue2 Currency) is $resultChange$unitValue2 ";
      });
    }else{
      setState((){
        desc = "No record";
      });
    }
  }
}

