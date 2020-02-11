import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertest/utils/ApiUtils.dart';
import 'package:fluttertest/utils/MethodTyps.dart';
import 'package:fluttertest/utils/Utils.dart';
import 'package:quiver/strings.dart';

class HttpNet {
  // 工厂模式
  factory HttpNet() => _getInstance();

  Dio _dio;

  static HttpNet get instance => _getInstance();
  static HttpNet _instance;

  //初始化
  HttpNet._internal() {
    _initDio();
  }

  static HttpNet _getInstance() {
    if (_instance == null) {
      _instance = new HttpNet._internal();
    }
    return _instance;
  }

  _initDio() {
    _dio = new Dio();
    _dio.options.receiveTimeout = 15 * 1000;
    _dio.options.baseUrl = ApiUtils.baseUrl;
    _dio.options.responseType = ResponseType.plain;
    _dio.interceptors.add(LogInterceptor(responseBody: Utils.isDebug)); //开启请求日志
    _dio.interceptors.add(new InterceptorsWrapper(onRequest: (options) {
      Utils.logs("-->>  " + options.path);
      if (!_queryUrl(options.path)) {
        Utils.loading(Utils.mContext);
      }
      return options;
    }, onError: (options) {
      _hideLoading(options.request.path);
      return options;
    }, onResponse: (options) {
      _hideLoading(options.request.path);
      return options;
    }));
  }

  _hideLoading(String path) {
    if (!_queryUrl(path)) {
      Navigator.of(Utils.mContext, rootNavigator: true).pop();
    }
  }

  bool _queryUrl(String path) {
    if (null == Utils.mContext) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map> request(MethodTypes methodTypes, String path,
      {HashMap<String, dynamic> params,
      Function(dynamic) errorCallback,
      FormData data,
      HashMap<String, dynamic> headers,
      String contentType,
      Function relogin}) async {
    CancelToken token = new CancelToken();
    if (headers == null) headers = new HashMap();
    var options = new Options(headers: headers, contentType: contentType);
    Response<String> sValue;
    if (methodTypes == MethodTypes.GET) {
      sValue = await _dio.get(path,
          queryParameters: params, options: options, cancelToken: token);
    } else if (methodTypes == MethodTypes.POST) {
      sValue = await _dio.post(path,
          options: options, data: data, cancelToken: token);
    } else if (methodTypes == MethodTypes.PUT) {
      sValue = await _dio.put(path,
          queryParameters: params,
          options: options,
          data: data,
          cancelToken: token);
    } else if (methodTypes == MethodTypes.DELETE) {
      sValue = await _dio.delete(path,
          queryParameters: params,
          options: options,
          data: data,
          cancelToken: token);
    }
    if (sValue != null &&
        isNotEmpty(sValue.data) &&
        sValue.data != "null" &&
        sValue.statusCode == 200) {
      token.cancel();
      return jsonDecode(sValue.data);
    } else {
      throw Exception("服务端返回数据错误");
    }
  }

//  /*
//   * 数据加密
//   */
//  String cryptoData(String data) {
//    var key = utf8.encode(ApiUtils.secreKey);
//    var cryptoData = utf8.encode(data);
//
//    var hmacmd5 = new Hmac(md5, key);
//    String digest = hmacmd5.convert(cryptoData).toString();
//    return digest;
//  }

  /*
   * 获取加密前的header
   * @params method 请求方式 ，get,post,delete,put
   * @params params 请求参数
   * @params pathUrl 请求路径
   * @params syTime 用于签名的时间
   */
  String getParamsHeader(String pathUrl, var syTime,
      {Map<String, dynamic> params, String method = "get"}) {
    var temp = "";
    if (null != params) {
      for (MapEntry entry in params.entries) {
        temp = "$temp${entry.key}=${entry.value}&";
      }
      temp = temp.substring(0, temp.length - 1);
    }
    temp = isEmpty(temp) ? "" : "?$temp";
//    var data = "${method.toUpperCase()}:$pathUrl$temp:$syTime";
//    Utils.logs("参与计算的header数据 = $data");
//    var singValue = cryptoData(data);
//    dio.options.headers = {
//      "Authorization":
//          "Bearer ${isEmpty(ApiUtils.token) ? "" : ApiUtils.token}",
////      "X-Request-Timestamp": syTime,
////      "X-Auth-Signature": singValue
//    };
//    return singValue;
  }
}
