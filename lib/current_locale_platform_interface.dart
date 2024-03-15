import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'current_locale_method_channel.dart';

abstract class CurrentLocalePlatform extends PlatformInterface {
  /// Constructs a CurrentLocalePlatform.
  CurrentLocalePlatform() : super(token: _token);

  static final Object _token = Object();

  static CurrentLocalePlatform _instance = MethodChannelCurrentLocale();

  /// The default instance of [CurrentLocalePlatform] to use.
  ///
  /// Defaults to [MethodChannelCurrentLocale].
  static CurrentLocalePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CurrentLocalePlatform] when
  /// they register themselves.
  static set instance(CurrentLocalePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
