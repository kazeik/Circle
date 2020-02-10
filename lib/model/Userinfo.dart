
class Userinfo {
    int age;
    String birthday;
    Object create_time;
    int id;
    String job;
    String path;
    int qg;
    int sex;
    int user_id;

    Userinfo({this.age, this.birthday, this.create_time, this.id, this.job, this.path, this.qg, this.sex, this.user_id});

    factory Userinfo.fromJson(Map<String, dynamic> json) {
        return Userinfo(
            age: json['age'], 
            birthday: json['birthday'], 
//            create_time: json['create_time'] != null json['create_time'] : null,
            id: json['id'], 
            job: json['job'], 
            path: json['path'], 
            qg: json['qg'], 
            sex: json['sex'], 
            user_id: json['user_id'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['age'] = this.age;
        data['birthday'] = this.birthday;
        data['id'] = this.id;
        data['job'] = this.job;
        data['path'] = this.path;
        data['qg'] = this.qg;
        data['sex'] = this.sex;
        data['user_id'] = this.user_id;
//        if (this.create_time != null) {
//            data['create_time'] = this.create_time.toJson();
//        }
        return data;
    }
}