import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whatsapp_stickers_handler_v2/whatsapp_stickers_handler_v2_method_channel.dart';

void main() {
  MethodChannelWhatsappStickersHandlerV2 platform = MethodChannelWhatsappStickersHandlerV2();
  const MethodChannel channel = MethodChannel('whatsapp_stickers_handler_v2');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
