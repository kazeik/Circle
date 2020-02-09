/*
 * @author jingsong.chen, QQ:77132995, email:kazeik@163.com
 * 2020-02-09 16:15
 * 类说明:
 */

import 'package:flutter/material.dart';
import 'package:fluttertest/utils/Utils.dart';

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Icon(Icons.dehaze),
              new Text("News Feed"),
              new Icon(Icons.search),
            ],
          ),
          centerTitle: true,
          backgroundColor: const Color(0xff2e324e)),
      body: new ListView.builder(itemCount: 10, itemBuilder: _buildItemList),
    );
  }

  Widget _buildItemList(BuildContext context, int index) {
    return new Container(
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          new ListTile(
            leading: new ClipOval(
              child: new Image(
                width: 45,
                height: 45,
                image: new AssetImage(Utils.getImgPath("header_img")),
              ),
            ),
            title: new Text(
              "Johnie Cornwall",
              style: new TextStyle(
                  fontSize: 16,
                  color: const Color(0xff6f6f6f),
                  fontWeight: FontWeight.bold),
            ),
            subtitle: new Text(
              "8 mins",
              style: new TextStyle(color: Colors.black38, fontSize: 12),
            ),
            trailing: new Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              alignment: Alignment.center,
              height: 25,
              width: 80,
              decoration: new BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(14.0)),
                border: new Border.all(width: 1, color: Colors.teal),
              ),
              child: new Text(
                "测试",
                style: new TextStyle(color: Colors.white),
              ),
            ),
          ),
          new Container(
            margin: EdgeInsets.all(15),
            child: new Text(
                "这是一段长长的文本，用于测试用例，至于界面布局成什么情况，我暂时不清楚，先以文字图片作为占位符再说。看看具体的效果，如果的话就如此显示了"),
          ),
          _buildImgItem(index),
          new Divider(
            indent: 10,
            endIndent: 10,
          ),
          new Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _buildRowItem(),
            ),
          ),
          new Container(
            height: 15,
            color: Colors.black12,
          )
        ],
      ),
    );
  }

  List<Widget> _buildRowItem() {
    List<Widget> all = new List();
    all.add(new Row(
      children: <Widget>[
        new Icon(Icons.apps),
        new Padding(
          padding: EdgeInsets.only(left: 10),
          child: new Text("Like"),
        )
      ],
    ));
    all.add(new Row(
      children: <Widget>[
        new Icon(Icons.comment),
        new Padding(
          padding: EdgeInsets.only(left: 10),
          child: new Text("Comment"),
        )
      ],
    ));
    all.add(new Row(
      children: <Widget>[
        new Icon(Icons.share),
        new Padding(
          padding: EdgeInsets.only(left: 10),
          child: new Text("Share"),
        )
      ],
    ));
    return all;
  }

  // ignore: missing_return
  Widget _buildImgItem(int index) {
    int temp = index % 4;
    print("当前索引 ：$temp");
    switch (temp) {
      case 0:
        return new Container(
          width: double.infinity,
          height: 200,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: AssetImage(
                Utils.getImgPath("test"),
              ),
            ),
          ),
        );
        break;
      case 1:
        return _buidGridView(2);
        break;
      case 2:
        return _buidGridView(3);
        break;
      case 3:
        return _buidGridView(4);
        break;
    }
  }

  Widget _buidGridView(int index) {
    return new GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10.0,
      crossAxisCount: index <= 3 ? index : 3,
      childAspectRatio: 2.0,
      children: _getWidgetList(index),
    );
  }

  List<Widget> _getWidgetList(int index) {
    List<Widget> imgs = new List();
    for (int i = 0; i < index; i++) {
      imgs.add(
        new Image(
          image: new AssetImage(
            Utils.getImgPath("test"),
          ),
        ),
      );
    }
    return imgs;
  }
}
