// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './Colors.dart';
import './stats.dart';

class GameScreen extends StatefulWidget {
  final List<String> data;

  const GameScreen({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AppSettings settings = AppSettings();

  showSnackBar(String popText) {
    final snackBar = SnackBar(
      content: Text(popText),
      duration: const Duration(seconds: 3),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void readBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (key == 'autoDelete') {
        settings.autoDelete = prefs.getBool(key) ?? false;
      }
    });
  }

  Future<bool> _onWillPop() async {
    print("Quit dialog shown");
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Wyjść bez zapisywania?'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget> [const Text(
                'Dane gry zostaną utracone, jeśli nie zostały wcześniej zapisane.'),
            Container(height: 10),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Nie'),
              ),
              TextButton(
                onPressed: () {
                  if (roundsCompleting != 1) {
                    _showSavePrompt();
                  } else {
                    showSnackBar("Brak danych do zapisania");
                  }
                },
                child: const Text('Zapisz i wyjdź'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Tak'),
              ),
            ])],
          )),
        )) ??
        false;
  }

  Future<List<String>> _getGamesFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final savedGame = prefs.getStringList("gameFile"); //getstringlist zamiast get żeby rozwiązać List<dynamic>' is not a subtype of type 'FutureOr<List<String>>'
    if (savedGame == null) {
      return [];
    }
    return savedGame;
  }

  Future<void> addGame(String file) async {
    final prefs = await SharedPreferences.getInstance();
    final currentSaves = await _getGamesFromSharedPref();
    currentSaves.add(file);
    await prefs.setStringList("gameFile", currentSaves);
  }

  //DONE: give extra testing cause this could corrupt everything
  Future<void> deleteGames(String timeIndex) async {
    final prefs = await SharedPreferences.getInstance();
    final savedGame = prefs.getStringList("gameFile");
    print(savedGame);
    List<String> newSavedGame = [];
    savedGame.forEach((element) {
      print("we lookin' at:");
      print(element.substring(element.lastIndexOf('#')+1));
      if (element.substring(element.lastIndexOf('#')+1) != timeIndex) {
        newSavedGame.add(element);
      } else {
        print("This boi rejected:");
        print(element);
      }
    });
    print("Removing from $savedGame at... I don't really know. Anyway, the new Value is $newSavedGame");
    await prefs.setStringList("gameFile", newSavedGame);
  }

  Future<List<String>> _getStatsFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStats = prefs.getStringList("statFile"); //getstringlist zamiast get żeby rozwiązać List<dynamic>' is not a subtype of type 'FutureOr<List<String>>'
    if (savedStats == null) {
      return [];
    }
    return savedStats;
  }

  Future<void> addStat(String statRow) async {
    final prefs = await SharedPreferences.getInstance();
    final currentStats = await _getStatsFromSharedPref();
    currentStats.add(statRow);
    await prefs.setStringList("statFile", currentStats);
  }

  //instead of widget.data[i]
  String playerCount;
  List<String> playerName;
  String playerGive;
  String timeIndex;

  List<int> playerGiveRemaining;
  List<int> playerGiveHistory = [];
  List<Widget> rounds = [const SizedBox(height: 0, width: 0)];
  int roundsCompleting = 1;
  String playerOneAdd = "";
  String playerTwoAdd = "";
  String playerThreeAdd = "";
  String playerFourAdd = "";
  List<List<int>> score = [[], [], [], []];
  List<int> renderingScores = [0, 0, 0, 0];
  List<bool> playerGiving = [false, false, false, false];
  String errorText = "";
  int winner = -1;
  int selected = 1;
  var scoreListController = ScrollController();

  String savedGame;

  void getSave() async {
    var tempList = await _getGamesFromSharedPref();
    savedGame = tempList[0];
    print(savedGame);
  }

  void _showSavePrompt() {
    AlertDialog dialog = AlertDialog(
      title: const Text(
        "Zapisz grę",
        textAlign: TextAlign.center,
      ),
      content: AspectRatio(
          aspectRatio: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RawMaterialButton(
                    fillColor: Colors.green,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      print(selected);
                      selected = 1;
                      Navigator.pop(context);
                      _showSavePrompt();
                    },
                    shape: const CircleBorder(),
                    child: selected == 1
                        ? const Icon(Icons.check, size: 40)
                        : const SizedBox(height: 40, width: 40),
                  ),
                  RawMaterialButton(
                    fillColor: Colors.blue,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      print(selected);
                      selected = 2;
                      Navigator.pop(context);
                      _showSavePrompt();
                    },
                    shape: const CircleBorder(),
                    child: selected == 2
                        ? const Icon(Icons.check, size: 40)
                        : const SizedBox(height: 40, width: 40),
                  ),
                  RawMaterialButton(
                    fillColor: Colors.purple,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      print(selected);
                      selected = 3;
                      Navigator.pop(context);
                      _showSavePrompt();
                    },
                    shape: const CircleBorder(),
                    child: selected == 3
                        ? const Icon(Icons.check, size: 40)
                        : const SizedBox(height: 40, width: 40),
                  ),
                  RawMaterialButton(
                    fillColor: Colors.pink,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      print(selected);
                      selected = 4;
                      Navigator.pop(context);
                      _showSavePrompt();
                    },
                    shape: const CircleBorder(),
                    child: selected == 4
                        ? const Icon(Icons.check, size: 40)
                        : const SizedBox(height: 40, width: 40),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RawMaterialButton(
                    fillColor: Colors.yellow,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      print(selected);
                      selected = 5;
                      Navigator.pop(context);
                      _showSavePrompt();
                    },
                    shape: const CircleBorder(),
                    child: selected == 5
                        ? const Icon(Icons.check, size: 40)
                        : const SizedBox(height: 40, width: 40),
                  ),
                  RawMaterialButton(
                    fillColor: Colors.red,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      print(selected);
                      selected = 6;
                      Navigator.pop(context);
                      _showSavePrompt();
                    },
                    shape: const CircleBorder(),
                    child: selected == 6
                        ? const Icon(Icons.check, size: 40)
                        : const SizedBox(height: 40, width: 40),
                  ),
                  RawMaterialButton(
                    fillColor: Colors.white,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      print(selected);
                      selected = 7;
                      Navigator.pop(context);
                      _showSavePrompt();
                    },
                    shape: const CircleBorder(),
                    child: selected == 7
                        ? const Icon(Icons.check, size: 40)
                        : const SizedBox(height: 40, width: 40),
                  ),
                  RawMaterialButton(
                    fillColor: Colors.blueGrey,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      print(selected);
                      selected = 8;
                      Navigator.pop(context);
                      _showSavePrompt();
                    },
                    shape: const CircleBorder(),
                    child: selected == 8
                        ? const Icon(Icons.check, size: 40)
                        : const SizedBox(height: 40, width: 40),
                  ),
                ],
              ),
            ],
          )),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("anuluj", style: TextStyle(color: MyColors.azureCyan))),
        TextButton(
            onPressed: () {
              print("Saving following scores: $score");
              addGame(toMyrtaszString(
                  score,
                  roundsCompleting,
                  [playerName[0], playerName[1], playerName[2], playerName[3]],
                  playerGiveRemaining,
                  playerGiveHistory,
                  selected,
                  (double.parse(playerCount)).toInt(),
              timeIndex));
              print("popped");
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/tysiąc');
            },
            child: const Text("zapisz i wyjdź",
                style: TextStyle(color: MyColors.azureCyan))),
      ],
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  void _showDeletePrompt() {
    AlertDialog dialog = AlertDialog(
      title: const Text("Usunąć ostatnią rundę?", textAlign: TextAlign.center),
      content: const Text("Tej czynności nie będzie można cofnąć.",
          textAlign: TextAlign.center),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("anuluj", style: TextStyle(color: MyColors.azureCyan))),
        TextButton(
            onPressed: () {
              print("Analyzing data");
              print(roundsCompleting);
              print(score);
              print(rounds);
              --roundsCompleting;
              score[0].removeLast();
              score[1].removeLast();
              //makes a mess for sure, but at least it works
              if (double.parse(playerCount) >= 3.0) {
                score[2].removeLast();
              }
              if (double.parse(playerCount) == 4) {
                score[3].removeLast();
              }
              setState(() {
                rounds.removeLast();
              });
              setState(() {
                if (playerGiveHistory[playerGiveHistory.length - 1] != -1) {
                  ++playerGiveRemaining[
                      playerGiveHistory[playerGiveHistory.length - 1]];
                }
                playerGiveHistory.removeLast();
              });
              Navigator.pop(context);
              // ignore: invalid_use_of_protected_member
            },
            child:
                const Text("potwierdź", style: TextStyle(color: MyColors.azureCyan))),
      ],
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  void _showAlert() {
    playerOneAdd = '';
    playerTwoAdd = '';
    playerThreeAdd = '';
    playerFourAdd = '';
    AlertDialog dialog = AlertDialog(
      title: Text(
        "Koniec rundy $roundsCompleting",
        textAlign: TextAlign.center,
      ),
      content: Column(children: <Widget>[
        const Text(
          "Uzyskane punkty:",
          textAlign: TextAlign.center,
        ),
        Row(
          children: <Widget>[
            Column(children: <Widget>[
              SizedBox(
                  width: MediaQuery.of(context).size.width /
                      double.parse(playerCount) *
                      2/3,
                  child: Text(
                    playerName[0],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  )),
              SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width /
                      double.parse(playerCount) *
                      2/3,
                  child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: "0"),
                    onChanged: (String str) {
                      playerOneAdd = str;
                      print(playerOneAdd);
                    },
                  )),
              IconButton(
                  icon: Tab(
                      icon: Image.asset(playerGiving[0]
                          ? "./images/giveSelected.png"
                          : "./images/give.png")),
                  onPressed: () {
                    errorText = "";
                    playerGiving[0] = !playerGiving[0];
                    playerGiving = [playerGiving[0], false, false, false];
                    print(playerGiving[0]);
                    Navigator.of(context).pop();
                    _showAlert();
                  })
            ]),
            Column(children: <Widget>[
              SizedBox(
                  width: MediaQuery.of(context).size.width /
                      double.parse(playerCount) *
                      2/3,
                  child: Text(
                    playerName[1],
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  )),
              SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width /
                      double.parse(playerCount) *
                      2/3,
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '0',
                    ),
                    onChanged: (String str) {
                      playerTwoAdd = str;
                      print(playerTwoAdd);
                    },
                  )),
              IconButton(
                  icon: Tab(
                      icon: Image.asset(playerGiving[1]
                          ? "./images/giveSelected.png"
                          : "./images/give.png")),
                  onPressed: () {
                    errorText = "";
                    playerGiving[1] = !playerGiving[1];
                    playerGiving = [false, playerGiving[1], false, false];
                    print(playerGiving[1]);
                    Navigator.of(context).pop();
                    _showAlert();
                  })
            ]),
            double.parse(playerCount) >= 3.0
                ? Column(children: <Widget>[
                    SizedBox(
                        width: MediaQuery.of(context).size.width /
                            double.parse(playerCount) *
                            0.688,
                        child: Text(
                          playerName[2],
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        )),
                    SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width /
                            double.parse(playerCount) *
                            2/3,
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '0',
                          ),
                          onChanged: (String str) {
                            playerThreeAdd = str;
                            print(playerThreeAdd);
                          },
                        )),
                    IconButton(
                        icon: Tab(
                            icon: Image.asset(playerGiving[2]
                                ? "./images/giveSelected.png"
                                : "./images/give.png")),
                        onPressed: () {
                          errorText = "";
                          playerGiving[2] = !playerGiving[2];
                          playerGiving = [false, false, playerGiving[2], false];
                          print(playerGiving[2]);
                          Navigator.of(context).pop();
                          _showAlert();
                        })
                  ])
                : const SizedBox(width: 0, height: 0),
            double.parse(playerCount) == 4.0
                ? Column(children: <Widget>[
                    SizedBox(
                        width: MediaQuery.of(context).size.width /
                            double.parse(playerCount) *
                            2/3,
                        child: Text(
                          playerName[3],
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        )),
                    SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width /
                            double.parse(playerCount) *
                            2/3,
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '0',
                          ),
                          onChanged: (String str) {
                            playerFourAdd = str;
                            print(playerFourAdd);
                          },
                        )),
                    IconButton(
                        icon: Tab(
                            icon: Image.asset(playerGiving[3]
                                ? "./images/giveSelected.png"
                                : "./images/give.png")),
                        onPressed: () {
                          errorText = "";
                          playerGiving[3] = !playerGiving[3];
                          playerGiving = [false, false, false, playerGiving[3]];
                          print(playerGiving[3]);
                          Navigator.of(context).pop();
                          _showAlert();
                        })
                  ])
                : const SizedBox(width: 0, height: 0)
          ],
        ),
        //przepraszam, mamo
        Text(playerGiving[0]
            ? "${playerName[0]} daje po 60. Pola tekstowe nie będą brane pod uwagę."
            : (playerGiving[1]
                ? "${playerName[1]} daje po 60. Pola tekstowe nie będą brane pod uwagę."
                : (playerGiving[2]
                    ? "${playerName[2]} daje po 60. Pola tekstowe nie będą brane pod uwagę."
                    : (playerGiving[3]
                        ? "${playerName[3]} daje po 60. Pola tekstowe nie będą brane pod uwagę."
                        : "")))),
        Expanded(
            child: SingleChildScrollView(
                child: Text(
          errorText,
          style: const TextStyle(color: MyColors.cardRed),
        )))
      ]),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("anuluj", style: TextStyle(color: MyColors.azureCyan))),
        TextButton(
            onPressed: () {
              print(score);
              if (playerOneAdd == "") {
                playerOneAdd = "0";
              }
              if (playerTwoAdd == "") {
                playerTwoAdd = "0";
              }
              if (playerThreeAdd == "") {
                playerThreeAdd = "0";
              }
              if (playerFourAdd == "") {
                playerFourAdd = "0";
              }
              if (playerGiveRemaining[0] == 0 && playerGiving[0] ||
                  playerGiveRemaining[1] == 0 && playerGiving[1] ||
                  playerGiveRemaining[2] == 0 && playerGiving[2] ||
                  playerGiveRemaining[3] == 0 && playerGiving[3]) {
                print("Intercepted");
                errorText = "Ten gracz nie może już więcej dawać po 60";
                Navigator.pop(context);
                _showAlert();
              } else if (int.tryParse(playerOneAdd) == null ||
                  int.tryParse(playerTwoAdd) == null ||
                  int.tryParse(playerThreeAdd) == null ||
                  int.tryParse(playerFourAdd) == null) {
                errorText = "Wprowadź prawidłowe wyniki";
                Navigator.pop(context);
                _showAlert();
              }
              // else if (int.parse(playerOneAdd).abs() <= 4 &&
              //     int.parse(playerTwoAdd).abs() <= 4 &&
              //     int.parse(playerThreeAdd).abs() <= 4 &&
              //     int.parse(playerFourAdd).abs() <= 4 &&
              //     playerGiving[0] == false &&
              //     playerGiving[1] == false &&
              //     playerGiving[2] == false &&
              //     playerGiving[3] == false) {
              //   errorText =
              //       "Co najmniej jeden gracz musiał zdobyć lub stracić punkty";
              //   Navigator.pop(context);
              //   _showAlert();
              // }
              else if ((sumAll(score[0]) >= 900 &&
                          int.parse(playerOneAdd) > 0 &&
                          int.parse(playerOneAdd) < 100 ||
                      sumAll(score[1]) >= 900 &&
                          int.parse(playerTwoAdd) > 0 &&
                          int.parse(playerTwoAdd) < 100 ||
                      sumAll(score[2]) >= 900 &&
                          int.parse(playerThreeAdd) > 0 &&
                          int.parse(playerThreeAdd) < 100 ||
                      sumAll(score[3]) >= 900 &&
                          int.parse(playerFourAdd) > 0 &&
                          int.parse(playerFourAdd) < 100) &&
                  playerGiving[0] == false &&
                  playerGiving[1] == false &&
                  playerGiving[2] == false &&
                  playerGiving[3] == false) {
                print(playerOneAdd +
                    playerTwoAdd +
                    playerThreeAdd +
                    playerFourAdd);
                errorText =
                    "Kiedy suma punktów gracza przekracza 900, może on zdobyć punkty tylko poprzez wygranie rundy, w której był rozgrywającym.";
                Navigator.pop(context);
                _showAlert();
              } else if ((int.parse(playerOneAdd).abs() > 300 && int.parse(playerOneAdd).abs() != 1000) ||
              (int.parse(playerTwoAdd).abs() > 300 && int.parse(playerTwoAdd).abs() != 1000)  ||
              (int.parse(playerThreeAdd).abs() > 300 && int.parse(playerThreeAdd).abs() != 1000)  ||
              (int.parse(playerFourAdd).abs() > 300) && int.parse(playerFourAdd).abs() != 1000)  {
                errorText =
                    "Największa możliwa liczba punktów do zdobycia to 300";

                Navigator.pop(context);
                _showAlert();
              } else {
                errorText = "";
                if (playerGiving[0]) {
                  if (sumAll(score[1]) < 900) {
                    score[1].add(60);
                  } else {
                    score[1].add(0);
                  }
                  if (double.parse(playerCount) >= 3.0 &&
                      sumAll(score[2]) < 900) {
                    score[2].add(60);
                  } else {
                    score[2].add(0);
                  }
                  if (double.parse(playerCount) == 4.0 &&
                      sumAll(score[3]) < 900) {
                    score[3].add(60);
                  } else {
                    score[3].add(0);
                  }
                  score[0].add(0);
                  playerGiveRemaining[0]--;
                  playerGiveHistory.add(0);
                } else if (playerGiving[1]) {
                  if (sumAll(score[0]) < 900) {
                    score[0].add(60);
                  } else {
                    score[0].add(0);
                  }
                  if (double.parse(playerCount) >= 3.0 &&
                      sumAll(score[2]) < 900) {
                    score[2].add(60);
                  } else {
                    score[2].add(0);
                  }
                  if (double.parse(playerCount) == 4.0 &&
                      sumAll(score[3]) < 900) {
                    score[3].add(60);
                  } else {
                    score[3].add(0);
                  }
                  score[1].add(0);
                  playerGiveRemaining[1]--;
                  playerGiveHistory.add(1);
                } else if (playerGiving[2]) {
                  if (sumAll(score[0]) < 900) {
                    score[0].add(60);
                  } else {
                    score[0].add(0);
                  }
                  if (sumAll(score[1]) < 900) {
                    score[1].add(60);
                  } else {
                    score[1].add(0);
                  }
                  if (double.parse(playerCount) == 4.0 &&
                      sumAll(score[3]) < 900) {
                    score[3].add(60);
                  } else {
                    score[3].add(0);
                  }
                  score[2].add(0);
                  playerGiveRemaining[2]--;
                  playerGiveHistory.add(2);
                } else if (playerGiving[3]) {
                  if (sumAll(score[0]) < 900) {
                    score[0].add(60);
                  } else {
                    score[0].add(0);
                  }
                  if (sumAll(score[1]) < 900) {
                    score[1].add(60);
                  } else {
                    score[1].add(0);
                  }
                  if (sumAll(score[2]) < 900) {
                    score[2].add(60);
                  } else {
                    score[2].add(0);
                  }
                  score[3].add(0);
                  playerGiveRemaining[3]--;
                  playerGiveHistory.add(3);
                } else {
                  playerGiveHistory.add(-1);
                  score[0].add(
                      (double.parse(playerOneAdd) / 10).round().toInt() * 10);
                  score[1].add(
                      (double.parse(playerTwoAdd) / 10).round().toInt() * 10);
                  score[2].add(
                      (double.parse(playerThreeAdd) / 10).round().toInt() * 10);
                  score[3].add(
                      (double.parse(playerFourAdd) / 10).round().toInt() * 10);
                }
                setState(() {
                  rounds.add(ScoreRow(
                      roundsCompleting,
                      sumAll(score[0]),
                      sumAll(score[1]),
                      sumAll(score[2]),
                      sumAll(score[3]),
                      int.parse(double.parse(playerCount).round().toString())));
                });

                Future.delayed(const Duration(milliseconds: 250), () {
                  print("Scrolling at 0");
                  scoreListController
                      .jumpTo(scoreListController.position.maxScrollExtent);
                });
                playerGiving = [false, false, false, false];
                roundsCompleting++;
                playerOneAdd = "";
                playerTwoAdd = "";
                playerThreeAdd = "";
                playerFourAdd = "";
                if (sumAll(score[0]) >= 1000) {
                  winner = 0;
                }
                if (sumAll(score[1]) >= 1000) {
                  winner = 1;
                }
                if (sumAll(score[2]) >= 1000) {
                  winner = 2;
                }
                if (sumAll(score[3]) >= 1000) {
                  winner = 3;
                }
                Navigator.pop(context);
                print(rounds);
                // ignore: invalid_use_of_protected_member
                (context as Element).reassemble();
              }
            },
            child:
                const Text("potwierdź", style: TextStyle(color: MyColors.azureCyan))),
      ],
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  @override
  void initState() {
    //read settings - czy autoDelete = true?
    readBool('autoDelete');

    if (widget.data[0] != '-1') {
      playerCount = widget.data[0];
      playerName = [
        widget.data[1],
        widget.data[2],
        widget.data[3],
        widget.data[4]
      ];
      playerGive = widget.data[5];
      timeIndex = widget.data[6];
      playerGiveRemaining = [
        int.parse(double.parse(playerGive).round().toString()),
        int.parse(double.parse(playerGive).round().toString()),
        int.parse(double.parse(playerGive).round().toString()),
        int.parse(double.parse(playerGive).round().toString()),
      ];
    } else {
      //problem z przypisaniem po migracji? użyj decoded[i] as List<int> jako jawne castowanie
      List<Object> decoded = myrtaszDecode(widget.data[1]);
      score = decoded[1];
      playerCount = decoded[5].toString();
      playerName = decoded[2];
      playerGiveRemaining = decoded[3];
      playerGiveHistory = decoded[4];
      roundsCompleting = decoded[6];
      timeIndex = decoded[7];
      print("Will now render for $score");
      rounds.add(ScoreRow(
          1, score[0][0], score[1][0], score[2][0], score[3][0], decoded[5]));
      for (int i = 1; i < roundsCompleting - 1; i++) {
        print(i);
        for (int j = 0; j < i; j++) {
          //ostra czy słaba?
          renderingScores[0] += score[0][j];
          renderingScores[1] += score[1][j];
          renderingScores[2] += score[2][j];
          renderingScores[3] += score[3][j];
        }
        rounds.add(ScoreRow(
            i + 1,
            score[0][i] + renderingScores[0],
            score[1][i] + renderingScores[1],
            score[2][i] + renderingScores[2],
            score[3][i] + renderingScores[3],
            decoded[5]));
        renderingScores = [0, 0, 0, 0];
      }
    }
    print(playerGiveRemaining);
    print(rounds);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text('Kartowniczek - tysiąc'),
            centerTitle: true,
            backgroundColor: MyColors.appBarGreen,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(children: <Widget>[
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width / 7,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(
                                      width: 3, color: Colors.black54),
                                )),
                                child: const Center(child: Text("po 60")))),
                        Expanded(
                            flex: 3,
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    border: Border(
                                  left: BorderSide(
                                      width: 3, color: Colors.black54),
                                  bottom: BorderSide(
                                      width: 3, color: Colors.black54),
                                )),
                                child: Center(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                      Text(playerGiveRemaining[0].toString()),
                                      Container(width: 10),
                                      Image.asset('./images/give.png')
                                    ])))),
                        Expanded(
                            flex: 3,
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    border: Border(
                                  left: BorderSide(
                                      width: 3, color: Colors.black54),
                                  bottom: BorderSide(
                                      width: 3, color: Colors.black54),
                                )),
                                child: Center(
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                      Text(playerGiveRemaining[1].toString()),
                                      Container(width: 10),
                                      Image.asset('./images/give.png')
                                    ])))),
                        double.parse(playerCount) >= 3.0
                            ? Expanded(
                                flex: 3,
                                child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                      left: BorderSide(
                                          width: 3, color: Colors.black54),
                                      bottom: BorderSide(
                                          width: 3, color: Colors.black54),
                                    )),
                                    child: Center(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                          Text(playerGiveRemaining[2]
                                              .toString()),
                                          Container(width: 10),
                                          Image.asset('./images/give.png')
                                        ]))))
                            : const SizedBox(width: 0, height: 0),
                        double.parse(playerCount) == 4.0
                            ? Expanded(
                                flex: 3,
                                child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                      left: BorderSide(
                                          width: 3, color: Colors.black54),
                                      bottom: BorderSide(
                                          width: 3, color: Colors.black54),
                                    )),
                                    child: Center(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                          Text(playerGiveRemaining[3]
                                              .toString()),
                                          Container(width: 10),
                                          Image.asset('./images/give.png')
                                        ]))))
                            : const SizedBox(width: 0, height: 0)
                      ],
                    )),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width / 7,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(
                                      width: 3, color: Colors.black54),
                                )),
                                child: const Center(child: Text("Runda")))),
                        Expanded(
                            flex: 3,
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    border: Border(
                                  left: BorderSide(
                                      width: 3, color: Colors.black54),
                                  bottom: BorderSide(
                                      width: 3, color: Colors.black54),
                                )),
                                child: Center(child: Text(playerName[0], textAlign: TextAlign.center)))),
                        Expanded(
                            flex: 3,
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    border: Border(
                                  left: BorderSide(
                                      width: 3, color: Colors.black54),
                                  bottom: BorderSide(
                                      width: 3, color: Colors.black54),
                                )),
                                child: Center(child: Text(playerName[1], textAlign: TextAlign.center)))),
                        double.parse(playerCount) >= 3.0
                            ? Expanded(
                                flex: 3,
                                child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                      left: BorderSide(
                                          width: 3, color: Colors.black54),
                                      bottom: BorderSide(
                                          width: 3, color: Colors.black54),
                                    )),
                                    child: Center(child: Text(playerName[2], textAlign: TextAlign.center))))
                            : const SizedBox(width: 0, height: 0),
                        double.parse(playerCount) == 4.0
                            ? Expanded(
                                flex: 3,
                                child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                      left: BorderSide(
                                          width: 3, color: Colors.black54),
                                      bottom: BorderSide(
                                          width: 3, color: Colors.black54),
                                    )),
                                    child: Center(child: Text(playerName[3], textAlign: TextAlign.center))))
                            : const SizedBox(width: 0, height: 0)
                      ],
                    )),
              ]),
              Expanded(
                  child: SingleChildScrollView(
                      controller: scoreListController,
                      child: Column(children: rounds))),
              Container(
                  decoration: const BoxDecoration(
                      color: MyColors.background,
                      border: Border(
                          top: BorderSide(
                              color: MyColors.highlightOrange, width: 1))),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 2.5,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        winner == -1
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(child:
                                    Text(
                                        "Rozdaje ${playerName[(roundsCompleting - 1) %
                                                int.parse(
                                                    double.parse(playerCount)
                                                        .round()
                                                        .toString())]}",
                                        textAlign: TextAlign.center, overflow: TextOverflow.clip)),
                                    Row(children: <Widget>[
                                      IconButton(
                                          icon: const Icon(Icons.delete),
                                          color: MyColors.azureCyan,
                                          onPressed: () {
                                            if (roundsCompleting > 1) {
                                              _showDeletePrompt();
                                            } else {
                                              showSnackBar(
                                                  "Brak rund do usunięcia");
                                            }
                                          }),
                                      IconButton(
                                          icon: const Icon(Icons.save_alt),
                                          color: MyColors.azureCyan,
                                          onPressed: () {
                                            if (roundsCompleting != 1) {
                                              _showSavePrompt();
                                            } else {
                                              showSnackBar(
                                                  "Brak danych do zapisania");
                                            }
                                          })
                                    ])
                                  ])
                            : const SizedBox(height: 0, width: 0),
                        Container(height: 20),
                        winner == -1
                            ? Expanded(
                                child: ElevatedButton(
                                onPressed: () {
                                  _showAlert();
                                  print(playerGiving[0]);
                                  print(MediaQuery.of(context).size.width);
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        MyColors.cardRed)),
                                child: const Text("Koniec rundy"),
                              ))
                            : Expanded(
                                child: ElevatedButton(
                                onPressed: () {
                                  addStat(jsonEncode(StatRow((double.parse(playerCount)).toInt(), playerName[0], playerName[1], playerName[2], playerName[3], playerName[winner])));
                                  print("Added ${jsonEncode(StatRow((double.parse(playerCount)).toInt(), playerName[0], playerName[1], playerName[2], playerName[3], playerName[winner]))}");
                                  Navigator.popUntil(context, ModalRoute.withName('/'));
                                  Navigator.of(context).pushNamed('/');
                                  print("Will now try and delete corresponding save files");
                                  print("Autodelete: ${settings.autoDelete}");
                                  //usunięcie wszystkich odpowiadających plików z zapisem
                                  if (settings.autoDelete) {
                                    print("Running deleteGames");
                                    deleteGames(timeIndex);
                                    print("Obsolete saves deleted successfully");
                                  }
                                  //DONE: jak zrobić żeby dało do main screen? pop all cards? //to powinno zadziałać
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        MyColors.highlightOrange)),
                                child: Text("${playerName[winner]} wygrywa! Wciśnij, aby zakończyć."),
                              )),
                      ])),
            ],
          ),
        ));
  }
}

