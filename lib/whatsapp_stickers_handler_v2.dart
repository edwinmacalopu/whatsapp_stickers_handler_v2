import 'whatsapp_stickers_handler_v2_platform_interface.dart';

class WhatsappStickersHandlerV2 {
  Future<String?> getPlatformVersion() {
    return WhatsappStickersHandlerV2Platform.instance.getPlatformVersion();
  }

  Future<bool?> isWhatsAppInstalled() {
    return WhatsappStickersHandlerV2Platform.instance.isWhatsAppInstalled();
  }

  Future<bool?> isWhatsAppConsumerAppInstalled() {
    return WhatsappStickersHandlerV2Platform.instance
        .isWhatsAppConsumerAppInstalled();
  }

  Future<bool?> isWhatsAppSmbAppInstalled() {
    return WhatsappStickersHandlerV2Platform.instance
        .isWhatsAppSmbAppInstalled();
  }

  Future<bool?> launchWhatsApp() {
    return WhatsappStickersHandlerV2Platform.instance.launchWhatsApp();
  }

  Future<bool?> isStickerPackInstalled(String identifier) {
    return WhatsappStickersHandlerV2Platform.instance
        .isStickerPackInstalled(identifier);
  }

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
      bool? animatedStickerPack) {
    return WhatsappStickersHandlerV2Platform.instance.addStickerPackToWhatsApp(
        identifier,
        name,
        publisher,
        trayimagefile,
        stickers,
        publisheremail ?? "",
        publisherwebsite ?? "",
        privacypolicywebsite ?? "",
        licenseagreementwebsite ?? "",
        imageDataVersion ?? "1",
        avoidCache ?? false,
        animatedStickerPack ?? false);
  }
}
