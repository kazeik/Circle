import 'package:fluttertest/model/NewsListItemModel.dart';

class NewsData {
  List<NewsListItemModel> list;

  NewsData({this.list});

  factory NewsData.fromJson(Map<String, dynamic> json) {
    return NewsData(
      list: json['list'] != null
          ? (json['list'] as List)
              .map((i) => NewsListItemModel.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
