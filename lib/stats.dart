import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:kartowniczek/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Stats extends StatefulWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  StatsState createState() => StatsState();
}

class StatsState extends State<Stats> {
  List<Widget> tables = [];
  List<String> statRowsRaw = [];
  List<Map<String, dynamic>> statRows = [];
  List<String> names = [];
  int winIndex = -1;
  int currentPlayerCount = -1;
  List<List<dynamic>> pendingTables = [];
  int tableIndex = -1;

  Future<List<String>> _getStatsFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStats = prefs.getStringList(
        "statFile"); //getstringlist zamiast get żeby rozwiązać List<dynamic>' is not a subtype of type 'FutureOr<List<String>>'
    if (savedStats == null) {
      return [];
    }
    return savedStats;
  }

  void setStats() async {
    statRowsRaw = await _getStatsFromSharedPref();
    if (kDebugMode) print("Stats have been set");
    if (kDebugMode) print(statRowsRaw);
    for (var element in statRowsRaw) {
      if (kDebugMode) print("1. Iterating for: $element");
      statRows.add(jsonDecode(element));
    }
    for (var element in statRows) {
      if (kDebugMode) print("2. Iterating for: $element");
      names.add(element['playerOne']);
      names.add(element['playerTwo']);
      if (element['playerCount'] >= 3) {
        names.add(element['playerThree']);
        if (element['playerCount'] == 4) {
          names.add(element['playerFour']);
        }
      } //TODO: puste daje na początek i robi się problem - trzeba rozpatrzyć player count (if playercount = 4 names.add playerfour
      if (kDebugMode) print(names);
      names.sort();
      if (kDebugMode) print(winIndex);
      //nie powinno wywołać erroru ale nie jest idiotoodporne
      if (names[0] == element['playerWin']) {
        winIndex = 0;
      } else if (names[1] == element['playerWin']) {
        winIndex = 1;
      } else if (names[2] == element['playerWin']) {
        winIndex = 2;
      } else if (names[3] == element['playerWin']) {
        winIndex = 3;
      }
      if (kDebugMode) print(winIndex);
      if (pendingTables.isNotEmpty) {
        for (var table in pendingTables) {
          if (kDebugMode) print("Got here!");
          if (kDebugMode) print(table);
          if (table[1].trim().toLowerCase() == names[0].trim().toLowerCase() &&
              table[2].trim().toLowerCase() == names[1].trim().toLowerCase() &&
              table[3].trim().toLowerCase() == (element['playerCount'] >= 3 ? names[2].trim().toLowerCase() : "") &&
              table[4].trim().toLowerCase() == (element['playerCount'] == 4 ? names[3].trim().toLowerCase() : "")) {
            tableIndex = pendingTables.indexOf(table);
          } else {
            if (kDebugMode) print("Nope");
          }
        }
      }
      if (kDebugMode) print(tableIndex);
      if (tableIndex != -1) {
        if (kDebugMode) print("So it's not -1, it is $tableIndex");
        switch (winIndex) {
          case 0:
            pendingTables[tableIndex][5]++;
            break;
          case 1:
            pendingTables[tableIndex][6]++;
            break;
          case 2:
            pendingTables[tableIndex][7]++;
            break;
          case 3:
            pendingTables[tableIndex][8]++;
            break;
        }
      } else {
        if (kDebugMode) print("it is indeed -1, adding...");
        pendingTables.add([
          element['playerCount'],
          names[0],
          names[1],
          element['playerCount'] >= 3 ? names[2] : "",
          element['playerCount'] == 4 ? names[3] : "",
          winIndex == 0 ? 1 : 0,
          winIndex == 1 ? 1 : 0,
          winIndex == 2 ? 1 : 0,
          winIndex == 3 ? 1 : 0,
        ]);
      }
      names = [];
      winIndex = -1;
      tableIndex = -1;
      currentPlayerCount = -1;
    }
    for (var table in pendingTables) {
      if (kDebugMode) print("The table is:");
      if (kDebugMode) print(table);
      setState(() {
      tables.add(Party(table[0], table[1], table[2], table[3],
          table[4], table[5], table[6], table[7], table[8]));
      });
    }
  }

  @override
  void initState() {
    setStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statystyki'),
        centerTitle: true,
        backgroundColor: MyColors.appBarGreen,
      ),
      body: SingleChildScrollView(child: Column(children: tables)),
    );
  }
}

class Party extends StatelessWidget {
  final int playerCount;
  final String playerOne;
  final String playerTwo;
  final String playerThree;
  final String playerFour;
  final int playerOneScore;
  final int playerTwoScore;
  final int playerThreeScore;
  final int playerFourScore;

  const Party(
      this.playerCount,
      this.playerOne,
      this.playerTwo,
      this.playerThree,
      this.playerFour,
      this.playerOneScore,
      this.playerTwoScore,
      this.playerThreeScore,
      this.playerFourScore, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Card(
            child: Table(
          border: TableBorder.all(),
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(),
            1: IntrinsicColumnWidth(),
          },
          //TODO: wersja na 2 i 4 graczy
          children: [
            TableRow(children: [
              Container(
                color: MyColors.raisedButtonGrey,
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "Imię Gracza",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Container(
                  color: MyColors.highlightOrange,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text("Wygrane",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)))
            ]),
            TableRow(
                decoration: (const BoxDecoration(color: MyColors.azureCyanLight)),
                children: [
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(playerOne,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20))),
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(playerOneScore.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30)))
                ]),
            TableRow(
                decoration: (const BoxDecoration(color: MyColors.azureCyanLight)),
                children: [
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(playerTwo,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20))),
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(playerTwoScore.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30)))
                ]),
            playerCount >= 3
                ? TableRow(
                    decoration: (const BoxDecoration(color: MyColors.azureCyanLight)),
                    children: [
                        Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(playerThree,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20))),
                        Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(playerThreeScore.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30)))
                      ])
                : TableRow(
                    children: [Container(height: 0), Container(height: 0)]),
            playerCount == 4
                ? TableRow(
                    decoration: (const BoxDecoration(color: MyColors.azureCyanLight)),
                    children: [
                        Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(playerFour,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20))),
                        Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(playerFourScore.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30)))
                      ])
                : TableRow(
                    children: [Container(height: 0), Container(height: 0)]),
          ],
        )));
  }
}

class StatRow {
  final int playerCount;
  final String playerOne;
  final String playerTwo;
  final String playerThree;
  final String playerFour;
  final String playerWin;

  StatRow(this.playerCount, this.playerOne, this.playerTwo, this.playerThree,
      this.playerFour, this.playerWin);

  StatRow.fromJson(Map<String, dynamic> json)
      : playerCount = json['playerCount'],
        playerOne = json['playerOne'],
        playerTwo = json['playerTwo'],
        playerThree = json['playerThree'],
        playerFour = json['playerFour'],
        playerWin = json['playerWin'];

  Map<String, dynamic> toJson() => {
        'playerCount': playerCount,
        'playerOne': playerOne,
        'playerTwo': playerTwo,
        'playerThree': playerThree,
        'playerFour': playerFour,
        'playerWin': playerWin,
      };
}
