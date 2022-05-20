import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:whatsapp_stickers_handler_v2/exceptions.dart';
import 'package:whatsapp_stickers_handler_v2/whatsapp_stickers_handler_v2_platform_interface.dart';

import '../providers/google_ads.dart';
import '../providers/sticker_pack.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

enum AddToWhatsAppButtonSize {
  small,
  medium,
  large,
}

class AddToWhatsAppButton extends StatefulWidget {
  final StickerPack stickerPack;
  final AddToWhatsAppButtonSize size;

  const AddToWhatsAppButton({
    Key? key,
    required this.stickerPack,
    this.size = AddToWhatsAppButtonSize.large,
  }) : super(key: key);

  @override
  State<AddToWhatsAppButton> createState() => _AddToWhatsAppButtonState();
}

class _AddToWhatsAppButtonState extends State<AddToWhatsAppButton> {
  final WhatsappStickersHandlerV2Platform _whatsappStickersHandler =
      WhatsappStickersHandlerV2Platform.instance;

  double get addToWhatsAppButtonTextSize {
    switch (widget.size) {
      case AddToWhatsAppButtonSize.large:
        return 16.0;
      case AddToWhatsAppButtonSize.medium:
        return 14.0;
      case AddToWhatsAppButtonSize.small:
        return 12.0;
      default:
        return 12.0;
    }
  }

  double get addToWhatsAppButtonIconSize {
    switch (widget.size) {
      case AddToWhatsAppButtonSize.large:
        return 20.0;
      case AddToWhatsAppButtonSize.medium:
        return 18.0;
      case AddToWhatsAppButtonSize.small:
        return 16.0;
      default:
        return 16.0;
    }
  }

  double get addToWhatsAppButtonVerticalPadding {
    switch (widget.size) {
      case AddToWhatsAppButtonSize.large:
        return 12.0;
      case AddToWhatsAppButtonSize.medium:
        return 10.0;
      case AddToWhatsAppButtonSize.small:
        return 8.0;
      default:
        return 8.0;
    }
  }

  @override
  void initState() {
    _whatsappStickersHandler
        .isStickerPackInstalled(widget.stickerPack.identifier)
        .then((value) {
      print("DEBUG is installed $value");
      setState(() {
        widget.stickerPack.isAddedToWhatsApp = value ?? false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final googleAdsProvider = Provider.of<GoogleAds>(context, listen: false);

    Future<void> addStickerToWhatsApp() async {
      Map<String, List<String>> stickers = <String, List<String>>{};

      for (var sticker in widget.stickerPack.stickers) {
        stickers[sticker.imageFile] = sticker.emojis;
      }

      try {
        await _whatsappStickersHandler.addStickerPackToWhatsApp(
          widget.stickerPack.identifier,
          widget.stickerPack.name,
          widget.stickerPack.publisher,
          widget.stickerPack.trayImageFile,
          stickers,
          widget.stickerPack.publisherEmail,
          widget.stickerPack.publisherWebsite,
          widget.stickerPack.privacyPolicyWebsite,
          widget.stickerPack.licenseAgreementWebsite,
          widget.stickerPack.imageDataVersion,
          widget.stickerPack.avoidCache,
          widget.stickerPack.animatedStickerPack,
        );
        setState(() {
          widget.stickerPack.isAddedToWhatsApp = true;
        });
      } on WhatsappStickersException catch (e) {
        if (e.cause == "cancelled") {
          return;
        }
        String cause = e.cause as String;
        if (e.cause == "already_added") {
          cause = "You have already added this sticker pack";
        }

        if (mounted && (kDebugMode || e.cause == "already_added")) {
          await showDialog(
            context: context,
            builder: (BuildContext ctx) {
              return AlertDialog(
                title: const Text("Error"),
                content: Text(cause),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text("Ok"),
                  )
                ],
              );
            },
          );
        } else if (kDebugMode) {
          print(cause);
        }
      }
    }

    return InkWell(
      onTap: widget.stickerPack.isAddedToWhatsApp
          ? null
          : () async {
              if (googleAdsProvider.interstitialAd() == null) {
                await addStickerToWhatsApp();
              } else {
                googleAdsProvider.interstitialAd()?.fullScreenContentCallback =
                    FullScreenContentCallback(
                  onAdShowedFullScreenContent: (InterstitialAd ad) {
                    if (kDebugMode) print('%ad onAdShowedFullScreenContent.');
                  },
                  onAdDismissedFullScreenContent: (InterstitialAd ad) async {
                    if (kDebugMode) {
                      print('$ad onAdDismissedFullScreenContent.');
                    }
                    await addStickerToWhatsApp();
                    ad.dispose();
                    googleAdsProvider.loadInterstitialAd();
                  },
                  onAdFailedToShowFullScreenContent:
                      (InterstitialAd ad, AdError error) {
                    if (kDebugMode) {
                      print('$ad onAdFailedToShowFullScreenContent: $error');
                    }
                    ad.dispose();
                    googleAdsProvider.loadInterstitialAd();
                  },
                  onAdImpression: (InterstitialAd ad) {
                    if (kDebugMode) print('$ad impression occurred.');
                  },
                );
                try {
                  if (googleAdsProvider.interstitialAd() == null) {
                    throw Exception("Ad not loaded");
                  }
                  googleAdsProvider.interstitialAd()?.show();
                } catch (e) {
                  await addStickerToWhatsApp();
                }
              }
            },
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.green,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 10, vertical: addToWhatsAppButtonVerticalPadding),
        decoration: BoxDecoration(
          color: widget.stickerPack.isAddedToWhatsApp
              ? const Color.fromARGB(255, 29, 178, 84).withOpacity(0.45)
              : const Color.fromARGB(255, 29, 178, 84).withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.whatsapp_outlined,
              size: addToWhatsAppButtonIconSize,
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Text(
                widget.stickerPack.isAddedToWhatsApp
                    ? "Added to WhatsApp"
                    : "Add to WhatsApp",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: addToWhatsAppButtonTextSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
