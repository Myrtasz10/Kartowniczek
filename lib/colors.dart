import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';


class MyColors {
  static const Color appBarGreen = Color(0xff006400);
  static const Color azureCyan = Color(0xff2ec0f9);
  static const Color azureCyanLight = Color(0x882ec0f9);
  static const Color cardRed = Color(0xffd12d36);
  static const Color highlightOrange = Color(0xffffd68a);
  static const Color background = Color(0xfff3f2eb);
  static const Color raisedButtonGrey = Color(0xffd0d0d0);
}

//TODO: zmienić w JSON
//deserializacja
List<Object> saveGameDecode(String inputString) {
  if (kDebugMode) print(inputString);
  List<String> firstInstance = inputString.split('#');
  if (kDebugMode) {
    print(firstInstance);
    print("The first instance ^");
  }
  int color = int.parse(firstInstance[0]);
  List<String> placeHolder = firstInstance[1].split(' ');
  List<List<int>> scoreRead = [[], [], [], []];
  for (int x = 0; x <= 3; x++) {
    for (var element in placeHolder) {
      if (element.isNotEmpty) {
        scoreRead[x].add(int.parse(element));
      }
    }
    placeHolder = firstInstance[x + 2].split(' ');
  }
  List<String> playerNames = firstInstance[5].split('+');
  placeHolder = firstInstance[6].split(' ');
  List<int> playerGiveRemainingRead = [];
  for (var element in placeHolder) {
    if (element.isNotEmpty) {
      if (kDebugMode) print(element);
      playerGiveRemainingRead.add(int.parse(element));
    }
  }
  List<int> playerGiveHistoryRead = [];
  placeHolder = firstInstance[7].split(' ');
  for (var element in placeHolder) {
    if (element.isNotEmpty) {
      playerGiveHistoryRead.add(int.parse(element));
    }
  }
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

//TODO: zmienić w JSON
//serializacja
String saveGameEncode(
    List<List<int>> score,
    int roundsCompleting,
    List<String> playerNames,
    List<int> playerGiveRemaining,
    List<int> playerGiveHistory,
    int color,
    int playerCount,
    String timeIndex) {
  String outputString = '$color#';
  for (int x = 0; x <= 3; x++) {
    if (kDebugMode) print("running for $x");
    for (var subElement in score[x]) {
      outputString += '$subElement ';
    }
    outputString += '#';
  }
  for (var element in playerNames) {
    outputString += '$element+';
  }
  outputString = outputString.substring(0, outputString.length - 1);
  outputString += '#';
  for (var element in playerGiveRemaining) {
    outputString += '$element ';
  }
  outputString += '#';
  for (var element in playerGiveHistory) {
    outputString += '$element ';
  }
  outputString += '#';
  outputString += playerCount.toString();
  outputString += '#';
  outputString += roundsCompleting.toString();
  outputString += '#';
  outputString += timeIndex
      .toString(); //timeIndex MUSI być ostatni, opiera się na tym działanie usuwania
  if (kDebugMode) print('Blended game data into the following String: $outputString');
  return outputString;
}

sumAll(List<int> listName) {
  int sum = 0;
  for (var element in listName) {
    sum += element;
  }
  return sum;
}