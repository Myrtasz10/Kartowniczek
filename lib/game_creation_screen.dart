
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:kartowniczek/colors.dart';

class Create extends StatefulWidget {
  const Create({Key? key}) : super(key: key);

  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();

  showSnackBar(String popText) {
    final snackBar =  SnackBar(
      content:  Text(popText),
      duration:  const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  double playerCountValue = 3.0;
  double playerCount = 0.0;
  double giveCountValue = 3.0;
  double giveCount = 0.0;
  String playerOne = '';
  String playerTwo = '';
  String playerThree = '';
  String playerFour = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Nowa gra'),
          centerTitle: true,
          backgroundColor: MyColors.appBarGreen,
        ),
        body: SingleChildScrollView(child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Liczba graczy:",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30),
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Slider(
                                value: playerCountValue,
                                onChanged: (playerCount) {
                                  setState(() {
                                    if (kDebugMode) print(playerCount);
                                    playerCountValue = playerCount;
                                  });
                                },
                                min: 2,
                                max: 4,
                                divisions: 2,
                                activeColor: MyColors.cardRed,
                                inactiveColor: MyColors.azureCyan,
                              ),
                              Text(playerCountValue.toInt().toString())
                            ])),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Imię gracza 1',
                      ),
                      onChanged: (String str) {
                        playerOne = str;
                        if (kDebugMode) print(playerOne);
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Imię gracza 2',
                      ),
                      onChanged: (String str) {
                        playerTwo = str;
                        if (kDebugMode) print(playerTwo);
                      },
                    ),
                    (playerCountValue >= 3)
                        ? TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Imię gracza 3',
                            ),
                            onChanged: (String str) {
                              playerThree = str;
                              if (kDebugMode) print(playerThree);
                            },
                          )
                        : const SizedBox(
                            height: 0,
                            width: 0,
                          ),
                    (playerCountValue == 4)
                        ? TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Imię gracza 4',
                            ),
                            onChanged: (String str) {
                              playerFour = str;
                              if (kDebugMode) print(playerFour);
                            },
                          )
                        : const SizedBox(
                            height: 0,
                            width: 0,
                          ),
                    const SizedBox(height: 30),
                    const Text(
                      "Ile razy można dać po 60?:",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Slider(
                            value: giveCountValue,
                            onChanged: (giveCount) {
                              setState(() {
                                if (kDebugMode) print(giveCount);
                                giveCountValue = giveCount;
                              });
                            },
                            min: 0,
                            max: 5,
                            divisions: 5,
                            activeColor: MyColors.cardRed,
                            inactiveColor: MyColors.azureCyan,
                          ),
                          Text(giveCountValue.toInt().toString())
                        ])
                  ]),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(MyColors.cardRed)),
                  onPressed: () {
                    if(playerOne != '' && playerTwo != ''  && !(playerThree == '' && playerCountValue >= 3) && !(playerFour == '' && playerCountValue == 4)) {
                      Navigator.of(context).pushNamed('/play', arguments: <String> [playerCountValue.toString(), playerOne, playerTwo, playerThree, playerFour, giveCountValue.toString(), DateTime.now().toString()]);
                    } else {
                      showSnackBar("Nazwy graczy nie mogą być puste");
                    }
                  },
                  child: const Text("Rozpocznij grę"),
                ),
              )
            ],
          ),
        )));
  }
}
