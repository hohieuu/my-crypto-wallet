import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ApiBaseHelper {
  String _baseUrl;
  Future<dynamic> get(String url) async {
    _baseUrl = 'http://192.168.1.4:5000/';

    print('Api Get, url     $_baseUrl$url');
    var responseJson;
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$url'),
      );

      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection  ');
    }
    // print('api get recieved!');
    // print(new DateTime.now().toString());
    // print(responseJson.toString());
    return responseJson;
  }

  Future<dynamic> post(String url, var body) async {
    _baseUrl = 'http://192.168.1.4:5000/';
    print('Api POST, url     $_baseUrl$url');
    var responseJson;
    try {
      final response = await http.post(Uri.parse('$_baseUrl$url'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection  ');
    }
    print('api post sent!');
    print(new DateTime.now().toString());
    print(responseJson.toString());
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
      case 405:
        print(response.headers);
        throw (response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

class ApiResponse<T> {
  Status status;
  T data;
  String message;
  ApiResponse.loading(this.message) : status = Status.LOADING;
  ApiResponse.completed(this.data) : status = Status.COMPLETED;
  ApiResponse.error(this.message) : status = Status.ERROR;
  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { PENDING, LOADING, COMPLETED, ERROR }

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}
