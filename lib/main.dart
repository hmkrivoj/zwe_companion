import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:zwe_companion/bloc/create/bloc.dart';
import 'package:zwe_companion/bloc/create/bloc_impl.dart';
import 'package:zwe_companion/bloc/filter/bloc.dart';
import 'package:zwe_companion/bloc/filter/bloc_impl.dart';
import 'package:zwe_companion/persistence/dao.dart';
import 'package:zwe_companion/persistence/impl/sqlite_dao.dart';
import 'package:zwe_companion/view/screens/main_scaffold.dart';

void main() async {
  final injector = Injector.getInjector();
  injector.map<Repository>((i) => SqliteRepository(), isSingleton: true);
  injector.map<CreateBLoC>(
      (i) => CreateBLoCImpl(i.get<Repository>(), DateTime.now()));
  injector.map<FilterBloc>((i) => FilterBlocImpl(i.get()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: MainScaffold(
        bloc: Injector.getInjector().get(),
      ),
    );
  }
}
