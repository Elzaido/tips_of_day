// ignore_for_file: avoid_print, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tips_of_day/shared/HomeCubit/state.dart';
import '../../Modules/photo.dart';
import '../../Network/dio_helper.dart';

import '../../ads/ads_helper.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(InitialState());

  static HomeCubit get(context) => BlocProvider.of(context);
  static RewardedAd? rewardedAd;
  static bool isReadyAd = false;
  bool isAdShowen = false;
  final String oneSignalAppId = '11882d8b-03aa-45d5-9ac0-15bbbd4b0b24';
  static late InterstitialAd interstitialAd;
  static bool isReady = false;
  AppOpenAd? openAd;
  bool failRewardLoad = false;
  Map<String, dynamic> advice = {};
  int counter = 0;

  void getNaseha() {
    emit(LoadingNsehaState());
    DioHelper.getData(url: 'advice').then((value) {
      var jsonData = json.decode(value.data) as Map<String, dynamic>;
      advice = jsonData['slip'];

      emit(NasehaSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(NasehaErrorState());
    });
  }

  String copiedText = '';

  void copyText({
    required String text,
  }) {
    Clipboard.setData(ClipboardData(text: text));
    Clipboard.getData('text/plain').then((ClipboardData? data) {
      copiedText = data!.text.toString();
    }).then((value) {
      emit(CoppySuccessState());
    }).catchError((onError) {
      emit(CoppyErrorState());
    });
  }

  void loadInterStatialAd() {
    InterstitialAd.load(
      adUnitId: AdsHelper.interStatialAdUnit,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          isReady = true;
          interstitialAd = ad;
          emit(SuccessLoadStatialAdState());
        },
        onAdFailedToLoad: (error) {
          emit(ErrorLoadStatialAdState());
          print('ad faild to load ${error.message}');
        },
      ),
    );
  }

  void showInterStatialAd() {
    if (isReady) {
      interstitialAd.show();
      emit(SuccessShowStatialAdState());
      loadInterStatialAd();
    }
  }

  void loadRewardAd() {
    isAdShowen = false;

    RewardedAd.load(
        adUnitId: AdsHelper.rewardAdUnit,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          rewardedAd = ad;
          isReadyAd = true;
          emit(SuccessRewardAdLoad());
        }, onAdFailedToLoad: (error) {
          emit(ErrorRewardAdLoad());
          isAdShowen = true;
          failRewardLoad = true;
          print('Faild to load $error');
        }));
  }

  void showRewardAd({required context}) {
    if (isReadyAd) {
      rewardedAd!.show(onUserEarnedReward: (ad, rewardItem) {
        print('reward item type = ${rewardItem.type}');
        print('reward item amount = ${rewardItem.amount}');
        emit(RewardAdShowenState());
        isAdShowen = true;
      });
    }

    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: ((ad) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Photo()));
        print('ad dismissed');
        ad.dispose();
      }),
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
      },
    );
  }

  Future<void> initOneSignalPlatform() async {
    OneSignal.shared.setAppId(oneSignalAppId);
  }

  void increaseCounter() {
    if (counter < 3) {
      counter++;
    } else {
      counter = 0;
    }
    emit(IncreaseCounterState());
  }
}
