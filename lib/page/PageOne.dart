/*
 * @author jingsong.chen, QQ:77132995, email:kazeik@163.com
 * 2020-02-09 16:15
 * 类说明:
 */

import 'package:flutter/material.dart';
import 'package:fluttertest/model/ImageModel.dart';
import 'package:fluttertest/model/NewsListItemModel.dart';
import 'package:fluttertest/model/NewsModel.dart';
import 'package:fluttertest/model/TabsModel.dart';
import 'package:fluttertest/net/HttpNet.dart';
import 'package:fluttertest/utils/ApiUtils.dart';
import 'package:fluttertest/utils/MethodTyps.dart';
import 'package:fluttertest/utils/Utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PageOne extends StatefulWidget {
  State<StatefulWidget> createState() => new _PageOneState();
}

class _PageOneState extends State<PageOne> with SingleTickerProviderStateMixin {
  TabController _mController;
  List<Tab> _tabList = new List();
  TabsModel _model;
  int _pageIndex = 1;
  int _tabId;
  bool pullUp = true;

  List<NewsListItemModel> allData = new List();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _getTabs();
  }

  @override
  void dispose() {
    super.dispose();
    _mController.dispose();
  }

  _getTabs() {
    HttpNet().request(MethodTypes.GET, ApiUtils.getTabs, (str) {
      _model = TabsModel.fromJson(str);
      _tabList.clear();
      _model.data.list.forEach((item) {
        _tabList.add(new Tab(text: item.classname));
      });
      _mController = TabController(
        length: _tabList.length,
        vsync: this,
      );
      _tabId = _model?.data?.list[0].id;
      _mController.addListener((){
        _tabId = _model?.data?.list[_mController.index].id;
        _getListData(clear: true);
      });
      _reflashWidget();
      _getListData();
    });
  }

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
      body: new Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(bottom: 5, top: 5),
            height: 45,
            child: _buildTabs(),
          ),
          Expanded(
            child: _buildView(),
          )
        ],
      ),
    );
  }

  Widget _buildView() {
    if (_tabList.isNotEmpty) {
      return TabBarView(
        controller: _mController,
        children: _tabList.map((item) {
          return SmartRefresher(
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
                itemCount: allData.length, itemBuilder: _buildItemList),
          );
        }).toList(),
      );
    } else {
      return new Container();
    }
  }

  void _onRefresh() async {
    _pageIndex = 1;
    _getListData(clear: true);
  }

  void _onLoading() async {
    _pageIndex++;
    _getListData();
  }

  _getListData({bool clear = false}) {
    HttpNet().request(
        MethodTypes.GET, "${ApiUtils.getTabs}/$_tabId/post/$_pageIndex", (str) {
      NewsModel model = NewsModel.fromJson(str);
      if (clear) {
        allData.clear();
      }
      if (model.data == null ||
          model.data.list == null ||
          model.data.list.isEmpty) {
        pullUp = false;
        Utils.showToast("没有更多数据了");
      } else {
        allData.addAll(model.data.list);
      }
      _reflashWidget();
      _refreshController.refreshCompleted();
      _refreshController.loadComplete();
    });
  }

  Widget _buildTabs() {
    if (_tabList != null && _tabList.isNotEmpty) {
      return new TabBar(
        isScrollable: true,
        indicatorWeight: 5.0,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Color(0xfff9e243),
        controller: _mController,
        labelColor: Colors.black,
        unselectedLabelColor: Color(0xff9c9c9c),
        tabs: _tabList.map((item) {
          return Tab(
            text: item.text,
          );
        }).toList(),
        onTap: (index) {
          _tabId = _model?.data?.list[index].id;
          _pageIndex = 1;
          pullUp = true;
          _getListData(clear: true);
        },
      );
    } else {
      return new Container();
    }
  }

  _reflashWidget() {
    if (mounted) setState(() {});
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
                image: new NetworkImage(allData[index].user?.userpic),
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

  String _getTime(int time) {
    var daynow = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    Duration chaf = DateTime.now().difference(daynow);
    if (chaf.inDays != 0) {
      if (chaf.inDays > 30) {
        return "${daynow.year}-${daynow.month}-${daynow.day}";
      } else
        return "${chaf.inDays}天前";
    } else if (chaf.inHours != 0) {
      return "${chaf.inHours}时前";
    } else if (chaf.inMinutes != 0) {
      return "${chaf.inMinutes}分前";
    } else if (chaf.inSeconds != 0) {
      return "${chaf.inSeconds}刚刚";
    }
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
      return new Container(
        width: double.infinity,
        height: 200,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new NetworkImage(allImgs[0]?.url),
          ),
        ),
      );
    } else if (length == 0) {
      return new Container();
    } else {
      return _buidGridView(allImgs);
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
          image: new NetworkImage(imgs[index].url),
          fit: BoxFit.fill,
        );
      },
    );
  }
}
