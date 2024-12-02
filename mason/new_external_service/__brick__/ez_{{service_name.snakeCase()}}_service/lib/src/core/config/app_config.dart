import 'package:envied/envied.dart';

part 'app_config.g.dart';

@Envied(
  path: '.env',
  useConstantCase: true,
  obfuscate: true,
)
class AppConfig {
  @EnviedField()
  static String product = _AppConfig.product;

  @EnviedField()
  static String env = _AppConfig.env;

  @EnviedField()
  static String appName = _AppConfig.appName;

  @EnviedField()
  static String appDesc = _AppConfig.appDesc;

  @EnviedField()
  static int port = _AppConfig.port;

  @EnviedField()
  static String baseUrl = _AppConfig.baseUrl;

  @EnviedField()
  static String telegramUrl = _AppConfig.telegramUrl;

  @EnviedField()
  static String telegramChatId = _AppConfig.telegramChatId;

  @EnviedField()
  static String discordUrl = _AppConfig.discordUrl;
}
