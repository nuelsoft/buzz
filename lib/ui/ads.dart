import 'package:firebase_admob/firebase_admob.dart';

class Ads {
  static BannerAd myBanner;
  static InterstitialAd myInterstitial;

  final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>[
      'flutterio',
      'beautiful apps',
      'students',
      'scholarship abroad',
      'youth movement',
      'books',
      'songs',
      'gadgets',
      'phones',
      'meditation'
    ],
    contentUrl: 'https://google.com',
    // birthday: DateTime.now(),
    childDirected: false,
    // designedForFamilies: false,
    // gender: MobileAdGender
    // .male, // or MobileAdGender.female, MobileAdGender.unknown
    // testDevices: <String>[
    // 'SM_G360T_API_22:57727af1'
    // ], // Android emulators are considered test devices
  );

  Future<void> adsInstantiate() async {
    myBanner = BannerAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      adUnitId: 'ca-app-pub-5714629379881538/1024250019',
      size: AdSize.fullBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );

    myInterstitial = InterstitialAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      adUnitId: 'ca-app-pub-5714629379881538/9727014340',
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
  }
}
