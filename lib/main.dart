// ignore_for_file: avoid_print

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'Modules/Home.dart';
import 'Network/dio_helper.dart';
import 'shared/HomeCubit/cubit.dart';
import 'shared/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => HomeCubit()
                ..getNaseha()
                ..initOneSignalPlatform()
                ..loadInterStatialAd()
                ..loadRewardAd())
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: AnimatedSplashScreen(
                splashIconSize: 130,
                duration: 4000,
                splash: Image(
                  image: AssetImage('assets/logo1.png'),
                ),
                nextScreen: Home(),
                splashTransition: SplashTransition.fadeTransition,
                backgroundColor: Colors.white)));
  }
}
