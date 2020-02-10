
class TabsListItem {
    String classname;
    int id;

    TabsListItem({this.classname, this.id});

    factory TabsListItem.fromJson(Map<String, dynamic> json) {
        return TabsListItem(
            classname: json['classname'], 
            id: json['id'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['classname'] = this.classname;
        data['id'] = this.id;
        return data;
    }
}