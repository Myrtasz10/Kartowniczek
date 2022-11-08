import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kartowniczek/gameScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './Colors.dart';
import './gameScreen.dart';

class Tysiac extends StatefulWidget {

  @override
  TysiacState createState() => TysiacState();
}

class TysiacState extends State<Tysiac> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  showSnackBar(String popText) {
    final snackBar = new SnackBar(
      content: new Text(popText),
      duration: new Duration(seconds: 3),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  List<Widget> gameButtons = [];
  BuildContext globalContext;

  printGameButtons() {
    print(gameButtons);
  }

  Future<List<String>> _getGamesFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get("gameFile") == null) {
      return [];
    } else {
      final List<String> savedGame = prefs.get("gameFile").cast<String>();
      print("Returning $savedGame");
      return savedGame;
    }
  }

  Future<void> deleteGame(int toRemove) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> savedGame = (prefs.get("gameFile")).cast<String>();
    print(savedGame);
    List<String> newSavedGame = [];
    savedGame.forEach((element) {
      newSavedGame.add(element);
    });
    newSavedGame.removeAt(toRemove);
    print("Removing from $savedGame at $toRemove. New Value is $newSavedGame");
    await prefs.setStringList("gameFile", newSavedGame);
  }

  List<String> savedGames;

  void loadFromSharedPref() async {
    List<String> savedGames = await _getGamesFromSharedPref();
    print("added");
    setState(() {
      gameButtons.add(Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 4,
          child: ElevatedButton(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Icon(
                Icons.add,
                color: Colors.black87,
              ),
              Text(
                'Nowa gra',
                style: TextStyle(color: Colors.black87),
              ),
            ]),
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(MyColors.raisedButtonGrey)),
            onPressed: () {
              Navigator.of(context).pushNamed('/create');
            },
          )));
    });
    print("Running render for each $savedGames");
    savedGames.forEach((element) {
      print("1 one");
      print(myrtaszDecode(element));
      List<Object> decoded = myrtaszDecode(element);
      print("2 one");
      print(decoded);
      print("3 one");
      Color color;
      Color textColor = Colors.white;
      switch (decoded[0]) {
        case 1:
          color = Colors.green;
          break;
        case 2:
          color = Colors.blue;
          break;
        case 3:
          color = Colors.purple;
          break;
        case 4:
          color = Colors.pink;
          break;
        case 5:
          color = Colors.yellow;
          textColor = Colors.black87;
          break;
        case 6:
          color = Colors.red;
          break;
        case 7:
          color = Colors.white;
          textColor = Colors.black87;
          break;
        case 8:
          color = Colors.blueGrey;
          break;
      }
      print("Pushing the following objects (in order):");
      print(color);
      print(decoded[1]);
      print(decoded[2]);
      print(decoded[5]);
      print(decoded[6]);
      print("Time:");
      print(decoded[7]);
      print("reported index:");
      print(savedGames.indexOf(element));
      setState(() {
        gameButtons.add(SaveGameButton(
            color, textColor, decoded[1], decoded[2], decoded[5], decoded[3], decoded[4], decoded[6], savedGames.indexOf(element), decoded[7]));
      });
    });
    print("Renderer finished with following output: $gameButtons");
    print(gameButtons.length);
  }

  @override
  void initState() {
    gameButtons = [Container(width: 0, height: 0)];
    print("Inserting $context into global");
    globalContext = context;
    loadFromSharedPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Tysiąc'),
        centerTitle: true,
        backgroundColor: MyColors.appBarGreen,
          actions: <Widget>[IconButton(icon: new Icon(Icons.settings), onPressed: () {
            Navigator.of(context).pushNamed('/tysiacsettings');
          })],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: NotificationListener<MyNotification>(
          onNotification: (notification) {
            //TODO: pop a page then go back
            if(notification.title == "refresh") {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/tysiąc');
            } else if (notification.title == "snackbar") {
              showSnackBar("Przytrzymaj ikonę, aby usunąć zapis gry");
            }
            return true;
          },
          child:
            SingleChildScrollView(child: Column(children: gameButtons)),
        )
      ),
    );
  }

  void showDeletePrompt(int gameIndex) {
    AlertDialog dialog = AlertDialog(
      title: Text("Usunąć zapis gry?", textAlign: TextAlign.center),
      content: Text("Tej czynności nie będzie można cofnąć.", textAlign: TextAlign.center),
      actions: <Widget>[
        new TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("anuluj", style: TextStyle(color: MyColors.azureCyan))),
        new TextButton(
            onPressed: () {
              print(gameButtons);
              print("removing at $gameIndex");
              print(gameButtons.length);
              gameButtons.removeAt(gameIndex);
              deleteGame(gameIndex);
            },
            child: Text("potwierdź", style: TextStyle(color: MyColors.azureCyan))),
      ],
    );
    print("context is: ${_scaffoldKey.currentWidget}");
    showDialog(context: Scaffold.of(context).context, builder: (_) => dialog);
  }
}

class SaveGameButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final List<List<int>> scores;
  final List<String> players;
  final int playerCount;
  final List<int> playerGiveRemaining;
  final List<int> playerGiveHistory;
  final int roundCount;
  final int indexInHierarchy;
  final String timeIndex;

  SaveGameButton(this.color, this.textColor, this.scores, this.players, this.playerCount, this.playerGiveRemaining, this.playerGiveHistory,
      this.roundCount, this.indexInHierarchy, this.timeIndex);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.width / 4,
        child: ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color)),
          child: Container(
            padding: EdgeInsets.only(bottom: 7, top: 7),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
            Expanded (flex: 5, child: Text("Runda " + roundCount.toString(), style: TextStyle(color: textColor))),
            Expanded(
              flex: 17,
                child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start, //major UI change //reorganizacja kolumn/rzędów była potrzebna bo inaczej by tego nie było chyba że zostawimy to useless
                  children: <Widget>[
                Expanded(child: Text(players[0].toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center)),
                Expanded(child: Text(players[1].toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center)),
                playerCount >= 3 ? Expanded(child: Text(players[2].toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center)) : Container(
                  height: 0,
                  width: 0,
                ),
                playerCount >= 4 ? Expanded(child: Text(players[3].toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center)) : Container(
                  height: 0,
                  width: 0,
                ),
              ]),
              Container(height: 5),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                Expanded(child: Text(sumAll(scores[0]).toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center)),
                Expanded(child: Text(sumAll(scores[1]).toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center)),
                playerCount >= 3 ? Expanded(child: Text(sumAll(scores[2]).toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center)): Container(
                  height: 0,
                  width: 0,
                ),
                playerCount >= 4 ? Expanded(child: Text(sumAll(scores[3]).toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center)): Container(
                  height: 0,
                  width: 0,
                ),
              ])
            ])),
            // Expanded(flex: 3,  child://TODO: coś z fittedbox może?
            // Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            //   Text(players[0].toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center),
            //   Text(sumAll(scores[0]).toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center)
            // ], mainAxisSize: MainAxisSize.max,)),
            // Expanded(flex: 3, child:
            // Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            //   Text(players[1].toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center),
            //   Text(sumAll(scores[1]).toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center)
            // ], mainAxisSize: MainAxisSize.max)),
            // playerCount >= 3
            //     ? Expanded(flex: 3, child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            //         Text(players[2].toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center),
            //         Text(sumAll(scores[2]).toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center)
            //       ],mainAxisSize: MainAxisSize.max))
            //     : Container(
            //         height: 0,
            //         width: 0,
            //       ),
            // playerCount == 4
            //     ? Expanded(flex: 3, child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            //         Text(players[3].toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center),
            //         Text(sumAll(scores[3]).toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center)
            //       ], mainAxisSize: MainAxisSize.max,))
            //     : Container(
            //         height: 0,
            //         width: 0,
            //       ),
            Expanded(child: GestureDetector(
              child: IconButton(icon: Icon(Icons.delete), color: textColor, onPressed: () {
                MyNotification(title: "snackbar")..dispatch(context);
              }),
              onLongPress: () {
                MyNotification(title: "refresh")..dispatch(context);
                print("Deleting game at $indexInHierarchy");
                TysiacState().deleteGame(indexInHierarchy);
                //TODO: dispatch notification
              },
            ), flex: 2)
          ])),
          onPressed: () {
            //TODO: tutaj
            Navigator.of(context).pushNamed('/play', arguments: <String>[
              '-1',
              toMyrtaszString(scores, roundCount, players, playerGiveRemaining, playerGiveHistory, 0, playerCount, timeIndex)
            ]);
          },
        ));
  }
}

class MyNotification extends Notification {
  final String title;

  const MyNotification({this.title});
}
// String toMyrtaszString(
//     List<List<int>> score,
//     int roundsCompleting,
//     List<String> playerNames,
//     List<int> playerGiveRemaining,
//     List<int> playerGiveHistory,
//     int color,
//     int playerCount) {
//   String myrtaszString = color.toString() + '#';
//   for (int x = 0; x <= 3; x++) {
//     print("running for $x");
//     score[x].forEach((subElement) {
//       myrtaszString += subElement.toString() + ' ';
//     });
//     myrtaszString += '#';
//   }
//   playerNames.forEach((element) {
//     myrtaszString += element + '+';
//   });
//   myrtaszString = myrtaszString.substring(0, myrtaszString.length - 1);
//   myrtaszString += '#';
//   playerGiveRemaining.forEach((element) {
//     myrtaszString += element.toString() + ' ';
//   });
//   myrtaszString += '#';
//   playerGiveHistory.forEach((element) {
//     myrtaszString += element.toString() + ' ';
//   });
//   myrtaszString += '#';
//   myrtaszString += playerCount.toString();
//   myrtaszString += '#';
//   myrtaszString += roundsCompleting.toString();
//   print('Blended game data into the following myrtaszString: $myrtaszString');
//   return myrtaszString;
// }

//TODO: Prevent misclick leave without saving
//TODO: you need to access global context somehow. - maybe just delete stuff and reload huh?

//TODO: more even distribution of players on save widget