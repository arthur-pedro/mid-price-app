import 'dart:developer';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';

class GoogleAdmobHandler {
  // LOCAL
  // static const _bannerAdIdAndroid = "ca-app-pub-3940256099942544/6300978111";
  // static const _bannerAdIdIos = "ca-app-pub-3940256099942544/2934735716";
  // static const _intertstitialAdIdAndroid =
  //     "ca-app-pub-3940256099942544/1033173712";
  // static const _intertstitialAdIdIos = "ca-app-pub-3940256099942544/4411468910";
  // static const androidId = 'ca-app-pub-3940256099942544~3347511713';
  // static const iosAppId = '';

  // PRODUCTION
  static const iosAppId = '';
  static const _bannerAdIdIos = "";
  static const _intertstitialAdIdIos = "";

  static const androidApId = 'ca-app-pub-2016193863478284~2333933306';
  static const _intertstitialAdIdAndroid =
      'ca-app-pub-2016193863478284/3899679300';
  static const _bannerAdIdAndroid = 'ca-app-pub-2016193863478284/3516535921';

  static late AdmobInterstitial _interstitialAd;

  static String _getBannerId() =>
      Platform.isIOS ? _bannerAdIdIos : _bannerAdIdAndroid;
  static String _getInterstitialId() =>
      Platform.isIOS ? _intertstitialAdIdIos : _intertstitialAdIdAndroid;

  static void initAdmobInterstitial() {
    _interstitialAd = AdmobInterstitial(
        adUnitId: _getInterstitialId(),
        listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
          if (event == AdmobAdEvent.closed) _interstitialAd.load();
          _handleEvent(event, args, 'Interstitial');
        });
    _interstitialAd.load();
  }

  static AdmobBanner getBanner(AdmobBannerSize size) {
    return AdmobBanner(
      adUnitId: _getBannerId(),
      adSize: size,
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        _handleEvent(event, args, 'Banner');
      },
    );
  }

  static void showInterstitial() async {
    var loaded = await _interstitialAd.isLoaded;
    if (loaded != null && loaded == true) {
      _interstitialAd.show();
    } else {
      log("Interstitial ainda não foi carregado...");
    }
  }

  static _handleEvent(
      AdmobAdEvent event, Map<String, dynamic>? args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        log('Novo $adType Ad carregado!');
        break;
      case AdmobAdEvent.opened:
        log('Admob $adType Ad aberto!');
        break;
      case AdmobAdEvent.closed:
        log('Admob $adType Ad fechado!');
        break;
      case AdmobAdEvent.failedToLoad:
        log('Admob $adType falhou ao carregar. :(');
        break;
      default:
    }
  }
}
