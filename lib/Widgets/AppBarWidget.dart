

import 'package:flutter/material.dart';


Widget MYAppBar({required String title,bool leading = true}){
  return AppBar(

    automaticallyImplyLeading: leading,
    centerTitle: true,
    title: Text(title,style: TextStyle(color: Colors.white,fontSize: 20),),
  //  leading: leading == false?null:IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
  );
}