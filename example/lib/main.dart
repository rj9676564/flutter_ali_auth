import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ali_auth/ali_auth.dart';
import 'package:flutter/services.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// 初始化插件
  /// 在使用参数时isDialog，请参照默认配置进行所需修改，否则可能出现相关问题
  /// 两个配置文件分别是全屏以及弹窗的配置参数
  /// 详情请点击进入查看具体配置
  if (Platform.isAndroid) {
    AliAuthPlugin.initSdk(
      sk: 'sEVsVZ8CktqNCF7jINJYgOtqOt5s7nvVyFdTecBAqlrWeX04BJyszV0rIGKEFyO8Rs5SRBjoYhCJtQZSaNFVsDZhQWGqP3tThoJasRk/+Eub2P6hQs7P7fjl3yfIxTgWLPbTN8sY8tnNan46qI2Rzg9LD7Yr+v5Nt12or5n2VNeQpAAsa9Z/taEMjz5Xithh5DkQGbIIpsCfG3EaseWnXJF+HPZ0J0kO6G7iXTuVNqNBcbtxhtkRO8bZB0tyPzJIl7idMWg+rdLA+z37RPlnVjJSpyZHakWPkwG47hNLaBvodczLWaoE6cVEyBuxIGlBnIbdTqG4/Sw=',
      config: getConfig(),
    );
  } else {
    AliAuthPlugin.initSdk(
      sk: 'QoIQ+5dWhzrstP5HU17qnX8bcKIJYIeTYLG3jFbjoIBt1NMiwS6pTnKoHI20C4X8nhchaSmPhgCxKfLmSG6BHu6QD/5VarfUuSH1g0wu5BPn0uqTgqb7FJF96z/84w1Rou5UejHtkeXjgcdJa1RKEfK16S88QkNswONgqVfDjgFe1Zg6seMDUAbxVc3kIQeEdJ16Ml/ngCRveLtWuswOxZtmiCykKUEWq+bH/4IZ0jv21I1BOdxdU9GDM9RkMh3zjynV1JWTe5U=',
      config: getDislogConfig(),
    );
  }

  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );

  SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BuildContext mContext;
  Timer countdownTimer;

  @override
  void initState() {
    super.initState();

    /// 执行相关登录
    login();
  }

  /// 相关登录
  login() async {
    /// 登录监听
    AliAuthPlugin.loginListen(
        type: false, onEvent: _onEvent, onError: _onError);
  }

  /// 登录成功处理
  void _onEvent(event) async {
    print("-------------成功分割线-111-----------$event");
    if (event != null && event['code'] != null) {
      if (event['code'] == '600024') {
        await AliAuthPlugin.login;
      } else if (event['code'] == '600000') {
        print('获取到的token${event["data"]}');
      }
    }
  }

  /// 登录错误处理
  void _onError(error) {
    print("-------------失败分割线------------$error");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('阿里云一键登录插件'),
        ),
        body: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                final result = await AliAuthPlugin.login;
                print(result);
              },
              child: Text('直接登录'),
            ),
            Platform.isIOS
                ? ElevatedButton(
                    onPressed: () async {
                      await AliAuthPlugin.appleLogin;
                    },
                    child: Text('apple登录'),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
