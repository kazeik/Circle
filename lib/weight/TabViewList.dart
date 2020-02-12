/*
 * @author jingsong.chen, QQ:77132995, email:kazeik@163.com
 * 2020-02-11 16:09
 * 类说明:
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/model/ImageModel.dart';
import 'package:fluttertest/model/NewsListItemModel.dart';
import 'package:fluttertest/model/NewsModel.dart';
import 'package:fluttertest/net/HttpNet.dart';
import 'package:fluttertest/utils/ApiUtils.dart';
import 'package:fluttertest/utils/MethodTyps.dart';
import 'package:fluttertest/utils/Utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TabViewList extends StatefulWidget {
  int tabId;

  TabViewList({Key key, this.tabId}) : super(key: key);

  @override
  State<TabViewList> createState() => _TabViewListState();
}

class _TabViewListState extends State<TabViewList>
    with AutomaticKeepAliveClientMixin {
  bool pullUp = true;
  int _pageIndex = 1;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<NewsListItemModel> allData = new List();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: pullUp,
        header: ClassicHeader(
            refreshingText: "重新加载数据中",
            releaseText: "松开时重新加载数据",
            completeText: "数据加载完成",
            idleText: "下拉加载新数据"),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: new ListView.builder(
            itemCount: allData?.length ?? 0, itemBuilder: _buildItemList),
      ),
    );
  }

  void _onRefresh() async {
    _pageIndex = 1;
    _getListData(clear: true);
  }

  void _onLoading() async {
    _pageIndex++;
    _getListData();
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
                image: new CachedNetworkImageProvider(allData[index].user?.userpic),
                fit: BoxFit.cover,
              ),
            ),
            title: new Text(
              "${allData[index].user?.realname}",
              style: new TextStyle(
                  fontSize: 16,
                  color: const Color(0xff6f6f6f),
                  fontWeight: FontWeight.bold),
            ),
            subtitle: new Text(
              "${_getTime(allData[index]?.create_time)}",
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
            alignment: Alignment.centerLeft,
            child: new Text("${allData[index]?.content}"),
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
              children: _buildRowItem(index),
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

  @override
  void initState() {
    super.initState();
    _getListData(clear: true);
  }

  List<Widget> _buildRowItem(int index) {
    List<Widget> all = new List();
    all.add(new Row(
      children: <Widget>[
        new Icon(Icons.apps),
        new Padding(
          padding: EdgeInsets.only(left: 5),
          child: new Text("${allData[index]?.ding_count} Like"),
        )
      ],
    ));
    all.add(new Row(
      children: <Widget>[
        new Icon(Icons.comment),
        new Padding(
          padding: EdgeInsets.only(left: 5),
          child: new Text("${allData[index]?.comment_count} Comment"),
        )
      ],
    ));
    all.add(new Row(
      children: <Widget>[
        new Icon(Icons.share),
        new Padding(
          padding: EdgeInsets.only(left: 5),
          child: new Text("${allData[index]?.share_id} Share"),
        )
      ],
    ));
    return all;
  }

  // ignore: missing_return
  Widget _buildImgItem(int index) {
    List<ImageModel> allImgs = allData[index]?.images;
    var length = allImgs?.length;
    if (length == 1) {
      return new CachedNetworkImage(
        imageUrl: allImgs[0]?.url,
        width: double.infinity,
        height: 200,
      );
//      return new Container(
//        width: double.infinity,
//        height: 200,
//        decoration: new BoxDecoration(
//          image: new DecorationImage(
//            image: new CachedNetworkImage(allImgs[0]?.url),
//          ),
//        ),
//      );
    } else if (length == 0) {
      return new Container();
    } else {
      return _buidGridView(allImgs);
    }
  }

  String _getTime(int time) {
    var daynow = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    Duration chaf = DateTime.now().difference(daynow);
    if (chaf.inDays != 0) {
      if (chaf.inDays > 30) {
        return "${daynow.year}-${daynow.month}-${daynow.day}";
      } else
        return "${chaf.inDays}天前";
    } else if (chaf.inHours != 0) {
      return "${chaf.inHours}小时前";
    } else if (chaf.inMinutes != 0) {
      return "${chaf.inMinutes}分钟前";
    } else if (chaf.inSeconds != 0) {
      return "${chaf.inSeconds}刚刚";
    } else {
      return "";
    }
  }

  Widget _buidGridView(List<ImageModel> imgs) {
    return new GridView.builder(
      shrinkWrap: true,
      itemCount: imgs.length,
      padding: EdgeInsets.all(5.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        crossAxisCount: imgs.length <= 3 ? imgs.length : 3,
        childAspectRatio: 1.0,
      ),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return new Image(
          image: new CachedNetworkImageProvider(imgs[index].url),
          fit: BoxFit.fill,
        );
      },
    );
  }

  _getListData({bool clear = false}) {
    HttpNet()
        .request(MethodTypes.GET,
            "${ApiUtils.getTabs}/${widget.tabId}/post/$_pageIndex")
        .then((value) {
      if (clear) {
        allData.clear();
      }
      NewsModel model = NewsModel.fromJson(value);
      if (model.data == null ||
          model.data.list == null ||
          model.data.list.isEmpty) {
        pullUp = false;
        Utils.showToast("没有更多数据了");
      } else {
        allData.addAll(model.data.list);
        pullUp = true;
      }
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
      if (mounted) setState(() {});
    });
  }
}
