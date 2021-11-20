import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Piece extends StatefulWidget {
  final int posX,posY,size;
  final bool isAnimated;

  final Color color;
  //???
  const Piece({ Key? key, required this.color, required this.size, required this.posX,required this.posY,this.isAnimated=false }): super(key: key);

  @override
  _PieceState createState() => _PieceState();
}
//食物个属性的定义
class _PieceState extends State<Piece> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;
  @override
  initState(){
    super.initState();
    _animationController=AnimationController(
        lowerBound: 0.25,
        upperBound: 1.0,
        duration: const Duration(milliseconds: 1000),
        vsync: this);
    //获取食物的状态，看其状态是否完成
    _animationController.addStatusListener((status) {
      if(status==AnimationStatus.completed){
        _animationController.reset();
      }else if(status==AnimationStatus.dismissed){
        _animationController.forward();
      }
    });
    _animationController.forward();

  }


  @override
  Widget build(BuildContext context) {
    return Positioned(
        top:widget.posY.toDouble(),
        left: widget.posX.toDouble(),
        child: Opacity(
        opacity: widget.isAnimated?_animationController.value:1,
          child: Container(//定义一个容器放置食物
              width: widget.size.toDouble(),
              height: widget.size.toDouble(),
              decoration: BoxDecoration(
                  color:widget.color,
                  borderRadius:const BorderRadius.all(Radius.circular(10.0)),
                  border:Border.all(width:2.0,color: Colors.white),
                 ),
            ),
    ));
  }
}
