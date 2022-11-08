import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kartowniczek/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Stats extends StatefulWidget {
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

  //StatRow statRow = new StatRow(4, "xada", "daxa", "saxa", "waxa", "xada");

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
    print("Stats have been set");
    print(statRowsRaw);
    statRowsRaw.forEach((element) {
      print("1. Iterating for: " + element);
      statRows.add(jsonDecode(element));
    });
    statRows.forEach((element) {
      print("2. Iterating for: " + element.toString());
      names.add(element['playerOne']);
      names.add(element['playerTwo']);
      if (element['playerCount'] >= 3) {
        names.add(element['playerThree']);
        if (element['playerCount'] == 4) {
          names.add(element['playerFour']);
        }
      } //TODO: puste daje na początek i robi się problem - trzeba rozpatrzyć player count (if playercount = 4 names.add playerfour
      print(names);
      names.sort();
      print(winIndex);
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
      print(winIndex);
      if (pendingTables.isNotEmpty) {
        pendingTables.forEach((table) {
          print("Got here!");
          print(table);
          if (table[1].trim().toLowerCase() == names[0].trim().toLowerCase() &&
              table[2].trim().toLowerCase() == names[1].trim().toLowerCase() &&
              table[3].trim().toLowerCase() == (element['playerCount'] >= 3 ? names[2].trim().toLowerCase() : "") &&
              table[4].trim().toLowerCase() == (element['playerCount'] == 4 ? names[3].trim().toLowerCase() : "")) {
            tableIndex = pendingTables.indexOf(table);
          } else {
            print("Nope");
          }
        });
      }
      print(tableIndex);
      if (tableIndex != -1) {
        print("So it's not -1, it is $tableIndex");
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
        print("it is indeed -1, adding...");
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
    });
    pendingTables.forEach((table) {
      print("The table is:");
      print(table);
      setState(() {
      tables.add(Party(table[0], table[1], table[2], table[3],
          table[4], table[5], table[6], table[7], table[8]));
      });
    });
  }

  @override
  void initState() {
    //TODO: delete comment
    // String statString = jsonEncode(statRow);
    // print (statString);
    // Map<String, dynamic> statMap = jsonDecode(statString);
    // var sampleParty = StatRow.fromJson(statMap);
    setStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statystyki'),
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

  Party(
      this.playerCount,
      this.playerOne,
      this.playerTwo,
      this.playerThree,
      this.playerFour,
      this.playerOneScore,
      this.playerTwoScore,
      this.playerThreeScore,
      this.playerFourScore);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
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
                child: Text(
                  "Imię Gracza",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                color: MyColors.raisedButtonGrey,
                padding: EdgeInsets.all(8.0),
              ),
              Container(
                  child: Text("Wygrane",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  color: MyColors.highlightOrange,
                  padding: EdgeInsets.all(8.0))
            ]),
            TableRow(
                decoration: (BoxDecoration(color: MyColors.azureCyanLight)),
                children: [
                  Container(
                      child: Text(playerOne,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20)),
                      padding: EdgeInsets.all(8.0)),
                  Container(
                      child: Text(playerOneScore.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30)),
                      padding: EdgeInsets.all(8.0))
                ]),
            TableRow(
                decoration: (BoxDecoration(color: MyColors.azureCyanLight)),
                children: [
                  Container(
                      child: Text(playerTwo,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20)),
                      padding: EdgeInsets.all(8.0)),
                  Container(
                      child: Text(playerTwoScore.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30)),
                      padding: EdgeInsets.all(8.0))
                ]),
            playerCount >= 3
                ? TableRow(
                    decoration: (BoxDecoration(color: MyColors.azureCyanLight)),
                    children: [
                        Container(
                            child: Text(playerThree,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20)),
                            padding: EdgeInsets.all(8.0)),
                        Container(
                            child: Text(playerThreeScore.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30)),
                            padding: EdgeInsets.all(8.0))
                      ])
                : TableRow(
                    children: [Container(height: 0), Container(height: 0)]),
            playerCount == 4
                ? TableRow(
                    decoration: (BoxDecoration(color: MyColors.azureCyanLight)),
                    children: [
                        Container(
                            child: Text(playerFour,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20)),
                            padding: EdgeInsets.all(8.0)),
                        Container(
                            child: Text(playerFourScore.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30)),
                            padding: EdgeInsets.all(8.0))
                      ])
                : TableRow(
                    children: [Container(height: 0), Container(height: 0)]),
          ],
        )));
  }
}

// String toStatString (
// int playerCount,
// String playerWin,
// String playerTwo,
// String playerThree,
// String playerFour
// ) {
//   return playerCount.toString() + '#' + playerWin + '#' + playerTwo + '#' + playerThree + '#' + playerFour;
// }

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
