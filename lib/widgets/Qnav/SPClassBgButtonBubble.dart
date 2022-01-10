
import 'package:flutter/material.dart';

class SPClassBgButtonBubble extends CustomPainter{
  final spProHeightOffset=15;
  Paint spProPaint;
  double spProTransformOffset;
  SPClassBgButtonBubble({this.spProTransformOffset}){

    if(spProPaint==null){
      spProPaint =Paint()
        ..isAntiAlias=true
        ..strokeCap=StrokeCap.round
        ..style=PaintingStyle.fill
        ..strokeJoin=StrokeJoin.round;

  }

  }

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var centerOffset=Offset(size.width /2,size.height/2);
    var radius= ((size.height/2)*0.7);
    var anchorControlOffset=radius*0.8;
    var dipControlOffset=radius*0.55;
    final x0 = centerOffset.dx;
    final x1 = centerOffset.dx;
    final y=-1.0;

    spProPaint.shader=null;
    if(spProTransformOffset>0){
      spProPaint.color=Colors.white;

      final path = Path()
        ..moveTo(0, spProHeightOffset*spProTransformOffset)
        ..lineTo(x0-radius-anchorControlOffset,  spProHeightOffset*spProTransformOffset)
        ..lineTo(x0-radius-anchorControlOffset, spProHeightOffset*spProTransformOffset)
        ..cubicTo(x0 - radius + 2, dipControlOffset, x0 - anchorControlOffset, y, x0, y)
        ..lineTo(x1, y)
        ..cubicTo(x1 + anchorControlOffset, y, x1 + radius - 2, dipControlOffset, x0+radius+anchorControlOffset, spProHeightOffset*spProTransformOffset)
        ..lineTo( x0+radius+anchorControlOffset, spProHeightOffset*spProTransformOffset)
        ..lineTo( size.width, spProHeightOffset*spProTransformOffset)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height);

     canvas.drawPath(path, spProPaint);
    }




    if(spProPaint.shader==null){
      spProPaint.shader=new LinearGradient(colors:[Color(0xFFF2150C),Color(0xFFF24B0C)]).createShader(Rect.fromCenter(center: centerOffset,width: radius*2,height:radius*2));
    }
    canvas.drawCircle(centerOffset, radius, spProPaint);
    if(spProTransformOffset>0){
      var tranheight=spProTransformOffset;
      if(tranheight==1){
        tranheight=0;
      }
      Path path =Path()
        ..moveTo(centerOffset.dx-radius*0.93, centerOffset.dy+radius*0.4)
        ..quadraticBezierTo(centerOffset.dx, size.height+(radius*0.6)*tranheight, centerOffset.dx+radius*0.93, centerOffset.dy+radius*0.4);
      canvas.drawPath(path, spProPaint);

    }




  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }



}