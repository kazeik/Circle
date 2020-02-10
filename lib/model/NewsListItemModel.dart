
import 'package:fluttertest/model/ImageModel.dart';
import 'package:fluttertest/model/UserModel.dart';

class NewsListItemModel {
    int cai_count;
    int comment_count;
    String content;
    int create_time;
    int ding_count;
    int id;
    List<ImageModel> images;
    int img_count;
    int isopen;
    String path;
    int post_class_id;
    Object share;
    int share_id;
    int sharenum;
    List<Object> support;
    String title;
    String titlepic;
    int type;
    UserModel user;
    int user_id;

    NewsListItemModel({this.cai_count, this.comment_count, this.content, this.create_time, this.ding_count, this.id, this.images, this.img_count, this.isopen, this.path, this.post_class_id, this.share, this.share_id, this.sharenum, this.support, this.title, this.titlepic, this.type, this.user, this.user_id});

    factory NewsListItemModel.fromJson(Map<String, dynamic> json) {
        return NewsListItemModel(
            cai_count: json['cai_count'], 
            comment_count: json['comment_count'], 
            content: json['content'], 
            create_time: json['create_time'], 
            ding_count: json['ding_count'], 
            id: json['id'], 
            images: json['images'] != null ? (json['images'] as List).map((i) => ImageModel.fromJson(i)).toList() : null,
            img_count: json['img_count'], 
            isopen: json['isopen'], 
            path: json['path'], 
            post_class_id: json['post_class_id'], 
            share: json['share'] != null ? json['share'] : null,
            share_id: json['share_id'], 
            sharenum: json['sharenum'], 
//            support: json['support'] != null ? (json['support'] as List).map((i) => Object.fromJson(i)).toList() : null,
            title: json['title'], 
            titlepic: json['titlepic'], 
            type: json['type'], 
            user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
            user_id: json['user_id'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['cai_count'] = this.cai_count;
        data['comment_count'] = this.comment_count;
        data['content'] = this.content;
        data['create_time'] = this.create_time;
        data['ding_count'] = this.ding_count;
        data['id'] = this.id;
        data['img_count'] = this.img_count;
        data['isopen'] = this.isopen;
        data['path'] = this.path;
        data['post_class_id'] = this.post_class_id;
        data['share_id'] = this.share_id;
        data['sharenum'] = this.sharenum;
        data['title'] = this.title;
        data['titlepic'] = this.titlepic;
        data['type'] = this.type;
        data['user_id'] = this.user_id;
        if (this.images != null) {
            data['images'] = this.images.map((v) => v.toJson()).toList();
        }
//        if (this.share != null) {
//            data['share'] = this.share.toJson();
//        }
//        if (this.support != null) {
//            data['support'] = this.support.map((v) => v.toJson()).toList();
//        }
        if (this.user != null) {
            data['user'] = this.user.toJson();
        }
        return data;
    }
}