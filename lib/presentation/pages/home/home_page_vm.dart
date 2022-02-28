import 'package:flutter_mvvm/base/mvvm/app_routes.dart';
import 'package:flutter_mvvm/base/mvvm/view_model.abs.dart';
import 'package:rxdart/subjects.dart';

class HomePageViewModel extends ViewModel {
  final _routesSubject = PublishSubject<AppRouteSpec>();
  Stream<AppRouteSpec> get routes => _routesSubject;

  void cardPageButtonTapped() {
    _routesSubject.add(
      const AppRouteSpec(
        name: '/card',
        arguments: {},
      ),
    );
  }

  @override
  void dispose() {
    _routesSubject.close();
  }
}
