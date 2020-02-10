
import 'package:fluttertest/model/TabsListItem.dart';

class TabsData {
    List<TabsListItem> list;

    TabsData({this.list});

    factory TabsData.fromJson(Map<String, dynamic> json) {
        return TabsData(
            list: json['list'] != null ? (json['list'] as List).map((i) => TabsListItem.fromJson(i)).toList() : null,
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