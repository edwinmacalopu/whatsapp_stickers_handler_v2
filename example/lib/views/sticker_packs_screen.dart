import '../providers/sticker_packs.dart';
import '../widgets/nav_drawer.dart';
import '../widgets/sticker_packs_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StickerPacksScreen extends StatelessWidget {
  static const String routeName = "/";
  const StickerPacksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const NavDrawer(),
        appBar: AppBar(
          title: const Text("Christmas Stickers"),
          backgroundColor: const Color.fromARGB(255, 125, 153, 255),
        ),
        body: FutureBuilder(
          future: Provider.of<StickerPacks>(context, listen: false)
              .fetchStickerPacks(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return const StickerPacksList();
          },
        ),
      ),
    );
  }
}
