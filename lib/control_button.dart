import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final void Function() onPressed;//修改
  final Icon icon;
  const ControlButton({Key? key, required this.onPressed, required this.icon})
      : super(key: key);
//定义按钮的各项属性
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Container(
        width: 80.0,
        height: 80.0,
        child: FittedBox(
          //设置圆形按钮
          child: FloatingActionButton(
            backgroundColor: Colors.green,
            elevation: 0.0,
            onPressed: onPressed,
            child: icon,
          ),
        ),
      ),
    );
  }
}