class ScoreRow extends StatelessWidget {
  final int round;
  final int playerOneScore;
  final int playerTwoScore;
  final int playerThreeScore;
  final int playerFourScore;
  final int playerCount;

  const ScoreRow(this.round, this.playerOneScore, this.playerTwoScore,
      this.playerThreeScore, this.playerFourScore, this.playerCount);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 7,
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        border: Border(
                      bottom: BorderSide(width: 3, color: Colors.black54),
                    )),
                    child: Center(child: Text(round.toString())))),
            Expanded(
                flex: 3,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        border: Border(
                      left: BorderSide(width: 3, color: Colors.black54),
                      bottom: BorderSide(width: 3, color: Colors.black54),
                    )),
                    child: Center(child: Text(playerOneScore.toString())))),
            Expanded(
                flex: 3,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        border: Border(
                      left: BorderSide(width: 3, color: Colors.black54),
                      bottom: BorderSide(width: 3, color: Colors.black54),
                    )),
                    child: Center(child: Text(playerTwoScore.toString())))),
            playerCount >= 3
                ? Expanded(
                    flex: 3,
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            border: Border(
                          left: BorderSide(width: 3, color: Colors.black54),
                          bottom: BorderSide(width: 3, color: Colors.black54),
                        )),
                        child: Center(child: Text(playerThreeScore.toString()))))
                : const SizedBox(width: 0, height: 0),
            playerCount == 4
                ? Expanded(
                    flex: 3,
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            border: Border(
                          left: BorderSide(width: 3, color: Colors.black54),
                          bottom: BorderSide(width: 3, color: Colors.black54),
                        )),
                        child: Center(child: Text(playerFourScore.toString()))))
                : const SizedBox(width: 0, height: 0)
          ],
        ));
  }
}

