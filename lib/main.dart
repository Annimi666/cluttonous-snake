import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_flutter/register.dart';
import 'package:test_flutter/startplay.dart';
import 'package:test_flutter/variable.dart';


void main() {
  runApp(const MaterialApp(
    title: 'Login',
    home: LoginPage(),
  ));
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyLoginPage(title: ''),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController userpwdController = TextEditingController();
  String errorAccount = '';
  String errorPwd = '';
  String username = '';
  String userpwd = '';
  OutlineInputBorder outlineInputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.black12, width: 2));
  OutlineInputBorder focuslineInputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.orangeAccent, width: 2));
  FocusNode _focusNode = FocusNode();
  FocusNode focusNode1 = FocusNode();

  @override
  void initState() {
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        //失去焦点
        username = usernameController.text;
        print(username);
        setState(() {
          //判断用户名是否正确
          if (username.length>12) {
            errorAccount = '用户名不得超过12个字符';
          }
        });
      } else {
        setState(() {
          errorAccount = '';
        });
      }
    });
    focusNode1.addListener(() {
      if (!focusNode1.hasFocus) {
        //失去焦点
        userpwd = userpwdController.text;
        print(userpwd);
        setState(() {
          if (userpwd.length > 8) {
            errorPwd = '密码不得超过8个字符';
          }
        });
      } else {
        setState(() {
          errorPwd = '';
        });
      }
    });

  }
  void showInfo() {
    String msg = '登录成功';
    var uname = usernameController.text;
    var upwd = userpwdController.text;
    if (uname.isEmpty || upwd.isEmpty) {
      msg = '用户名或密码不能为空！';
      Global.flag = 0;
    } else if (uname != 'admin' || upwd != '123456') {
      msg = '用户名或密码错误';
      Global.flag = 0;
    }
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        fontSize: 16,
        textColor: Colors.cyanAccent);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("欢迎来到贪吃蛇"),
      ),
      body: Column(
        children: <Widget>[
          const Text(
            '登录',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 5),
          ),
          TextField(
            focusNode: _focusNode,
            controller: usernameController,
            decoration: InputDecoration(
              counterText: errorAccount,
              counterStyle: const TextStyle(color: Colors.red, fontSize: 15),
              icon: const Icon(Icons.person),
              hintText: '请输入账号',
              enabledBorder: outlineInputBorder,
              focusedBorder: focuslineInputBorder,
            ),
          ),
          TextField(
            obscureText: true,
            focusNode: focusNode1,
            controller: userpwdController,
            decoration: InputDecoration(
              counterText: errorPwd,
              counterStyle: const TextStyle(color: Colors.red, fontSize: 15),
              icon: const Icon(Icons.lock_open),
              hintText: '请输入密码',
              enabledBorder: outlineInputBorder,
              focusedBorder: focuslineInputBorder,
            ),
          ),
          RaisedButton(
            child: const Text('登 录'),
            onPressed: () {
              showInfo;
              print(Global.flag);
              if (Global.flag == 0) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GamePage()));
              }
            },
            color: Colors.blueGrey,
          ),
          buildRegisterText(context),
        ],
      ),
    );
  }
//
  Align buildRegisterText(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('没有账号？'),
            GestureDetector(
              child: const Text(
                '点击注册',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                _toRegisterPage(context);//跳转注册页面方法。
              },
            ),
          ],
        ),
      ),
    );
  }

  _toRegisterPage(BuildContext context) async{
    final preusername = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const RegisterPage()));
    username=Text("$preusername").data!;//接收传递的参数
    username = username.substring(1,username.length-1);//处理为已注册的用户邮箱
  }
}
