import '../providers/google_ads.dart';
import '../providers/sticker_packs.dart';
import '../views/sticker_packs_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

mixin constants {
  static String baseUrl =
      "https://mandj.sfo2.cdn.digitaloceanspaces.com/christmas-stickers/";
  static String fileName = "remote_sticker_packs.json";
  static String remoteFileName = "sticker_packs.json";
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => StickerPacks()),
        ChangeNotifierProvider(create: (ctx) => GoogleAds())
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: "Cabin",
          textTheme: const TextTheme(
            bodyText1: TextStyle(
              color: Color.fromARGB(255, 43, 52, 77),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            bodyText2: TextStyle(
              color: Color.fromARGB(255, 43, 52, 77),
              fontSize: 8,
            ),
          ),
        ),
        initialRoute: "/",
        routes: {
          StickerPacksScreen.routeName: (ctx) => const StickerPacksScreen(),
        },
        //onGenerateRoute: route.controller,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
