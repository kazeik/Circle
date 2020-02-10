
import 'package:fluttertest/model/NewsData.dart';

class NewsModel {
    NewsData data;
    String msg;

    NewsModel({this.data, this.msg});

    factory NewsModel.fromJson(Map<String, dynamic> json) {
        return NewsModel(
            data: json['data'] != null ? NewsData.fromJson(json['data']) : null,
            msg: json['msg'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['msg'] = this.msg;
        if (this.data != null) {
            data['data'] = this.data.toJson();
        }
        return data;
    }
}