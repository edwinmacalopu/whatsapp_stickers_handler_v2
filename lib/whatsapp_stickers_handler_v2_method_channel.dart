import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'exceptions.dart';
import 'whatsapp_stickers_handler_v2_platform_interface.dart';

/// An implementation of [WhatsappStickersHandlerV2Platform] that uses method channels.
class MethodChannelWhatsappStickersHandlerV2
    extends WhatsappStickersHandlerV2Platform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('whatsapp_stickers_handler_v2');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> isWhatsAppInstalled() async {
    final isWhatsAppInstalled =
        await methodChannel.invokeMethod<bool>('isWhatsAppInstalled');
    return isWhatsAppInstalled;
  }

  @override
  Future<bool?> isWhatsAppConsumerAppInstalled() async {
    final isWhatsAppConsumerAppInstalled = await methodChannel
        .invokeMethod<bool>('isWhatsAppConsumerAppInstalled');
    return isWhatsAppConsumerAppInstalled;
  }

  @override
  Future<bool?> isWhatsAppSmbAppInstalled() async {
    final isWhatsAppSmbAppInstalled =
        await methodChannel.invokeMethod<bool>('isWhatsAppSmbAppInstalled');
    return isWhatsAppSmbAppInstalled;
  }

  @override
  Future<bool?> launchWhatsApp() async {
    final launchWhatsApp =
        await methodChannel.invokeMethod<bool>('launchWhatsApp');
    return launchWhatsApp;
  }

  @override
  Future<bool?> isStickerPackInstalled(String identifier) async {
    final isStickerPackInstalled = await methodChannel.invokeMethod<bool>(
      'isStickerPackInstalled',
      {
        "identifier": identifier,
      },
    );
    return isStickerPackInstalled;
  }

  @override
  Future<String?> addStickerPackToWhatsApp(
      String identifier,
      String name,
      String publisher,
      String trayimagefile,
      Map<String, List<String>> stickers,
      String? publisheremail,
      String? publisherwebsite,
      String? privacypolicywebsite,
      String? licenseagreementwebsite,
      String? imageDataVersion,
      bool? avoidCache,
      bool? animatedStickerPack) async {
    try {
      final addStickerPackToWhatsApp = await methodChannel.invokeMethod<String>(
        'addStickerPackToWhatsApp',
        {
          "identifier": identifier,
          "name": name,
          "publisher": publisher,
          "trayimagefile": trayimagefile,
          "stickers": stickers,
          "publisheremail": publisheremail ?? "",
          "publisherwebsite": publisherwebsite ?? "",
          "privacypolicywebsite": privacypolicywebsite ?? "",
          "licenseagreementwebsite": licenseagreementwebsite ?? "",
          "imageDataVersion": imageDataVersion ?? "1",
          "avoidCache": avoidCache ?? false,
          "animatedStickerPack": animatedStickerPack ?? false
        },
      );
      return addStickerPackToWhatsApp;
    } on PlatformException catch (e) {
      switch (e.code) {
        case WhatsappStickersFileNotFoundException.CODE:
          throw WhatsappStickersFileNotFoundException(e.message);
        case WhatsappStickersNumOutsideAllowableRangeException.CODE:
          throw WhatsappStickersNumOutsideAllowableRangeException(e.message);
        case WhatsappStickersUnsupportedImageFormatException.CODE:
          throw WhatsappStickersUnsupportedImageFormatException(e.message);
        case WhatsappStickersImageTooBigException.CODE:
          throw WhatsappStickersImageTooBigException(e.message);
        case WhatsappStickersIncorrectImageSizeException.CODE:
          throw WhatsappStickersIncorrectImageSizeException(e.message);
        case WhatsappStickersAnimatedImagesNotSupportedException.CODE:
          throw WhatsappStickersAnimatedImagesNotSupportedException(e.message);
        case WhatsappStickersTooManyEmojisException.CODE:
          throw WhatsappStickersTooManyEmojisException(e.message);
        case WhatsappStickersEmptyStringException.CODE:
          throw WhatsappStickersEmptyStringException(e.message);
        case WhatsappStickersStringTooLongException.CODE:
          throw WhatsappStickersStringTooLongException(e.message);
        default:
          throw WhatsappStickersException(e.message);
      }
    }
  }
}
