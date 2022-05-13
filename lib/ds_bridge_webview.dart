library ds_bridge_webview;

import 'dart:convert';

class DsBridge {
  dynamic webViewController;
  String callBackCode = '';
  DsBridge(this.webViewController);

  Result dispatch (String jsonStr) {
    Map jsonData = jsonDecode(jsonStr);
    String method = jsonData['method'];
    String data = jsonData['data'];
    callBackCode = jsonData['callBack'];
    final result = Result();
    result.method = method;
    result.data = data;
    result.callBack = callBack;
    return result;
  }

  void callBack (String params) {
    String code = "$callBackCode('$params')";
    webViewController.runJavascript(code);
  }

}

class Result {
  String method = '';
  String data = '';
  late Function callBack;
}
