import 'package:dio/dio.dart';

// Dio Helper is specified for APIs :

class DioHelper {
  // cuz i need to use an object for the functions :
  static Dio dio = 1 as Dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://api.adviceslip.com/',
      // even when we have a status error recieve :
      receiveDataWhenStatusError: true,
    ));
  }

  static Future<Response> getData({
    required String url,
  }) async {
    return await dio.get(
      url,
    );
  }
}
