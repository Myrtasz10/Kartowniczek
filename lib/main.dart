import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './route_generator.dart';
import './Colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Kartowniczek'),
        centerTitle: true,
        backgroundColor: MyColors.appBarGreen,
        actions: <Widget>[IconButton(icon: new Icon(Icons.bar_chart_outlined), onPressed: (){
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
              child: Text(
                'Wybierz grę:',
                style: TextStyle(fontSize: 30),
              ),
              padding: EdgeInsets.all(30),
            ),
            AspectRatio(
                aspectRatio: 5 / 3,
                child: Row(children: <Widget>[
                  Expanded(
                      child: ElevatedButton(
                    child: Column(
                      children: <Widget>[
                        Expanded(child: Image.asset('images/tysiac.png')),
                        Text(
                          'Tysiąc',
                          textScaleFactor: 1.5,
                          style: TextStyle(color: Colors.black87),
                        ),
                        Container(
                          height: 20,
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(MyColors.raisedButtonGrey)),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/tysiąc');
                    },
                  )),
                  Expanded(child: Container())
                ])),
            AspectRatio(
                aspectRatio: 5 / 3,
                child: Row(children: <Widget>[
                  Expanded(
                      child: ElevatedButton(
                        child: Column(
                          children: <Widget>[
                            Expanded(child: Image.asset('images/kent.png')),
                            Text(
                              'Kent',
                              textScaleFactor: 1.5,
                              style: TextStyle(color: Colors.black87),
                            ),
                            Container(
                              height: 20,
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(MyColors.raisedButtonGrey)),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/createKent');
                        },
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