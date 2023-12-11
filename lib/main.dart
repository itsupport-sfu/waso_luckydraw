import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waso_ticket_system/presentation/bloc/welcome_bloc.dart';
import 'package:window_manager/window_manager.dart';

import 'data/repo/luck_repo.dart';
import 'presentation/bloc/luck_bloc.dart';
import 'presentation/bloc/select_bloc.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await windowManager.maximize();
  await windowManager.setFullScreen(true);
  await windowManager.setResizable(false);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => LuckBloc(ILuckRepo())..add(InitLuckEvent())),
        BlocProvider(create: (context) => SelectBloc()),
        BlocProvider(create: (context) => WelcomeBloc()),
      ],
      child: MaterialApp(
        title: 'Lucky Draw',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