class AppSettings {
  bool autoDelete;

  AppSettings({this.autoDelete});
}

//TODO: json doesn't support complex data types such as widgets. So it's not impossible, it's just a fuck ton of data to work with. fuck my life. Anyway, it will be okay if you just save it all and then rebuild it all in initstate. it'll be hundreds lines of code.

/*
class GameScreen extends StatefulWidget {
  final String playerOneName;
//  final String playerTwoName;
//  final String playerThreeName;
//  final String playerFourName;
//  final int totalPlayerCount;
//  final int giveCount;

  GameScreen(
      {Key key,
      @required this.playerOneName,
//      @required this.playerTwoName,
//      @required this.playerThreeName,
//      @required this.playerFourName,
//      @required this.totalPlayerCount,
//      @required this.giveCount
      })
      : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}
 */
//TODO: rounds.pop and recover score values from rounds[i] properties, saving games, color if saved, give a nice palette of 8 or so
//TODO: don't mess with passing arguments. You'll simply call everything in on initState();
List<Object> myrtaszDecode(String myrtaszString) {
  print(myrtaszString);
  List<String> firstInstance = myrtaszString.split('#');
  print(firstInstance);
  print("The first instance ^");
  int color = int.parse(firstInstance[0]);
  List<String> placeHolder = firstInstance[1].split(' ');
  List<List<int>> scoreRead = [[], [], [], []];
  for (int x = 0; x <= 3; x++) {
    placeHolder.forEach((element) {
      if (element.isNotEmpty) {
        scoreRead[x].add(int.parse(element));
      }
    });
    placeHolder = firstInstance[x + 2].split(' ');
  }
  List<String> playerNames = firstInstance[5].split('+');
  placeHolder = firstInstance[6].split(' ');
  List<int> playerGiveRemainingRead = [];
  placeHolder.forEach((element) {
    if (element.isNotEmpty) {
      print(element);
      playerGiveRemainingRead.add(int.parse(element));
    }
  });
  List<int> playerGiveHistoryRead = [];
  placeHolder = firstInstance[7].split(' ');
  placeHolder.forEach((element) {
    if (element.isNotEmpty) {
      playerGiveHistoryRead.add(int.parse(element));
    }
  });
  int playerCountRead = int.parse(firstInstance[8]);
  int roundCount = int.parse(firstInstance[9]);
  String timeIndex = firstInstance[10];
  return [
    color,
    scoreRead,
    playerNames,
    playerGiveRemainingRead,
    playerGiveHistoryRead,
    playerCountRead,
    roundCount,
    timeIndex
  ];
}

