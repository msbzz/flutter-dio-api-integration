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
     
    await _dio.put('${url}listin.json',
        data: json.encode(
          localData["listins"],
        ),
        options: Options(contentType: "application/json; uft-8;"));
  }

  getDataFromServer(AppDatabase appDatabase) async {
    Response response = await _dio.get('${url}listin.json');

    //print('STATUS CODE : ${response.statusCode}');
    // print('HEADERS : ${response.headers.toString()}');
    //print('DATA : ${response.data}');
    // print('TYPE DATA : ${response.data.runtimeType}');

    if(response.data!=null){
      if((response.data as List<dynamic>).isNotEmpty){
        //print('dentro de .isNotEmpty');
         Map<String,dynamic> map = {};
         map["listins"] = response.data;
         await LocalDataHandler().mapToLocalData(map: map, appdatabase: appDatabase,);
      }
    }
  }
  

  Future<void> clearServerData() async {
    await _dio.delete('${url}listin.json');
  }

}
