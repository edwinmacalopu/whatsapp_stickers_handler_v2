import 'package:flutter_test/flutter_test.dart';
import 'package:whatsapp_stickers_handler_v2/whatsapp_stickers_handler_v2.dart';
import 'package:whatsapp_stickers_handler_v2/whatsapp_stickers_handler_v2_platform_interface.dart';
import 'package:whatsapp_stickers_handler_v2/whatsapp_stickers_handler_v2_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWhatsappStickersHandlerV2Platform 
    with MockPlatformInterfaceMixin
    implements WhatsappStickersHandlerV2Platform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final WhatsappStickersHandlerV2Platform initialPlatform = WhatsappStickersHandlerV2Platform.instance;

  test('$MethodChannelWhatsappStickersHandlerV2 is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWhatsappStickersHandlerV2>());
  });

  test('getPlatformVersion', () async {
    WhatsappStickersHandlerV2 whatsappStickersHandlerV2Plugin = WhatsappStickersHandlerV2();
    MockWhatsappStickersHandlerV2Platform fakePlatform = MockWhatsappStickersHandlerV2Platform();
    WhatsappStickersHandlerV2Platform.instance = fakePlatform;
  
    expect(await whatsappStickersHandlerV2Plugin.getPlatformVersion(), '42');
  });
}
