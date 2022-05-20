import '../providers/sticker.dart';
import 'package:flutter/material.dart';

class StickerPack with ChangeNotifier {
  final String identifier;
  final String name;
  final String publisher;
  final String trayImageFile;
  String? imageDataVersion;
  bool? avoidCache;
  String? publisherEmail;
  String? publisherWebsite;
  String? privacyPolicyWebsite;
  String? licenseAgreementWebsite;
  bool? animatedStickerPack = false;
  final List<Sticker> stickers;
  bool isAddedToWhatsApp;
  String? downloadProgress;

  StickerPack({
    required this.identifier,
    required this.name,
    required this.publisher,
    required this.trayImageFile,
    this.imageDataVersion = "1",
    this.avoidCache = false,
    this.publisherEmail = "",
    this.publisherWebsite = "",
    this.licenseAgreementWebsite = "",
    this.animatedStickerPack = false,
    required this.stickers,
    this.isAddedToWhatsApp = false,
  });

  void addedToWhatsApp(bool isAddedToWhatsApp) {
    isAddedToWhatsApp = isAddedToWhatsApp;
    notifyListeners();
    super.notifyListeners();
  }

  void updateDownloadProgress(String progress) {
    downloadProgress = progress;
    notifyListeners();
  }

  @override
  String toString() {
    return "identifier $identifier name $name publisher $publisher trayImageFile $trayImageFile imageDataVersion $imageDataVersion";
  }
}
