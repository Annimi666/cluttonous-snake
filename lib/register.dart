import 'package:flutter/material.dart';

import 'main.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyRegisterPage(),
    );
  }
}

class MyRegisterPage extends StatefulWidget {
  const MyRegisterPage({Key? key}) : super(key: key);

  @override
  _MyRegisterPageState createState() => _MyRegisterPageState();
}

class _MyRegisterPageState extends State<MyRegisterPage> {
  OutlineInputBorder outlineInputBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black12, width: 2));
  OutlineInputBorder focuslintInputBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.amberAccent, width: 2));
  TextStyle counttextStyle =
      const TextStyle(color: Colors.red, fontSize: 10, height: 0.6);
  bool checked = true;
  RichText? richText;
  TextEditingController controller = TextEditingController();
  DateTime initialDate = DateTime.now();
  DateTime firstDate = DateTime(1900, 10, 1);
  DateTime lastDate = DateTime(2200, 10, 1);
  DateTime birthday = DateTime.now();
  @override
  void initState() {
    controller.text = birthday.toString().substring(0, 10);
  }

  Future selectDate(context) async {
    DateTime? b = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate);
    controller.text = b.toString().substring(0, 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(5, 15, 10, 10),
          child: Column(
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 11,
                decoration: InputDecoration(
                    counterText: '手机号只有11位',
                    counterStyle: counttextStyle,
                    enabledBorder: outlineInputBorder,
                    focusedBorder: focuslintInputBorder,
                    prefixIcon: const Icon(Icons.phone_iphone),
                    contentPadding: const EdgeInsets.symmetric(vertical: 1),
                    hintText: '手机号'),
              ),
              TextField(
                maxLength: 20,
                decoration: InputDecoration(
                    counterText: '姓名只能是2~20个字符',
                    counterStyle: counttextStyle,
                    enabledBorder: outlineInputBorder,
                    focusedBorder: focuslintInputBorder,
                    prefixIcon: const Icon(Icons.person),
                    contentPadding: const EdgeInsets.symmetric(vertical: 1),
                    hintText: '姓名'),
              ),
              TextField(
                obscureText: true,
                maxLength: 8,
                decoration: InputDecoration(
                    counterText: '密码长度为8个字符',
                    counterStyle: counttextStyle,
                    enabledBorder: outlineInputBorder,
                    focusedBorder: focuslintInputBorder,
                    prefixIcon: const Icon(Icons.lock),
                    contentPadding: const EdgeInsets.symmetric(vertical: 1),
                    hintText: '密码'),
              ),
              TextField(
                controller: controller,
                maxLength: 10,
                decoration: InputDecoration(
                    counterText: '出生日期不超过10个字符',
                    counterStyle: counttextStyle,
                    enabledBorder: outlineInputBorder,
                    focusedBorder: focuslintInputBorder,
                    prefixIcon: const Icon(Icons.cake),
                    contentPadding: const EdgeInsets.symmetric(vertical: 1),
                    hintText: '出生日期'),
                onTap: () {
                  selectDate(context);
                },
              ),
              CheckboxListTile(
                value: checked,
                title: const Text('同意'),
                subtitle: const Text('同意表示您已经阅读协议条款'),
                secondary: const Icon(Icons.info),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.amber,
                onChanged: (value) {
                  setState(() {
                    checked = value!;
                    if (checked) {
                      richText = RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                            text: '协议内容',
                            style: TextStyle(color: Colors.red),
                            children: [
                              TextSpan(
                                text: '\n内容内容内容内容内容内容\n内容内容内容内容内容内容',
                                style: TextStyle(color: Colors.blue),
                              )
                            ]),
                      );
                    } else {
                      richText = null;
                    }
                  });
                },
              ),
              TextField(
                maxLength: 10,
                decoration: InputDecoration(
                    enabledBorder: outlineInputBorder,
                    focusedBorder: focuslintInputBorder,
                    prefixIcon: const Icon(Icons.settings_overscan),
                    contentPadding: const EdgeInsets.symmetric(vertical: 1),
                    hintText: '验证码',
                    suffixIcon: OutlineButton(
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                      onPressed: () {
                        print('执行发送短信到手机');
                      },
                      child: const Text('获取验证码'),
                    )),
              ),
              FlatButton(
                color: Colors.red,
                child: Container(
                  alignment: Alignment.center,
                  child: const Text('注    册'),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                },
              ),
              Container(
                child: richText,
              )
            ],
          )),
    );
  }
}
