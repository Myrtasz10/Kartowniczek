// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './route_generator.dart';
import './Colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Initially display FirstPage
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartowniczek'),
        centerTitle: true,
        backgroundColor: MyColors.appBarGreen,
        actions: <Widget>[IconButton(icon: const Icon(Icons.bar_chart_outlined), onPressed: (){
          print(DateTime.now().toString());
          Navigator.of(context).pushNamed('/stats');
      })],
      ),
      body: Card(
          child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(30),
              child: const Text(
                'Wybierz grę:',
                style: TextStyle(fontSize: 30),
              ),
            ),
            AspectRatio(
                aspectRatio: 5 / 3,
                child: Row(children: <Widget>[
                  Expanded(
                      child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(MyColors.raisedButtonGrey)),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/tysiąc');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(child: Image.asset('images/tysiac.png')),
                        const Text(
                          'Tysiąc',
                          textScaleFactor: 1.5,
                          style: TextStyle(color: Colors.black87),
                        ),
                        Container(
                          height: 20,
                        )
                      ],
                    ),
                  )),
                  Expanded(child: Container())
                ])),
            AspectRatio(
                aspectRatio: 5 / 3,
                child: Row(children: <Widget>[
                  Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(MyColors.raisedButtonGrey)),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/createKent');
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(child: Image.asset('images/kent.png')),
                            const Text(
                              'Kent',
                              textScaleFactor: 1.5,
                              style: TextStyle(color: Colors.black87),
                            ),
                            Container(
                              height: 20,
                            )
                          ],
                        ),
                      )),
                  Expanded(child: Container())
                ]))
          ],
        ),
      )),
    );
  }
}

//TODO: Integrate with GitHub