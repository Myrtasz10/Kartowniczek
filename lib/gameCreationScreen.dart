import 'package:flutter/material.dart';
import 'package:kartowniczek/Colors.dart';

class Create extends StatefulWidget {
  @override
  _CreateState createState() => _CreateState();
}

class _CreateState extends State<Create> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  showSnackBar(String popText) {
    final snackBar = new SnackBar(
      content: new Text(popText),
      duration: new Duration(seconds: 3),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
//TODO: I. WANT. A TOAST. PERIOD.
  double playerCountValue = 3.0;
  double playerCount;
  double giveCountValue = 3.0;
  double giveCount;
  String playerOne = '';
  String playerTwo = '';
  String playerThree = '';
  String playerFour = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Nowa gra'),
          centerTitle: true,
          backgroundColor: MyColors.appBarGreen,
        ),
        body: SingleChildScrollView(child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
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
                                    print(playerCount);
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
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Imię gracza 1',
                      ),
                      onChanged: (String str) {
                        playerOne = str;
                        print(playerOne);
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Imię gracza 2',
                      ),
                      onChanged: (String str) {
                        playerTwo = str;
                        print(playerTwo);
                      },
                    ),
                    (playerCountValue >= 3)
                        ? TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Imię gracza 3',
                            ),
                            onChanged: (String str) {
                              playerThree = str;
                              print(playerThree);
                            },
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                    (playerCountValue == 4)
                        ? TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Imię gracza 4',
                            ),
                            onChanged: (String str) {
                              playerFour = str;
                              print(playerFour);
                            },
                          )
                        : Container(
                            height: 0,
                            width: 0,
                          ),
                    SizedBox(height: 30),
                    Text(
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
                                print(giveCount);
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
                  child: Text("Rozpocznij grę"),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(MyColors.cardRed)),
                  onPressed: () {
                    if(playerOne != '' && playerTwo != ''  && !(playerThree == '' && playerCountValue >= 3) && !(playerFour == '' && playerCountValue == 4)) {
                      Navigator.of(context).pushNamed('/play', arguments: <String> [playerCountValue.toString(), playerOne, playerTwo, playerThree, playerFour, giveCountValue.toString(), DateTime.now().toString()]);
                    } else {
                      showSnackBar("Nazwy graczy nie mogą być puste");
                    }
                  },
                ),
              )
            ],
          ),
        )));
  }
}
