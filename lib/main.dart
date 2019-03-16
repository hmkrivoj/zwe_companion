import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:zwe_companion/bloc/filter/bloc.dart';
import 'package:zwe_companion/bloc/filter/bloc_impl.dart';
import 'package:zwe_companion/persistence/impl/sqlite_repository.dart';
import 'package:zwe_companion/persistence/repository.dart';
import 'package:zwe_companion/view/screens/create_screen.dart';
import 'package:zwe_companion/view/screens/filter_screen.dart';

void main() {
  setUpDependencies();
  setUpRoutes();
  final router = Injector.getInjector().get<Router>();
  runApp(MyApp(router: router));
}

/// Registers all interdependencies with the dependency injector.
void setUpDependencies() {
  final injector = Injector.getInjector();
  injector.map<Router>((i) => Router(), isSingleton: true);
  injector.map<Repository>((i) => SqliteRepository(), isSingleton: true);
  injector.map<FilterBloc>(
      (i) => FilterBlocImpl(i.get<Repository>(), DateTime.now()),
      isSingleton: true);
}

/// Registers handlers for all page routes.
void setUpRoutes() {
  final injector = Injector.getInjector();
  final router = injector.get<Router>();
  // Route handlers
  final home = Handler(handlerFunc: (context, params) {
    return FilterScreen(bloc: injector.get());
  });
  final create = Handler(handlerFunc: (context, params) {
    return CreateScreen();
  });
  // Routes
  router.define('/', handler: home);
  router.define('/create', handler: create);
}

class MyApp extends StatelessWidget {
  final Router router;

  const MyApp({Key key, @required this.router}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('de', 'DE'),
      ],
      title: 'ZWE Companion',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.blueAccent,
      ),
      onGenerateRoute: router.generator,
      initialRoute: '/',
    );
  }
}
