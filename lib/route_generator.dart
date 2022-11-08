import 'package:flutter/material.dart';
import './gameScreen.dart';
import './main.dart';
import './tysiac.dart';
import './gameCreationScreen.dart';
import './createKent.dart';
import './kent.dart';
import './stats.dart';
import './tysiacSettings.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const FirstPage());
      case '/play':
        //if (args is String) {
        return MaterialPageRoute(builder: (_) => GameScreen(data: args));
      //}
      //return _errorRoute();
      case '/create':
        return MaterialPageRoute(builder: (_) => const Create());
      case '/tysiąc':
        return MaterialPageRoute(builder: (_) => const Tysiac());
      case '/createKent':
        return MaterialPageRoute(builder: (_) => const CreateKent());
      case '/kent':
        return MaterialPageRoute(builder: (_) => Kent(data: args));
      case '/stats':
        return MaterialPageRoute(builder: (_) => const Stats());
      case '/tysiacsettings':
        return MaterialPageRoute(builder: (_) => TysiacSettings());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Brak ścieżki'),
        ),
        body: const Center(
          child:
              Text('Wybrana ścieżka nie istnieje. Wróć do poprzedniej strony.'),
        ),
      );
    });
  }
}
