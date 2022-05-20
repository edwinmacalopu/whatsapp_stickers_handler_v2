import '../providers/sticker_packs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'sticker_packs_list_item.dart';

class StickerPacksList extends StatelessWidget {
  const StickerPacksList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("BUILD STICKER PACKS LIST");
    final stickerPacks =
        Provider.of<StickerPacks>(context, listen: false).stickerPacks;

    // return ListView(
    //   shrinkWrap: true,
    //   children: stickerPacks.map((sp) {
    //     return StickerPacksListItem(
    //       stickerPack: sp,
    //     );
    //   }).toList(),
    // );

    // return SingleChildScrollView(
    //   child: Column(
    //       children: stickerPacks.map((sp) {
    //     return StickerPacksListItem(
    //       stickerPack: sp,
    //     );
    //   }).toList()),
    // );

    return ListView.builder(
      itemBuilder: (ctx, index) {
        return StickerPacksListItem(
          key: ValueKey(index),
          stickerPack: stickerPacks[index],
        );
      },
      itemCount: stickerPacks.length,
    );
  }
}
