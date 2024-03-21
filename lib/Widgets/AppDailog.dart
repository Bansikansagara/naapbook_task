import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


ScaffoldFeatureController<SnackBar, SnackBarClosedReason> MyDialog({required BuildContext context,
  required String title,isError = true}){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(title
        ,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
      backgroundColor: isError?Colors.redAccent.withOpacity(0.4):Colors.green,
      behavior: SnackBarBehavior.floating,
    ),
  );
}