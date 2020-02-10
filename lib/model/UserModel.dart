
import 'package:fluttertest/model/Userinfo.dart';

class UserModel {
    List<Object> fens;
    int id;
    String realname;
    Userinfo userinfo;
    String userpic;

    UserModel({this.fens, this.id, this.realname, this.userinfo, this.userpic});

    factory UserModel.fromJson(Map<String, dynamic> json) {
        return UserModel(
//            fens: json['fens'] != null ? (json['fens'] as List).map((i) => Object.fromJson(i)).toList() : null,
            id: json['id'], 
            realname: json['realname'], 
            userinfo: json['userinfo'] != null ? Userinfo.fromJson(json['userinfo']) : null, 
            userpic: json['userpic'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['realname'] = this.realname;
        data['userpic'] = this.userpic;
//        if (this.fens != null) {
//            data['fens'] = this.fens.map((v) => v.toJson()).toList();
//        }
        if (this.userinfo != null) {
            data['userinfo'] = this.userinfo.toJson();
        }
        return data;
    }
}