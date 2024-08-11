import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_listin/_core/data/local_data_handler.dart';
import 'package:flutter_listin/listins/data/database.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioService {
  final Dio _dio = Dio();

  static String url = dotenv.env['FIREBASE_URL']!; 

  Future<void> saveLocalToServer(AppDatabase appDatabase) async {
    Map<String, dynamic> localData =
        await LocalDataHandler().localDataToMap(appdatabase: appDatabase);
    // print('localData >>> ${localData}');

    // print('_dio.put >>> ${url}listin.json');

    await _dio.put('${url}listin.json',
        data: json.encode(
          localData["listins"],
        ),
        options: Options(contentType: "application/json; uft-8;"));
  }
}
