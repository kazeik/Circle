/*
 * @author jingsong.chen, QQ:77132995, email:kazeik@163.com
 * 2020-02-09 16:53
 * 类说明:
 */

class Utils{
  static String getImgPath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }
}