import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'whatsapp_stickers_handler_v2_method_channel.dart';

abstract class WhatsappStickersHandlerV2Platform extends PlatformInterface {
  /// Constructs a WhatsappStickersHandlerV2Platform.
  WhatsappStickersHandlerV2Platform() : super(token: _token);

  static final Object _token = Object();

  static WhatsappStickersHandlerV2Platform _instance =
      MethodChannelWhatsappStickersHandlerV2();

  /// The default instance of [WhatsappStickersHandlerV2Platform] to use.
  ///
  /// Defaults to [MethodChannelWhatsappStickersHandlerV2].
  static WhatsappStickersHandlerV2Platform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [WhatsappStickersHandlerV2Platform] when
  /// they register themselves.
  static set instance(WhatsappStickersHandlerV2Platform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError(
      'platformVersion() has not been implemented.',
    );
  }

  Future<bool?> isWhatsAppInstalled() {
    throw UnimplementedError(
      'isWhatsAppInstalled() has not been implemented.',
    );
  }

  Future<bool?> isWhatsAppConsumerAppInstalled() {
    throw UnimplementedError(
      'isWhatsAppConsumerAppInstalled() has not been implemented.',
    );
  }

  Future<bool?> isWhatsAppSmbAppInstalled() {
    throw UnimplementedError(
      'isWhatsAppSmbAppInstalled() has not been implemented.',
    );
  }

  Future<bool?> launchWhatsApp() {
    throw UnimplementedError(
      'launchWhatsApp() has not been implemented.',
    );
  }

  Future<bool?> isStickerPackInstalled(String identifier) {
    throw UnimplementedError(
      'isStickerPackInstalled() has not been implemented.',
    );
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
    throw UnimplementedError(
      'addStickerPackToWhatsApp() has not been implemented.',
    );
  }
}
