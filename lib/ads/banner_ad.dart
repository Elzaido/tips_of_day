import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_helper.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({Key? key}) : super(key: key);

  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  late BannerAd bannerAd;
  bool isAdReady = false;
  final AdSize adSize = AdSize.banner;

  void createBannerAd() {
    bannerAd = BannerAd(
      size: adSize,
      adUnitId: AdsHelper.bannerAdUnit,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          log('ad failed to load : ${error.message}');
        },
      ),
      request: const AdRequest(),
    );
    bannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    createBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isAdReady) {
      return Container(
        width: adSize.width.toDouble(),
        height: adSize.height.toDouble(),
        alignment: Alignment.center,
        child: AdWidget(ad: bannerAd),
      );
    }
    return Container();
  }
}
