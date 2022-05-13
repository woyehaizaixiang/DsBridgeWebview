# ds_bridge

A new Flutter package project.

## 说明
此包是[webview_flutter](https://pub.flutter-io.cn/packages/webview_flutter)webview与网页交互的工具包


## 配置依赖包
```
dependencies:
  ds_bridge_webview: ^0.0.1
```

## 例子
在webview页面添加JavascriptChannel
webview.dart
```
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../routes/application.dart';
import '../../utils/JsBridgeUtil.dart';

class WebviewPage extends StatefulWidget {
  final String url;
  final VoidCallback backCallback;

  WebviewPage({
    Key key,
    @required this.url,
    this.backCallback,
  }) : super(key: key);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  String _title = 'ds_bridge';
  WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(const IconData(0xe61b, fontFamily: 'IconFont'), color: Color(0xff333333), size: 18),
          onPressed: () => Application.router.pop(context),
        ),
        title: new Text(
          '$_title',
          style: TextStyle(color: Color(0xff333333), fontSize: 17),
        ),
        backgroundColor: Color(0xffffffff),
        shadowColor: Colors.transparent,
        centerTitle: true,
        actions: [
          FutureBuilder<WebViewController>(
            builder: (BuildContext context, AsyncSnapshot<WebViewController> controller) {
              return IconButton(
                onPressed: () {
                  reloadWebView();
                },
                icon: new Icon(
                  Icons.refresh_outlined,
                  color: Color(0xff333333),
                  size: 20
                )
              );
            }
          ),
        ],
      ),
      body: WebView(
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: <JavascriptChannel>{
          _javascriptChannel(context),
          _javascriptChannel2(context),
        },
        onPageStarted: (String url) {
          if (url.startsWith("mailto") || url.startsWith("tel") || url.startsWith("http") || url.startsWith("https")) {
          } else {
            _webViewController.goBack();
          }
        },
        onPageFinished: (controller) {
          // 获取页面标题
          setState(() {
            _title = _webViewController.getTitle() as String;
          });
        },
      )
    );
  }
  // js桥通道
  JavascriptChannel _javascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'DsBridgeApp',
        onMessageReceived: (JavascriptMessage message) {
          String jsonStr = message.message;
          JsBridgeUtil.executeMethod(_webViewController, jsonStr);
        });
  }
  // js alert通道
  JavascriptChannel _javascriptChannel2(BuildContext context) {
    return JavascriptChannel(
        name: 'Alert',
        onMessageReceived: (JavascriptMessage message) {
          String jsonStr = message.message;
          _showMyDialog(context, jsonStr);
        });
  }
  void reloadWebView() {
    _webViewController?.reload();
  }
}
```

在JsBridgeUtil类中
utils/JsBridgeUtil.dart
```
import 'package:ds_bridge/ds_bridge.dart';
class JsBridgeUtil {
  // 向H5调用接口
  static executeMethod(flutterWebViewPlugin, String jsonStr) async{
    DsBridge dsBridge = DsBridge(flutterWebViewPlugin);
    Result result = dsBridge.dispatch(jsonStr);
    if(result.method == 'share'){
      result.callBack('收到网页端share事件，内容为${result.data}并返回此文本给网页');
    }
    if(result.method == 'share1'){
      result.callBack('收到网页端share1事件');
    }
  }
}
```

## 其他
网页端对应使用[dsbridge_flutter](https://github.com/woyehaizaixiang/dsbridge_flutter)