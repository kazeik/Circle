/*
 * @author jingsong.chen, QQ:77132995, email:kazeik@163.com
 * 2020-02-09 16:15
 * 类说明:
 */

import 'package:flutter/material.dart';
import 'package:fluttertest/model/TabsModel.dart';
import 'package:fluttertest/net/HttpNet.dart';
import 'package:fluttertest/utils/ApiUtils.dart';
import 'package:fluttertest/utils/MethodTyps.dart';
import 'package:fluttertest/weight/TabViewList.dart';

class PageOne extends StatefulWidget {
  State<StatefulWidget> createState() => new _PageOneState();
}

class _PageOneState extends State<PageOne> with TickerProviderStateMixin {
  TabController _mController;
  List<Tab> _tabList = new List();
  TabsModel _model;

  int _tabId;

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
    HttpNet().request(MethodTypes.GET, ApiUtils.getTabs, (str) {
      _model = TabsModel.fromJson(str);
      _model.data.list.forEach((item) {
        _tabList.add(new Tab(text: item.classname));
      });
      _mController = TabController(
        initialIndex: 0,
        length: _tabList.length,
        vsync: this,
      );
      _tabId = _model?.data?.list[0].id;
      _mController.addListener(() {
        _tabId = _model?.data?.list[_mController.index].id;
        _reflashWidget();
      });
      _reflashWidget();
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
    if (_tabList == null || _tabList.isEmpty) {
      return new Container();
    } else {
      return TabBarView(
        controller: _mController,
        children: _tabList.map((item) {
          return TabViewList(
            tabId: _tabId,
          );
        }).toList(),
      );
    }
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
        },
      );
    } else {
      return new Container();
    }
  }

  _reflashWidget() {
    if (mounted) setState(() {});
  }
}
