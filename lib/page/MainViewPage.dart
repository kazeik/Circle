/*
 * @author jingsong.chen, QQ:77132995, email:kazeik@163.com
 * 2019-11-08 11:18
 * 类说明:
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/page/PageOne.dart';
import 'package:fluttertest/page/PageThree.dart';
import 'package:fluttertest/page/PageTwo.dart';
import 'package:fluttertest/page/UserViewPage.dart';
import 'package:fluttertest/utils/Utils.dart';

class MainPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  int _tabIndex = 0;
  var tabImages;
  var appBarTitles = ['首页', '动态','小纸条','我的'];
  var _bodys;

  /*
   * 根据image路径获取图片
   */
  Image getTabImage(path) {
    return new Image.asset(path, width: 30.0, height: 30.0);
  }

  /*
   * 获取bottomTab的颜色和文字
   */
  Text getTabTitle(int curIndex) {
    return new Text(appBarTitles[curIndex],
        style: new TextStyle(
            color:
                curIndex == _tabIndex ? const Color(0xff40b197) : Colors.grey));
  }

  /*
   * 根据索引获得对应的normal或是press的icon
   */
  Image getTabIcon(int curIndex) {
    return tabImages[curIndex][curIndex == _tabIndex ? 0 : 1];
  }

  void initData() {
    /*
      bottom的按压图片
     */
    tabImages = [
      [
        getTabImage(Utils.getImgPath("tabbar_icon_1")),
        getTabImage(Utils.getImgPath("tabbar_icon_3"))
      ],
      [
        getTabImage(Utils.getImgPath("tabbar_icon_4")),
        getTabImage(Utils.getImgPath("tabbar_icon_2"))
      ],
      [
        getTabImage(Utils.getImgPath("tabbar_icon_1")),
        getTabImage(Utils.getImgPath("tabbar_icon_3"))
      ],
      [
        getTabImage(Utils.getImgPath("tabbar_icon_4")),
        getTabImage(Utils.getImgPath("tabbar_icon_2"))
      ]
    ];

    _bodys = [
      new PageOne(),
      new PageTwo(),
      new PageThree(),
      new UserViewPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Utils.mContext = context;
    initData();
    return new Scaffold(
//      body: _bodys[_tabIndex],
      body: new IndexedStack(
        index: _tabIndex,
        children: _bodys,
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
              icon: getTabIcon(0), title: getTabTitle(0)),
          new BottomNavigationBarItem(
              icon: getTabIcon(1), title: getTabTitle(1)),
          new BottomNavigationBarItem(
              icon: getTabIcon(2), title: getTabTitle(2)),
          new BottomNavigationBarItem(
              icon: getTabIcon(3), title: getTabTitle(3)),
        ],
        selectedFontSize: 12,
        //设置显示的模式
        type: BottomNavigationBarType.fixed,
        //设置当前的索引
        currentIndex: _tabIndex,
        //tabBottom的点击监听
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
      ),
    );
  }
}
