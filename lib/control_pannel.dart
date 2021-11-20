import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter/direction.dart';

import 'control_button.dart';
//控制面板（重力传感器）的定义
class ControlPannel extends StatelessWidget {
  final void Function(Direction direction) onTapped;
  const ControlPannel({ Key? key,required this.onTapped}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0.0,
        right: 0.0,
        bottom: 50.0,
        child:  Row(
      children: [
        Expanded(
            child: Row(
          children: [
            Expanded(child: Container()),
            ControlButton(
              onPressed:(){
                onTapped(Direction.left);
              },
              icon:const Icon(Icons.arrow_left),
            )
          ],
        )),
        Expanded(child: Column(
          children: [
            ControlButton(
                onPressed:(){
                  onTapped(Direction.up);
                },
                icon: const Icon(Icons.arrow_drop_up),
            ),
            const SizedBox(
              height: 70,
            ),

            ControlButton(
              onPressed:(){
                onTapped(Direction.down);
              },
              icon: const Icon(Icons.arrow_drop_down),
            ),
          ],
        )),
        Expanded(child: Row(
          children: [
            Expanded(child: Container()),
            ControlButton(
              onPressed:(){
                onTapped(Direction.right);
              },
              icon:const Icon(Icons.arrow_right),
            ),
            Expanded(child: Container()),//将左右连接到一起
          ],
        )),


      ],
    ));
  }
}


