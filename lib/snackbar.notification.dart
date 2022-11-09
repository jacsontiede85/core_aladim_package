// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';


SnackBar snackBarWidget({String? message, bool? erro, int? time}){
  /*
    erro = true -> Notivicação na cor vermelho
    erro = false -> Noviticação na cor azul
   */
  return SnackBar(
    backgroundColor: erro ?? false ? Colors.redAccent : Colors.black87,
    content: Text(message!, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.white), textAlign: TextAlign.center,),
    behavior: SnackBarBehavior.floating,
    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
    duration: Duration(seconds: time ?? 3),
  );
}