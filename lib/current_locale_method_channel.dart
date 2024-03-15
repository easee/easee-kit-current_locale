import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'current_locale_platform_interface.dart';

/// An implementation of [CurrentLocalePlatform] that uses method channels.
class MethodChannelCurrentLocale extends CurrentLocalePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('current_locale');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
