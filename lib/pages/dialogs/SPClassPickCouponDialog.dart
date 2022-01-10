import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sport/model/SPClassCoupon.dart';
import 'package:sport/utils/SPClassCommonMethods.dart';
import 'package:sport/utils/SPClassDateUtils.dart';
import 'package:sport/utils/SPClassImageUtil.dart';
import 'package:sprintf/sprintf.dart';
import 'package:sport/SPClassEncryptImage.dart';

class SPClassPickCouponDialog extends StatefulWidget{
  List<SPClassCoupon> coupons;
  SPClassCoupon select;
  ValueChanged<SPClassCoupon> spProValueChanged;
  SPClassPickCouponDialog({this.coupons,this.select,this.spProValueChanged});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SPClassPickCouponDialogState();
  }

}


class SPClassPickCouponDialogState extends State<SPClassPickCouponDialog>{
  var spProCheckCoupon=false;
  SPClassCoupon coupon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coupon=widget.select;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: width(50),
                  child: Center(
                    child: Text("优惠券选择",style: TextStyle(fontSize: sp(18),fontWeight: FontWeight.bold),),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: width(15),
                  child: GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.clear,color:Color(0xFF787878),size: width(25),),
                    ),
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
             Container(
               decoration: BoxDecoration(
                 color: Colors.white,
                 border: Border(
                     bottom: BorderSide(width: 0.4,color: Colors.grey),
                     top: BorderSide(width: 0.4,color: Colors.grey),
                 )
               ),
                height: width(78)*widget.coupons.length,
                constraints: BoxConstraints(
                  maxHeight:width(232) ,
                  minHeight:width(100) ,
                ),
               child:ListView(
                 padding: EdgeInsets.zero,
                 children: widget.coupons.map((item) => Container(
                   height: width(63),
                   margin: EdgeInsets.only(right: width(12),left: width(12),top:height(12) ),
                   decoration: BoxDecoration(
                       boxShadow:[
                         BoxShadow(
                           offset: Offset(2,5),
                           color: Color(0x0D000000),
                           blurRadius:width(6,),),
                         BoxShadow(
                           offset: Offset(-5,1),
                           color: Color(0x0D000000),
                           blurRadius:width(6,),
                         )
                       ],
                       image: DecorationImage(
                           fit: BoxFit.fitWidth,
                           image: AssetImage(
                             SPClassImageUtil.spFunGetImagePath("bg_coupon_item"),
                           )
                       )
                   ),
                   child: Row(
                     children: <Widget>[
                       Container(
                         alignment: Alignment.center,
                         width: width(89),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: <Widget>[
                             Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.center,
                               children: <Widget>[
                                 RichText(
                                   text: TextSpan(
                                       text: "￥",
                                       style: TextStyle(color:Colors.white ,fontSize: sp(10),),
                                       children: <InlineSpan>[
                                         TextSpan(
                                             text:item.spPromoney,
                                             style: TextStyle(fontSize: sp(24))
                                         )
                                       ]
                                   ),
                                 ),
                               ],
                             ),
                             Text(sprintf("满%s可用",[item.spProMinMoney],),style: TextStyle(color: Colors.white,fontSize: sp(9)),)
                           ],
                         ),
                       ),
                       Container(
                         alignment: Alignment.centerLeft,
                         width: width(160),
                         padding: EdgeInsets.only(left: width(12)),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             Text(item.spProCouponName,style: TextStyle(fontSize: sp(15),),maxLines: 1,overflow: TextOverflow.ellipsis,),
                             Text(sprintf("%s-%s",[
                               SPClassDateUtils.spFunDateFormatByString(item.spProAddTime, "yyyy-MM-dd"),
                               SPClassDateUtils.spFunDateFormatByString(item.spProExpireTime, "yyyy-MM-dd")
                             ]),style: TextStyle(fontSize: sp(9),color: Color(0xFFB3B3B3)),maxLines: 1,overflow: TextOverflow.ellipsis,),

                           ],
                         ),
                       ),
                       SPClassEncryptImage.asset(
                         SPClassImageUtil.spFunGetImagePath("ic_soil_line",format: ".png"),
                         height: width(50),

                       ),

                       GestureDetector(
                         child:Padding(
                           padding: EdgeInsets.symmetric(horizontal: width(30),vertical: width(10)),
                           child: SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_check_box"), width: width(18),color:(coupon!=null&&coupon==item)?  Color(0xFFDE3C31): Color(0xFFCCCCCC)),
                         ),
                         onTap: (){
                           setState(() {
                             coupon=item;
                           });

                           spFunSelectCoupon();
                         },
                       )

                     ],
                   ),
                 )).toList(),
               ),
             )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: width(57),
        padding: EdgeInsets.only(bottom: ScreenUtil.bottomBarHeight),
        child: Row(children: <Widget>[
             SizedBox(width: width(19),),
             Text("暂不使用优惠券",style: TextStyle(fontSize: sp(16)),),
             Expanded(child: SizedBox(),),
             GestureDetector(
               child:Padding(
                 padding: EdgeInsets.symmetric(horizontal: width(40),vertical: width(10)),
                 child: SPClassEncryptImage.asset(SPClassImageUtil.spFunGetImagePath("ic_check_box"), width: width(18),color:spProCheckCoupon?  Color(0xFFDE3C31): Color(0xFFCCCCCC)),
               ),
               onTap: (){
                 spProCheckCoupon=!spProCheckCoupon;

                 spFunSelectCoupon();

               },
             )

        ],),
      ),
    );
  }

  spFunSelectCoupon(){
    if(spProCheckCoupon){
      coupon=null;
    }
    if(widget.spProValueChanged!=null){
      widget.spProValueChanged(coupon);
    }
    Navigator.of(context).pop();
  }
}