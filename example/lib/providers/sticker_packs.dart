import 'dart:convert';
import 'dart:io';

import '../helpers/utils.dart';
import '../main.dart';
import 'package:flutter/material.dart';

import 'sticker.dart';
import 'sticker_pack.dart';

class StickerPacks with ChangeNotifier {
  List<StickerPack> _stickerPacks = [];

  List<StickerPack> get stickerPacks {
    return [..._stickerPacks];
  }

  Future<void> fetchStickerPacks() async {
    File file = await Utils.localFile(constants.fileName);
    bool isFileExists = await file.exists();

    dynamic data;
    String response;

    if (!isFileExists) {
      data = await Utils.fetchDataAndWriteFile(file);
    } else {
      response = file.readAsStringSync();
      data = json.decode(response.toString()) as Map<String, dynamic>;

      if ((data['sticker_packs']).length <= 0) {
        data = await Utils.fetchDataAndWriteFile(file);
      }

      //response = await rootBundle.loadString("${constants.fileName}");
    }

    //var data = json.decode(response.toString()) as Map<String, dynamic>;

    final List<StickerPack> loadedStickerPacks = [];

    data['sticker_packs'].forEach((stickerPack) {
      final List<Sticker> stickers = [];
      stickerPack['stickers'].forEach((sticker) {
        final List<String> emojis = [];
        sticker['emojis'].forEach((emoji) {
          emojis.add(emoji);
        });

        stickers.add(Sticker(
          imageFile: sticker['image_file'],
          emojis: emojis,
        ));
      });

      loadedStickerPacks.add(StickerPack(
        identifier: stickerPack['identifier'],
        name: stickerPack['name'],
        publisher: stickerPack['publisher'],
        trayImageFile: stickerPack['tray_image_file'],
        publisherEmail: stickerPack['publisher_email'],
        publisherWebsite: stickerPack['publisher_website'],
        licenseAgreementWebsite: stickerPack['privacy_policy_website'],
        animatedStickerPack: stickerPack['animated_sticker_pack'],
        stickers: stickers,
      ));
    });
    _stickerPacks = loadedStickerPacks;
    notifyListeners();
  }

  StickerPack findByIdentifier(String identifier) {
    return _stickerPacks.firstWhere(
      (element) => element.identifier == identifier,
    );
  }
}
