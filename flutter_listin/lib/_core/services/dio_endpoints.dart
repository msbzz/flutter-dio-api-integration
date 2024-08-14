import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioEndpoinst{
  static final String devBaseUrl = dotenv.env['FIREBASE_URL']!;

  static String listins ='listins.json';
  static String logs ='logs.json';
}