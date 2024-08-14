import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_listin/_core/data/local_data_handler.dart';
import 'package:flutter_listin/_core/services/dio_interceptor.dart';
import 'package:flutter_listin/listins/data/database.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioService {
  final Dio _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['FIREBASE_URL']!,
      contentType: "application/json; utf-8;",
      responseType: ResponseType.json,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 13)));

  DioService() {
    _dio.interceptors.add(DioInterceptor());
  }

  Future<String?> saveLocalToServer(AppDatabase appDatabase) async {
    Map<String, dynamic> localData =
        await LocalDataHandler().localDataToMap(appdatabase: appDatabase);

    try {
      await _dio.put(
        'listins.json',
        data: json.encode(
          localData["listins"],
        ),
      );
      return null; // Retorna null para indicar sucesso
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        return e.response!.data!.toString();
      } else {
        return e.message;
      }
    } on Exception {
      return "Aconteceu um erro";
    }
  }

  Future<String?> getDataFromServer(AppDatabase appDatabase) async {
    try {
      Response response = await _dio.get('listins.json', queryParameters: {
        "orderBy": '"name"',
        "startAt": 0,
      });

      if (response.data != null) {
        Map<String, dynamic> map = {};

        if (response.data.runtimeType == List) {
          if ((response.data as List<dynamic>).isNotEmpty) {
            map["listins"] = response.data;
          }
        } else {
          List<Map<String, dynamic>> tempList = [];
          for (var mapResponse in (response.data as Map).values) {
            tempList.add(mapResponse);
          }
          map["listins"] = tempList;
        }

        await LocalDataHandler().mapToLocalData(
          map: map,
          appdatabase: appDatabase,
        );
      }
      return null; // Retorna null para indicar sucesso
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        return e.response!.data!.toString();
      } else {
        return e.message;
      }
    } on Exception {
      return "Aconteceu um erro";
    }
  }

  Future<String?> clearServerData() async {
    try {
      await _dio.delete('listins.json');
      return null; // Retorna null para indicar sucesso
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        return e.response!.data!.toString();
      } else {
        return e.message;
      }
    } on Exception {
      return "Aconteceu um erro";
    }
  }
}
