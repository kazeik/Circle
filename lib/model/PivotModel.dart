
class PivotModel {
    int create_time;
    int id;
    int image_id;
    int post_id;

    PivotModel({this.create_time, this.id, this.image_id, this.post_id});

    factory PivotModel.fromJson(Map<String, dynamic> json) {
        return PivotModel(
            create_time: json['create_time'], 
            id: json['id'], 
            image_id: json['image_id'], 
            post_id: json['post_id'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['create_time'] = this.create_time;
        data['id'] = this.id;
        data['image_id'] = this.image_id;
        data['post_id'] = this.post_id;
        return data;
    }
}