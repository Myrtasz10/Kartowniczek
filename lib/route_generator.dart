import 'package:flutter/material.dart';
import './tysiac_game_screen.dart';
import './main.dart';
import './tysiac_save_list.dart';
import './tysiac_creation.dart';
import './create_kent.dart';
import './kent_game_screen.dart';
import './stats.dart';
import './tysiac_settings.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const FirstPage());
      case '/play':
        //if (args is String) {
        return MaterialPageRoute(builder: (_) => GameScreen(data: args as List<String>));
      //}
      //return _errorRoute();
      case '/create':
        return MaterialPageRoute(builder: (_) => const Create());
      case '/tysiąc':
        return MaterialPageRoute(builder: (_) => const Tysiac());
      case '/createKent':
        return MaterialPageRoute(builder: (_) => const CreateKent());
      case '/kent':
        return MaterialPageRoute(builder: (_) => Kent(data: args as List<String>));
      case '/stats':
        return MaterialPageRoute(builder: (_) => const Stats());
      case '/tysiacsettings':
        return MaterialPageRoute(builder: (_) => const TysiacSettings());
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
