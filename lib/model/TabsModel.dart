import 'package:fluttertest/model/TabsData.dart';

class TabsModel {
  TabsData data;
  String msg;

  TabsModel({this.data, this.msg});

  factory TabsModel.fromJson(Map<String, dynamic> json) {
    return TabsModel(
      data: json['data'] != null ? TabsData.fromJson(json['data']) : null,
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
