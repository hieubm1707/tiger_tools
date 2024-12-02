// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:ez_core/ez_core.dart';
import 'package:ez_{{service_name.snakeCase()}}_service/ez_{{service_name.snakeCase()}}_service.dart';

Future<void> init(InternetAddress ip, int port) async {
  final publicDirectory = Directory('./public');
  if (!publicDirectory.existsSync()) {
    await publicDirectory.create(recursive: true);
  }
  configInjector();

  await EZBotApi.instance.handleRestartServer(
    BotConfigBase(
      telegramUrl: AppConfig.telegramUrl,
      telegramChatId: AppConfig.telegramChatId,
      discordUrl: AppConfig.discordUrl,
      telegramOSUrl: AppConfig.telegramOsUrl,
      telegramOSChatId: AppConfig.telegramOsChatId,
    ),
    AppConfig.env,
    AppConfig.appName,
  );

  print('** Running on http://localhost:${AppConfig.port} **');
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  final cascade = Cascade().add(handler);
  return serve(cascade.handler, ip, AppConfig.port);
}
