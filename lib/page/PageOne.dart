/*
 * @author jingsong.chen, QQ:77132995, email:kazeik@163.com
 * 2020-02-09 16:15
 * 类说明:
 */

import 'package:flutter/material.dart';
import 'package:fluttertest/model/TabsListItem.dart';
import 'package:fluttertest/model/TabsModel.dart';
import 'package:fluttertest/net/HttpNet.dart';
import 'package:fluttertest/utils/ApiUtils.dart';
import 'package:fluttertest/utils/MethodTyps.dart';
import 'package:fluttertest/utils/Utils.dart';
import 'package:fluttertest/weight/TabViewList.dart';

class PageOne extends StatefulWidget {
  State<StatefulWidget> createState() => new _PageOneState();
}

class _PageOneState extends State<PageOne> with TickerProviderStateMixin {
  TabController _mController;
  List<TabsListItem> _tabList = new List();

  @override
  void initState() {
    super.initState();
    _mController = new TabController(length: 0, vsync: this);
    _getTabs();
  }

  @override
  void dispose() {
    super.dispose();
    _mController.dispose();
  }

  _getTabs() {
    HttpNet().request(MethodTypes.GET, ApiUtils.getTabs).then((value) {
      TabsModel _model = TabsModel.fromJson(value);

      _mController = TabController(
        length: _model.data.list.length,
        vsync: this,
      );
      setState(() {
        _tabList = _model.data.list;
      });
//      _mController.addListener(() {
//        Utils.logs("_contentIndex = ${_mController.index}");
//        setState(() {
//          _tabId = _model?.data?.list[_mController.index].id;
//        });
//      });
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
            child: TabBarView(
              controller: _mController,
              children: _tabList.map((TabsListItem item) {
                Utils.logs("tabId = $item");
                return TabViewList(
                  tabId: item.id,
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTabs() {
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
            text: item.classname,
          );
        }).toList());
  }
}
