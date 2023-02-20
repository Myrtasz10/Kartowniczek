
// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import './Colors.dart';

class CreateKent extends StatefulWidget {
  const CreateKent({Key? key}) : super(key: key);

  @override
  CreateKentState createState() => CreateKentState();
}

class CreateKentState extends State<CreateKent> {

  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();

  showSnackBar(String popText) {
    final snackBar =  SnackBar(
      content:  Text(popText),
      duration:  const Duration(seconds: 3),
    );
    //_scaffoldKey.currentState?.showSnackBar(snackBar);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  static List<String> groupNames =  List.filled(10, "");
  int fieldCounter = 2;
  List<Widget> inputFields = [InputRow(0), InputRow(1)];

  bool properNames(List<String> names) {
    bool toReturn = true;
    int x = 0;
    try {
      // ignore: missing_return
      names.forEach((element) {
        if (kDebugMode) print(element);
        String parselement = element.replaceAll(' i ', '');
        parselement = parselement.replaceAll(' ', '');
        if (x < fieldCounter && parselement.isEmpty) {
          if (kDebugMode) print("there's been an error: $parselement is empty and it shouldn't due to being $x out of $fieldCounter");
          toReturn = false;
        }
        x++;
      });
    }
    on NoSuchMethodError {
      if(kDebugMode) if (kDebugMode) print("idk what caused it lol");
      showSnackBar("Nazwy graczy nie mogą być puste");
    }
    return toReturn;
  }

  void writeIndex(String newString, int entryIndex) {
    if (kDebugMode) print("ack");
    if (kDebugMode) print(newString);
    if (kDebugMode) print(entryIndex);
    if (kDebugMode) print("currently $groupNames");
    if (kDebugMode) print("Setting state");
    groupNames[entryIndex] = newString;
    if (kDebugMode) print("now $groupNames");
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
          title: const Text('Nowa gra'),
          centerTitle: true,
          backgroundColor: MyColors.appBarGreen,
        ),
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child:
        Column(children: <Widget>[
          Expanded(child:
            SingleChildScrollView(child:
            Column(children: inputFields))),
            Row(children: <Widget>[
              IconButton(icon: const Icon(Icons.add), onPressed: () {
                if(inputFields.length < 10) {
                  setState(() {
                  inputFields.add(InputRow(fieldCounter++));
                  });
                } else {
                  showSnackBar("Zbyt wiele drużyn");
                }
            }),
              IconButton(icon: const Icon(Icons.remove), onPressed: () {
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
                  onPressed: () {
                    if(properNames(groupNames)) {
                      if(kDebugMode) if (kDebugMode) print(groupNames);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      Navigator.of(context).pushNamed('/kent', arguments: groupNames + [fieldCounter.toString()]);
                    } else {
                      showSnackBar("Wygląda na to, że niektóre nazwy są puste lub po prostu za długie");
                    }
                  },
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(MyColors.cardRed)),
                  child: const Text("Rozpocznij grę"),
                )),
        ])
    ));
  }
}

// ignore: must_be_immutable
class InputRow extends StatelessWidget {

  final int rowIndex;

  InputRow(this.rowIndex, {Key? key}) : super(key: key);

  String playerOne = '';
  String playerTwo = '';
  String localInput = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width*0.9,
        child: Row(children: [
          Expanded(child:
          TextField(
      decoration: const InputDecoration(
        labelText: 'Gracz 1',
      ),
      onChanged: (String str) {
        playerOne = str;
        localInput = '$playerOne i $playerTwo';
        CreateKentState().writeIndex(localInput, rowIndex);
        if(kDebugMode) if (kDebugMode) print(localInput);
      },
    )),
      Expanded(child:
      TextField(
        decoration: const InputDecoration(
          labelText: 'Gracz 2',
        ),
        onChanged: (String str) {
          playerTwo = str;
          localInput = '$playerOne i $playerTwo';
          CreateKentState().writeIndex(localInput, rowIndex);
          if(kDebugMode) if (kDebugMode) print(localInput);
        },
      )),
    ]));
  }
}