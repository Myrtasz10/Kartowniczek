import 'package:flutter/material.dart';

import './Colors.dart';

class CreateKent extends StatefulWidget {

  @override
  _CreateKentState createState() => _CreateKentState();
}

class _CreateKentState extends State<CreateKent> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  showSnackBar(String popText) {
    final snackBar = new SnackBar(
      content: new Text(popText),
      duration: new Duration(seconds: 3),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  static List<String> groupNames = new List(10);
  int fieldCounter = 2;
  List<Widget> inputFields = [InputRow(0), InputRow(1)];

  bool properNames(List<String> names) {
    int x = 0;
    try {
      // ignore: missing_return
      names.forEach((element) {
        print(element);
        String parselement = element.replaceAll(' i ', '');
        parselement = parselement.replaceAll(' ', '');
        if (x < fieldCounter && parselement.isEmpty) {
          print("there's been an error: $parselement is empty and it shouldn't due to being $x out of $fieldCounter");
          return false;
        }
        x++;
      });
    }
    catch (NoSuchMethodError) {
      print("idk what caused it lol");
      showSnackBar("Nazwy graczy nie mogą być puste");
    }
    return true;
  }

  void writeIndex(String newString, int entryIndex) {//I'm doing this only because the framework is retarded
    print("ack");
    print(newString);
    print(entryIndex);
    print("currently $groupNames");
    print("Setting state");
    groupNames[entryIndex] = newString;
    print("now $groupNames");
  }

  @override
  void initState() {
    groupNames.fillRange(0, 10, '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Nowa gra'),
          centerTitle: true,
          backgroundColor: MyColors.appBarGreen,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child:
        Column(children: <Widget>[
          Expanded(child:
            SingleChildScrollView(child:
            Column(children: inputFields))),
            Row(children: <Widget>[
              IconButton(icon: Icon(Icons.add), onPressed: () {
                if(inputFields.length < 10) {
                  setState(() {
                  inputFields.add(InputRow(fieldCounter++));
                  });
                } else {
                  showSnackBar("Zbyt wiele drużyn");
                }
            }),
              IconButton(icon: Icon(Icons.remove), onPressed: () {
                if(inputFields.length > 2) {
                  setState(() {
                    groupNames[--fieldCounter] = '';
                  inputFields.removeLast();
                  });
                } else {
                  showSnackBar("Gra wymaga minimum czterech osób");
                }
              }),
            ]),
            Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  child: Text("Rozpocznij grę"),
                  onPressed: () {
                    if(properNames(groupNames)) {
                      print(groupNames);
                      _scaffoldKey.currentState.hideCurrentSnackBar();
                      Navigator.of(context).pushNamed('/kent', arguments: groupNames + [fieldCounter.toString()]);
                    } else {
                      showSnackBar("Wygląda na to, że niektóre nazwy są puste lub po prostu za długie");
                    }
                  },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(MyColors.cardRed)),
                )),
        ])
    ));
  }
}

// ignore: must_be_immutable
class InputRow extends StatelessWidget {

  final int rowIndex;

  InputRow(this.rowIndex);

  String playerOne = '';
  String playerTwo = '';
  String localInput = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width*0.9,
        child: Row(children: [
          Expanded(child:
          TextField(
      decoration: InputDecoration(
        labelText: 'Gracz 1',
      ),
      onChanged: (String str) {
        playerOne = str;
        localInput = playerOne + ' i ' + playerTwo;
        _CreateKentState().writeIndex(localInput, rowIndex);
        print(localInput);
      },
    )),
      Expanded(child:
      TextField(
        decoration: InputDecoration(
          labelText: 'Gracz 2',
        ),
        onChanged: (String str) {
          playerTwo = str;
          localInput = playerOne + ' i ' + playerTwo;
          _CreateKentState().writeIndex(localInput, rowIndex);
          print(localInput);
        },
      )),
    ]));
  }
}