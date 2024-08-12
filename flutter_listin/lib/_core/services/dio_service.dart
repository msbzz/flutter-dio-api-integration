import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_listin/_core/data/local_data_handler.dart';
import 'package:flutter_listin/listins/data/database.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioService {
  final Dio _dio = Dio(BaseOptions(
      baseUrl: dotenv.env['FIREBASE_URL']!,
      contentType: "application/json; uft-8;",
      responseType: ResponseType.json,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3)));

  // String url = dotenv.env['FIREBASE_URL']!;

  Future<void> saveLocalToServer(AppDatabase appDatabase) async {
    Map<String, dynamic> localData =
        await LocalDataHandler().localDataToMap(appdatabase: appDatabase);

    await _dio.put(
      'listin.json',
      data: json.encode(
        localData["listins"],
      ),
    );
  }

  getDataFromServer(AppDatabase appDatabase) async {
    Response response = await _dio.get('listin.json');

    if (response.data != null) {
      if ((response.data as List<dynamic>).isNotEmpty) {
        Map<String, dynamic> map = {};
        map["listins"] = response.data;
        await LocalDataHandler().mapToLocalData(
          map: map,
          appdatabase: appDatabase,
        );
      }
    }
  }

  Future<void> clearServerData() async {
    await _dio.delete('listin.json');
  }
}
