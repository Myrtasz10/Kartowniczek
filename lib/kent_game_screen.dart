import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import './colors.dart';

class Kent extends StatefulWidget {
  final List<String> data;

  const Kent({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  KentState createState() => KentState();
}

class KentState extends State<Kent> {
  static List<int> scores = List<int>.filled(10, -1, growable: false);
  List<Widget> teamRows = [const SizedBox(width: 0, height: 0)];
  List<Widget> dataLogs = [const Text("tutaj będą pojawiać się zmiany")];
  var updateController = ScrollController();

  void updateScores(int hierarchyIndex, int change, int localCount) {
    if (kDebugMode) {
      print("1 - adding a change to LOGS");
      print("2 - for ${scores[hierarchyIndex]}");
      print("3 - changing value $localCount by $change, equals ${localCount +
          change}");
    }
    setState(() {
      dataLogs.add(Text("${widget.data[hierarchyIndex]} ${change > 0 ? "+" : ""}$change punkt(y), zmiana z $localCount na ${localCount + change} o ${((DateTime.now().toString()).split(' ')[1]).split('.')[0]}"));
      Future.delayed(const Duration(milliseconds: 50), () {
        if (kDebugMode) print("Scrolling at maxExtent");
        updateController.jumpTo(updateController.position.maxScrollExtent);
      });
    });
  }

  @override
  void initState() {
    List<String> teams = List.filled(int.parse(widget.data[10]), "");
    if (kDebugMode) print('This is the list:');
    if (kDebugMode) print(teams);
    for (int x = 0; x < int.parse(widget.data[10]); x++) {
      teams[x] = widget.data[x];
    }
    if (kDebugMode) print(teams);
    scores.fillRange(0, 10, 0);
    if (kDebugMode) print(widget.data);
    int x = 0;
    for (var element in teams) {
      if (kDebugMode) print("Adding $element with index $x");
      teamRows.add(TeamRow(element, x++, updateScores));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Kent'),
          centerTitle: true,
          backgroundColor: MyColors.appBarGreen,
        ),
        body: Column(children: <Widget>[
          Column(children: teamRows),
          Expanded(
          child: SingleChildScrollView(
        controller: updateController,
        child: Column(children: dataLogs),
          ))
        ]));
  }
}

class TeamRow extends StatefulWidget {
  final String teamName;
  final int teamIndex;
  final Function pushToLogs;

  const TeamRow(this.teamName, this.teamIndex, this.pushToLogs, {super.key});

//  static int localScore = 0;

  @override
  TeamRowState createState() => TeamRowState();
}

class TeamRowState extends State<TeamRow> {
  int localScore = 0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 7,
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        border: Border(
                      bottom: BorderSide(width: 3, color: Colors.black54),
                    )),
                    child: Center(child: Text(widget.teamIndex.toString())))),
            Expanded(
                flex: 5,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        border: Border(
                      left: BorderSide(width: 3, color: Colors.black54),
                      bottom: BorderSide(width: 3, color: Colors.black54),
                    )),
                    child: Center(child: Text(widget.teamName.toString())))),
            Expanded(
                flex: 1,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        border: Border(
                      left: BorderSide(width: 3, color: Colors.black54),
                      bottom: BorderSide(width: 3, color: Colors.black54),
                    )),
                    child: Center(child: Text(localScore.toString())))),
            Expanded(
                flex: 1,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        border: Border(
                      left: BorderSide(width: 3, color: Colors.black54),
                      bottom: BorderSide(width: 3, color: Colors.black54),
                    )),
                    child: Center(
                        child: RawMaterialButton(
                      child: const Icon(Icons.add),
                      onPressed: () {
                        widget.pushToLogs(widget.teamIndex, 1, localScore);
                        setState(() {
                          localScore++;
                        });
                      },
                      onLongPress: () {
                        widget.pushToLogs(widget.teamIndex, 3, localScore);
                        setState(() {
                          localScore += 3;
                        });
                      },
                    )))),
            Expanded(
                flex: 1,
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        border: Border(
                      left: BorderSide(width: 3, color: Colors.black54),
                      bottom: BorderSide(width: 3, color: Colors.black54),
                    )),
                    child: Center(
                        child: RawMaterialButton(
                      child: const Icon(Icons.remove),
                      onPressed: () {
                        widget.pushToLogs(widget.teamIndex, -1, localScore);
                        setState(() {
                          localScore--;
                        });
                      },
                      onLongPress: () {
                        widget.pushToLogs(widget.teamIndex, -3, localScore);
                        setState(() {
                          localScore -= 3;
                        });
                      },
                    )))),
          ],
        ));
  }
}
