import 'package:flutter/material.dart';

import './Colors.dart';

class Kent extends StatefulWidget {
  final List<String> data;

  Kent({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  _KentState createState() => _KentState();
}

class _KentState extends State<Kent> {
  static List<int> scores = List<int>.filled(10, null, growable: false);
  List<Widget> teamRows = [Container(width: 0, height: 0)];

  List<Widget> dataLogs = [Text("tutaj będą pojawiać się zmiany")];

  var updateController = ScrollController();

  void updateScores(int hierarchyIndex, int change, int localCount) {
    print("1 - adding a change to LOGS");
    print("2 - for ${scores[hierarchyIndex]}");
    print(
        "3 - changing value $localCount by $change, equals ${localCount + change}");
    setState(() {
      dataLogs.add(Text(widget.data[hierarchyIndex] +
          ' ' +
          (change > 0 ? '+' : '') +
          change.toString() +
          " punkt(y), zmiana z $localCount na ${localCount + change} o ${((DateTime.now().toString()).split(' ')[1]).split('.')[0]}"));
      Future.delayed(const Duration(milliseconds: 50), () {
        print("Scrolling at maxExtent");
        updateController.jumpTo(updateController.position.maxScrollExtent);
      });
    });
  }

  void initState() {
    List<String> teams = new List(int.parse(widget.data[10]));
    print('This is the list:');
    print(teams);
    for (int x = 0; x < int.parse(widget.data[10]); x++) {
      teams[x] = widget.data[x];
    }
    print(teams);
    scores.fillRange(0, 10, 0);
    print(widget.data);
    int x = 0;
    teams.forEach((element) {
      print("Adding $element with index $x");
      teamRows.add(TeamRow(element, x++, updateScores));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Kent'),
          centerTitle: true,
          backgroundColor: MyColors.appBarGreen,
        ),
        body: Container(
            child: Column(children: <Widget>[
          Column(children: teamRows),
          Expanded(
              child: SingleChildScrollView(
            child: Column(children: dataLogs),
            controller: updateController,
          ))
        ])));
  }
}

class TeamRow extends StatefulWidget {
  final String teamName;
  final int teamIndex;
  final Function pushToLogs;

  TeamRow(this.teamName, this.teamIndex, this.pushToLogs);

//  static int localScore = 0;

  @override
  _TeamRowState createState() => _TeamRowState();
}

class _TeamRowState extends State<TeamRow> {
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
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(widget.teamIndex.toString())),
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(width: 3, color: Colors.black54),
                    )))),
            Expanded(
                flex: 5,
                child: Container(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(widget.teamName.toString())),
                    decoration: BoxDecoration(
                        border: Border(
                      left: BorderSide(width: 3, color: Colors.black54),
                      bottom: BorderSide(width: 3, color: Colors.black54),
                    )))),
            Expanded(
                flex: 1,
                child: Container(
                    padding: EdgeInsets.all(5),
                    child: Center(child: Text(localScore.toString())),
                    decoration: BoxDecoration(
                        border: Border(
                      left: BorderSide(width: 3, color: Colors.black54),
                      bottom: BorderSide(width: 3, color: Colors.black54),
                    )))),
            Expanded(
                flex: 1,
                child: Container(
                    padding: EdgeInsets.all(5),
                    child: Center(
                        child: RawMaterialButton(
                      child: Icon(Icons.add),
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
                    )),
                    decoration: BoxDecoration(
                        border: Border(
                      left: BorderSide(width: 3, color: Colors.black54),
                      bottom: BorderSide(width: 3, color: Colors.black54),
                    )))),
            Expanded(
                flex: 1,
                child: Container(
                    padding: EdgeInsets.all(5),
                    child: Center(
                        child: RawMaterialButton(
                      child: Icon(Icons.remove),
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
                    )),
                    decoration: BoxDecoration(
                        border: Border(
                      left: BorderSide(width: 3, color: Colors.black54),
                      bottom: BorderSide(width: 3, color: Colors.black54),
                    )))),
          ],
        ));
  }
}
