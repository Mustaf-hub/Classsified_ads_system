import 'dart:io';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/widgets.dart';
import 'package:sellify/screens/addProduct/addproduct_screen.dart';
import '../api_config/store_data.dart';
import '../screens/loginscreen.dart';
import '../screens/splesh_screen.dart';


class AdHelper {
  static String get bannerAdUnitId {
    return Platform.isAndroid
        ? androidBannerid
        : iosBannerid;
  }
  static String get nativeAdunitId {
    return Platform.isAndroid
        ? androidNativeid
        : iosNativeid;
  }
}

InterstitialAd? _interstitialAd;
int _numInterstitialLoadAttempts = 0;
const int maxFailedLoadAttempts = 3;

AdWithView? _bannerAd;
bool _isLoaded = false;

const AdRequest request = AdRequest(
  keywords: <String>['foo', 'bar'],
  contentUrl: 'http://foo.com/bar.html',
  nonPersonalizedAds: true,
);


AdWithView bannerADs(){
  return _bannerAd!;
}

InterstitialAd interstitialAda(){
  return _interstitialAd!;
}
void createInterstitialAd() {
  InterstitialAd.load(
    adUnitId: Platform.isAndroid
        ? androidinId
        : iosinId,
    request: request,
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (InterstitialAd ad) {
        _interstitialAd = ad;
        _numInterstitialLoadAttempts = 0;
        _interstitialAd!.setImmersiveMode(true);
      },
      onAdFailedToLoad: (LoadAdError error) {
        _numInterstitialLoadAttempts += 1;
        _interstitialAd = null;
        if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
          createInterstitialAd();
        } else {}
      },
    ),
  );
}

void showInterstitialAd() {
  if (_interstitialAd == null) {
    return;
  }
  _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) {
      if(getData.read("UserLogin") == null){
        Get.offAll(const Loginscreen(), transition: Transition.noTransition);
      } else {
        Get.to(const AddproductScreen(), transition: Transition.noTransition);
      }
    },
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      ad.dispose();
      if(getData.read("UserLogin") == null){
        Get.offAll(const Loginscreen(), transition: Transition.noTransition);
      } else {
        Get.to(const AddproductScreen(), transition: Transition.noTransition);
      }
      createInterstitialAd();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      ad.dispose();
      if(getData.read("UserLogin") == null){
        Get.offAll(const Loginscreen(), transition: Transition.noTransition);
      } else {
        Get.to(const AddproductScreen(), transition: Transition.noTransition);
      }
      createInterstitialAd();
    },
  );
  _interstitialAd!.show();
  _interstitialAd = null;
}


void loadAd() {
  _bannerAd = BannerAd(
    adUnitId: Platform.isAndroid
        ? androidBannerid
        : iosBannerid,
    request: const AdRequest(),
    size: AdSize.banner,
    listener: BannerAdListener(
      onAdLoaded: (ad) {
        debugPrint('$ad loaded.');
        _isLoaded = true;

      },
      onAdFailedToLoad: (ad, err) {
        debugPrint('BannerAd failed to load: $err');
        ad.dispose();
      },
    ),
  )..load();
}

