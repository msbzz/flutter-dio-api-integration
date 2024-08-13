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
  
  DioService(){
    _dio.interceptors.add(DioInterceptor());
  }
 
  Future<void> saveLocalToServer(AppDatabase appDatabase) async {
    Map<String, dynamic> localData =
        await LocalDataHandler().localDataToMap(appdatabase: appDatabase);

    await _dio.put(
      'listins.json',
      data: json.encode(
        localData["listins"],
      ),
    );
  }

  getDataFromServer(AppDatabase appDatabase) async {


    Response response = await _dio.get('listins.json',
        queryParameters: {"orderBy": '"name"', "startAt": 0,});

       // print('response.data ===>>>  ${response.data}');

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
  }

  Future<void> clearServerData() async {
    await _dio.delete('listins.json');
  }
}