String toMyrtaszString(
    List<List<int>> score,
    int roundsCompleting,
    List<String> playerNames,
    List<int> playerGiveRemaining,
    List<int> playerGiveHistory,
    int color,
    int playerCount,
    String timeIndex) {
  String myrtaszString = '$color#';
  for (int x = 0; x <= 3; x++) {
    print("running for $x");
    score[x].forEach((subElement) {
      myrtaszString += '$subElement ';
    });
    myrtaszString += '#';
  }
  playerNames.forEach((element) {
    myrtaszString += '$element+';
  });
  myrtaszString = myrtaszString.substring(0, myrtaszString.length - 1);
  myrtaszString += '#';
  playerGiveRemaining.forEach((element) {
    myrtaszString += '$element ';
  });
  myrtaszString += '#';
  playerGiveHistory.forEach((element) {
    myrtaszString += '$element ';
  });
  myrtaszString += '#';
  myrtaszString += playerCount.toString();
  myrtaszString += '#';
  myrtaszString += roundsCompleting.toString();
  myrtaszString += '#';
  myrtaszString += timeIndex.toString();//timeIndex MUSI być ostatni, opiera się na tym działanie usuwania
  print('Blended game data into the following myrtaszString: $myrtaszString');
  return myrtaszString;
}

//3#
// 60 50 0 0 #
// 0 0 60 0 #
// 60 0 0 70 #
// 0 0 0 #
// po+pp+pc+#
// 3 2 3 3 #
// 1 -1 -1 -1 #
//3
sumAll(List<int> listName) {
  int sum = 0;
  listName.forEach((element) {
    sum += element;
  });
  return sum;
}
