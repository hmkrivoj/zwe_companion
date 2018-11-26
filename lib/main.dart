import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:zwe_companion/bloc/create/bloc.dart';
import 'package:zwe_companion/bloc/create/bloc_impl.dart';
import 'package:zwe_companion/bloc/filter/bloc.dart';
import 'package:zwe_companion/bloc/filter/bloc_impl.dart';
import 'package:zwe_companion/persistence/dao.dart';
import 'package:zwe_companion/persistence/impl/sqlite_dao.dart';
import 'package:zwe_companion/view/screens/create_workday.dart';
import 'package:zwe_companion/view/screens/main_scaffold.dart';

void main() {
  setUpDependencies();
  setUpRoutes(Injector.getInjector().get<Router>());
  runApp(MyApp(router: Injector.getInjector().get<Router>()));
}

Injector setUpDependencies() {
  final injector = Injector.getInjector();
  injector.map<Router>((i) => Router(), isSingleton: true);
  injector.map<Repository>((i) => SqliteRepository(), isSingleton: true);
  injector.map<FilterBloc>((i) => FilterBlocImpl(i.get(), DateTime.now()),
      isSingleton: true);
  injector.map<CreateBLoC>(
      (i) => CreateBLoCImpl(i.get<Repository>(), DateTime.now()));
  return injector;
}

void setUpRoutes(Router router) {
  var home = Handler(handlerFunc: (context, params) {
    return MainScaffold(bloc: Injector.getInjector().get());
  });
  var create = Handler(handlerFunc: (context, params) {
    return CreateWorkdayScaffold(initialBloc: Injector.getInjector().get());
  });
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
