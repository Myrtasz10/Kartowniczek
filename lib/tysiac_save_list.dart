
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:kartowniczek/tysiac_game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './colors.dart';

class Tysiac extends StatefulWidget {
  const Tysiac({Key? key}) : super(key: key);


  @override
  TysiacState createState() => TysiacState();
}

class TysiacState extends State<Tysiac> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  showSnackBar(String popText) {
    final snackBar = SnackBar(
      content: Text(popText),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  List<Widget> gameButtons = [];
  late BuildContext globalContext;

  printGameButtons() {
    if (kDebugMode) print(gameButtons);
  }

  Future<List<String>?> _getGamesFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get("gameFile") == null) {
      return [];
    } else {
      final List<String>? savedGame = prefs.getStringList("gameFile");
      if (kDebugMode) print("Returning $savedGame");
      return savedGame;
    }
  }

  Future<void> deleteGame(int toRemove) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedGame = prefs.getStringList("gameFile");
    if (kDebugMode) print(savedGame);
    List<String> newSavedGame = [];
    savedGame?.forEach((element) {
      newSavedGame.add(element);
    });
    newSavedGame.removeAt(toRemove);
    if (kDebugMode) print("Removing from $savedGame at $toRemove. New Value is $newSavedGame");
    await prefs.setStringList("gameFile", newSavedGame);
  }

  List<String> savedGames = [];

  void loadFromSharedPref() async {
    List<String>? savedGames = await _getGamesFromSharedPref();
    if (kDebugMode) print("added");
    setState(() {
      gameButtons.add(Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 4,
          child: ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(MyColors.raisedButtonGrey)),
            onPressed: () {
              Navigator.of(context).pushNamed('/create');
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: const <Widget>[
              Icon(
                Icons.add,
                color: Colors.black87,
              ),
              Text(
                'Nowa gra',
                style: TextStyle(color: Colors.black87),
              ),
            ]),
          )));
    });
    if (kDebugMode) print("Running render for each $savedGames");
    savedGames?.forEach((element) {
      if (kDebugMode) print("1 one");
      if (kDebugMode) print(myrtaszDecode(element));
      List<Object> decoded = myrtaszDecode(element);
      if (kDebugMode) print("2 one");
      if (kDebugMode) print(decoded);
      if (kDebugMode) print("3 one");
      Color color = Colors.black; //pusta inicjalizacja
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
      if(kDebugMode) {
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
      }
      setState(() {
        gameButtons.add(SaveGameButton(
            color, textColor, decoded[1] as List<List<int>>, decoded[2] as List<String>, decoded[5] as int, decoded[3] as List<int>, decoded[4] as List<int>, decoded[6] as int, savedGames.indexOf(element), decoded[7] as String));
      });
    });
    if (kDebugMode) {
      print("Renderer finished with following output: $gameButtons");
      print(gameButtons.length);
    }
  }

  @override
  void initState() {
    gameButtons = [const SizedBox(width: 0, height: 0)];
    if (kDebugMode) print("Inserting $context into global");
    globalContext = context;
    loadFromSharedPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Tysiąc'),
        centerTitle: true,
        backgroundColor: MyColors.appBarGreen,
          actions: <Widget>[IconButton(icon: const Icon(Icons.settings), onPressed: () {
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
      title: const Text("Usunąć zapis gry?", textAlign: TextAlign.center),
      content: const Text("Tej czynności nie będzie można cofnąć.", textAlign: TextAlign.center),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("anuluj", style: TextStyle(color: MyColors.azureCyan))),
        TextButton(
            onPressed: () {
              if (kDebugMode) print(gameButtons);
              if (kDebugMode) print("removing at $gameIndex");
              if (kDebugMode) print(gameButtons.length);
              gameButtons.removeAt(gameIndex);
              deleteGame(gameIndex);
            },
            child: const Text("potwierdź", style: TextStyle(color: MyColors.azureCyan))),
      ],
    );
    if (kDebugMode) print("context is: ${_scaffoldKey.currentWidget}");
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

  const SaveGameButton(this.color, this.textColor, this.scores, this.players, this.playerCount, this.playerGiveRemaining, this.playerGiveHistory,
      this.roundCount, this.indexInHierarchy, this.timeIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.width / 4,
        child: ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color)),
          child: Container(
            padding: const EdgeInsets.only(bottom: 7, top: 7),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
            Expanded (flex: 5, child: Text("Runda $roundCount", style: TextStyle(color: textColor), textAlign: TextAlign.center)),
            Expanded(
              flex: 17,
                child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Expanded(child: Text(players[0].toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center)),
                Expanded(child: Text(players[1].toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center)),
                playerCount >= 3 ? Expanded(child: Text(players[2].toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center)) : const SizedBox(
                  height: 0,
                  width: 0,
                ),
                playerCount >= 4 ? Expanded(child: Text(players[3].toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center)) : const SizedBox(
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
                playerCount >= 3 ? Expanded(child: Text(sumAll(scores[2]).toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center)): const SizedBox(
                  height: 0,
                  width: 0,
                ),
                playerCount >= 4 ? Expanded(child: Text(sumAll(scores[3]).toString(), style: TextStyle(color: textColor), textAlign: TextAlign.center)): const SizedBox(
                  height: 0,
                  width: 0,
                ),
              ])
            ])),
            Expanded(flex: 2, child: GestureDetector(
              child: IconButton(icon: const Icon(Icons.delete), color: textColor, onPressed: () {
                const MyNotification(title: "snackbar").dispatch(context);
              }),
              onLongPress: () {
                const MyNotification(title: "refresh").dispatch(context);
                if (kDebugMode) print("Deleting game at $indexInHierarchy");
                TysiacState().deleteGame(indexInHierarchy);
                //TODO: dispatch notification
              },
            ))
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

  const MyNotification({this.title = ""});
}