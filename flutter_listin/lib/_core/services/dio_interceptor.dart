import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class DioInterceptor extends Interceptor {
  Logger _logger =
      Logger(printer: PrettyPrinter(methodCount: 0, printEmojis: false));

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String log = "";
    log += "REQUISIÇÃO\n";
    log += "Timestamp: ${DateTime.now()}\n";
    log += "Método: ${options.method}\n";
    log += "URL: ${options.uri}\n";
    log +=
        "Cabeçalho: ${JsonEncoder.withIndent("  ").convert(options.headers)}\n";

    if (options.data != null) {
      log +=
          "Corpo: ${JsonEncoder.withIndent('  ').convert(json.decode(options.data))}\n";
    }
    _logger.w(log);

    Dio().post('${dotenv.env["FIREBASE_URL"]!}/logs.json', data: {"request": log});

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    String log = "";
    log += "RESPOSTA\n";
    log += "Timestamp: ${DateTime.now()}\n";
    log += "Status: ${response.statusCode}\n";
    log +=
        "Cabeçalho: ${JsonEncoder.withIndent("  ").convert(response.headers.map)}\n";

    if (response.data != null) {
      log +=
          "Corpo: ${JsonEncoder.withIndent('  ').convert(response.data)}\n";
    }
    _logger.i(log);

    Dio().post('${dotenv.env["FIREBASE_URL"]!}/logs.json', data: {"response": log});

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String log = "";
    log += "ERRO\n";
    log += "Timestamp: ${DateTime.now()}\n";
    log += "Mensagem: ${err.message}\n";
    log += "URL: ${err.requestOptions.uri}\n";

    if (err.response != null) {
      log += "Status: ${err.response?.statusCode}\n";
      log +=
          "Cabeçalho: ${JsonEncoder.withIndent("  ").convert(err.response?.headers.map)}\n";
      if (err.response?.data != null) {
        log +=
            "Corpo: ${JsonEncoder.withIndent('  ').convert(err.response?.data)}\n";
      }
    } else {
      log += "Detalhes: ${err.error}\n";
    }

    _logger.e(log);

    Dio().post('${dotenv.env["FIREBASE_URL"]!}/logs.json', data: {"error": log});

    super.onError(err, handler);
  }
}
