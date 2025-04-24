import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:http/http.dart';


class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final Map<String, dynamic>? data;
  final String? errorMassage ;

  NetworkResponse({required this.isSuccess,
    required this.statusCode,
    this.data,
    this.errorMassage = 'Something went wrong'});
}

class ClientNetwork {
  static final Logger _logger = Logger();

  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      _preRequestLog(url);
      Response response = await get(uri);
      _postRequestLog(url, response.statusCode,
          headers: response.headers, responseBody: response.body);
      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,);
      } else {
        final decodeJson = jsonDecode(response.body);
        String errorMassage = decodeJson['data'] ?? 'Something Went Wrong';
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMassage: errorMassage
        );
      }
    } catch (e) {
      _postRequestLog(url, -1);
      return NetworkResponse(
          isSuccess: false,
          statusCode: -1,
          errorMassage: e.toString());
    }
  }

  static Future<NetworkResponse> postRequest({required String url , Map<String,dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);
      _preRequestLog(url , body: body);
      Response response = await post(
          uri,
        headers: {'Content-type' : 'Application/json'},
        body: jsonEncode(body)
      );
      _postRequestLog(url, response.statusCode,
          headers: response.headers, responseBody: response.body);

      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,);
      } else {
        final decodeJson = jsonDecode(response.body);
        String errorMassage = decodeJson['data'] ?? 'Something Went Wrong';
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMassage: errorMassage
        );
      }
    } catch (e) {
      _postRequestLog(url, -1, errorMessage: e.toString());
      return NetworkResponse(
          isSuccess: false,
          statusCode: -1,
          errorMassage: e.toString());
    }
  }

  static void _preRequestLog(String url,
      {Map<String, dynamic>? body}) {
    _logger.i('URL => $url\n'
        'Body: $body');
  }

  static void _postRequestLog(String url, int statusCode,
      {Map<String, dynamic>? headers,
        dynamic responseBody,
        dynamic errorMessage}) {
    if (errorMessage != null) {
      _logger.e(''
          'Url: $url\n'
          'Status code: $statusCode\n'
          'Error Message: $errorMessage');
    } else {
      _logger.i(''
          'Url: $url\n'
          'Status code: $statusCode\n'
          'Headers: $headers\n'
          'Response: $responseBody');
    }
  }
}
