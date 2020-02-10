/*
 * @author jingsong.chen, QQ:77132995, email:kazeik@163.com
 * 2020-02-09 16:53
 * 类说明:
 */

import 'package:flutter/material.dart';
import 'package:fluttertest/view/LoadingDialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils{
  static bool isDebug = true;
  static dynamic mContext;

  static String getImgPath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }

  static logs(String msg) {
    if (isDebug) {
      print(msg);
    }
  }

  static showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey.shade300,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  static loading(BuildContext context, {String text}) {
    String _text = '数据加载中...';
    if (text != null && text != "") {
      _text = text;
    }
    showDialog<Null>(
        context: context, //BuildContext对象
        barrierDismissible: false,
        builder: (BuildContext _context) {
          return new LoadingDialog(
            //调用对话框
            text: _text,
          );
        });
  }

}