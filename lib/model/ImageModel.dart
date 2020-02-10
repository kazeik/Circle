
import 'package:fluttertest/model/PivotModel.dart';

class ImageModel {
    PivotModel pivot;
    String url;

    ImageModel({this.pivot, this.url});

    factory ImageModel.fromJson(Map<String, dynamic> json) {
        return ImageModel(
            pivot: json['pivot'] != null ? PivotModel.fromJson(json['pivot']) : null,
            url: json['url'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['url'] = this.url;
        if (this.pivot != null) {
            data['pivot'] = this.pivot.toJson();
        }
        return data;
    }
}