import 'package:clean_architecture/core/services/injection_container.dart';
import 'package:clean_architecture/features/authentication/presentation/cubic/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/authentication/presentation/views/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthenticationCubit>(),
      child: MaterialApp(
        theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity
        ),
        home: HomeScreen(),
      ),
    );
  }
}

