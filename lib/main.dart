import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase AdMob Test Ads Demo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  InterstitialAd myInterstitial;

  InterstitialAd buildInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          myInterstitial..load();
        } else if (event == MobileAdEvent.closed) {
          myInterstitial = buildInterstitialAd()..load();
        }
        print(event);
      },
    );
  }

  BannerAd myBanner;

  BannerAd buildBannerAd() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myBanner..show();
          }
        });
  }

  void showInterstitialAd() {
    myInterstitial..show();
  }

  void showRandomInterstitialAd() {
    Random r = new Random();
    bool value = r.nextBool();

    if (value == true) {
      myInterstitial..show();
    }
  }

  @override
  void initState() {
    super.initState();

    myInterstitial = buildInterstitialAd()..load();
  }

  @override
  void dispose() {
    myInterstitial.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Test Ad App'),
      ),
      body: Center(
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('BannerAd'),
              onPressed: () {
                myInterstitial.show();
                //Navigator.push(context, MaterialPageRoute(builder: (context) => BannerAdPage()));
              },
            ),
            RaisedButton(
              child: Text('InterstitialAd'),
              onPressed: () {
                showInterstitialAd();
                //showRandomInterstitialAd();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InterstitialAdPage()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class InterstitialAdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('InterstitialAd Page'),
      ),
    );
  }
}

class BannerAdPage extends StatefulWidget {
  @override
  _BannerAdPageState createState() => _BannerAdPageState();
}

class _BannerAdPageState extends State<BannerAdPage> {

  BannerAd myBanner;

  BannerAd buildBannerAd() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myBanner..show();
          }
        });
  }

  BannerAd buildLargeBannerAd() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.largeBanner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myBanner
              ..show(
                  anchorType: AnchorType.top,
                  anchorOffset: MediaQuery.of(context).size.height * 0.15);
          }
        });
  }

  @override
  void initState() {
    super.initState();

    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    myBanner = buildBannerAd()..load();
    //myBanner = buildLargeBannerAd()..load();
  }

  @override
  void dispose() {
    myBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('BannerAd Page'),
      ),
    );
  }
}