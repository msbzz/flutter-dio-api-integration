import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class DioInterceptor extends Interceptor {
  Logger _logger =
      Logger(printer: PrettyPrinter(methodCount: 0, printEmojis: false));

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    //print("${DateTime.now()} | Uma requisição foi feita!");
    String log = "";
    log += "REQUISIÇÃO\n";
    log += "Timestamp: ${DateTime.now()}\n";
    log += "Método: ${options.method}";
    log += "URL: ${options.uri}\n";
    log +=
        "Cabeçalho: ${JsonEncoder.withIndent("  ").convert(options.headers)}\n";

    if (options.data != null) {
      log +=
          "Corpo: ${JsonEncoder.withIndent('  ').convert(json.decode(options.data))}\n";
    }
    _logger.w(log);

    Dio().post('${dotenv.env["FIREBASE_URL"]!}/logs.json',
        data: {"request": log});

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("${DateTime.now()} | Uma resposta foi recebida!");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("${DateTime.now()} | Um erro aconteceu!");
    super.onError(err, handler);
  }

  // final Logger _logger = Logger(
  //   printer: PrettyPrinter(
  //       methodCount: 0,
  //       printEmojis: false,
  //   ),
  // )
}
