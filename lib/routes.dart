import 'package:flutter/material.dart';
import 'package:flutter_mvvm/presentation/pages/card/add_card_page.dart';
import 'package:flutter_mvvm/presentation/pages/card/add_card_vm.dart';
import 'package:flutter_mvvm/presentation/pages/home/home_page.dart';
import 'package:flutter_mvvm/presentation/pages/home/home_page_vm.dart';

class AppRouter {
  Route<dynamic>? route(RouteSettings settings) {
    final arguments = settings.arguments as Map<String, dynamic>? ?? {};

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HomePage(viewModel: HomePageViewModel()),
        );
      case '/card':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AddCardPage(viewModel: AddCardPageViewModel()),
        );
      default:
        throw Exception('Route ${settings.name} not implemented');
    }
  }
}
