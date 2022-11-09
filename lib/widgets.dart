// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';

class WidgetCore{

  AppBar appBar({required String title, String? subtitle, double? fontSize, List<Widget>? actions, bool? isButtomBack})=>
    AppBar(
      leadingWidth: (isButtomBack??true) ? 40 : 0,
      iconTheme: IconThemeData(size: (isButtomBack??true) ? 25 : 0, color: Colors.black87),
      backgroundColor: Colors.white,
      elevation: 2,
      titleTextStyle: TextStyle(color: Colors.black87),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: fontSize??16, fontWeight: FontWeight.bold),),
          Visibility(visible: subtitle!=null, child: SizedBox(height: 5,),),
          Visibility(visible: subtitle!=null, child: Text(subtitle??'', style: TextStyle(fontSize: fontSize??11, fontWeight: FontWeight.w600, color: Colors.grey.shade600),),),
        ],
      ),
      actionsIconTheme: IconThemeData(color: Colors.black87),
      actions: actions,
    );

  TextField textField({TextEditingController? controller, required BuildContext context, IconData? prefixIcon,  String? hintText, TextInputType? keyboardType, bool? obscureText, Function? onChanged, Function? onSubmitted, TextInputAction? textInputAction, bool? enabled})=>
      TextField(
          controller: controller,
          obscureText: obscureText??false,
          enabled: enabled??true,
          keyboardType: keyboardType??TextInputType.text,
          style: TextStyle(color: Colors.black87, fontSize: 18.0),
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.secondary,),),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Theme.of(context).colorScheme.secondary,),),
            disabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7, color: Colors.grey),),
            contentPadding: EdgeInsets.only(left: prefixIcon==null ? 10 : 0, bottom: 5, top: prefixIcon==null ? 5 : 13, right: 0),
            hintText: '',
            labelText: hintText??'',
            hintStyle: TextStyle(color: Colors.blueGrey, fontSize: 12.0),
            labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 13.0),
            prefixIcon: prefixIcon==null ? null :
            Icon(
              prefixIcon,
              size: 20,
              color: enabled??true ? Theme.of(context).colorScheme.secondary : Colors.grey,
            ),
          ),
          maxLines: 1,
          textInputAction: textInputAction??TextInputAction.next,
          onSubmitted: (v) => {
            if(onSubmitted!=null)
              onSubmitted(v)
          },
          onChanged: (v) => {
            if(onChanged!=null)
              onChanged(v)
          }
      );

  OutlinedButton outlinedButton({required String text, double? fontSize, required Function function, bool? iconLeft, double? sizeIcon, bool? loading, String? typeIcon}){
      typeIcon = typeIcon??'next';
      IconData icon = Icons.navigate_next;
      switch(typeIcon){
        case 'back': icon = Icons.navigate_before; break;
        case 'add': icon = Icons.add_circle_outline; break;
        case 'remove': icon = Icons.remove_circle_outline; break;
        case 'check': icon = Icons.check_circle_outline; break;
        default: icon = Icons.navigate_next; break;
      }
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.blue.withOpacity(0.8),
          textStyle: TextStyle(color: Colors.white),
        ),
        onPressed: ()=> function(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(!(loading??false) && (iconLeft??false)) Icon(icon, size: sizeIcon??20, color: Colors.white),
            if(!(loading??false) && (iconLeft??false)) SizedBox(width: 7,),
            (loading??false)
                ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white,),)
                : Expanded(child: Text(text, style: TextStyle(fontSize: fontSize??17, color: Colors.white)),),
            if(!(loading??false) && !(iconLeft??false)) SizedBox(width: 7,),
            if(!(loading??false) && !(iconLeft??false)) Icon(icon, size: sizeIcon??20, color: Colors.white),
          ],
        ),
      );
  }

  Widget get circularProgressIndicator=> Center(
      child: Padding(
        padding: EdgeInsets.only(top: 5, bottom: 0, left: 0, right: 0),
        child: SizedBox(
          height: 25,
          width: 25,
          child: CircularProgressIndicator(),
        ),
      )
  );

  Widget campoTextoPequenoComBorda({var titulo, var texto}){
    double sizeFonte = texto.toString().length > 2 ? 20.0 : 25.0;
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            titulo,
            style: TextStyle( fontSize: 10.0, color: Colors.black87 ),
          ),
          SizedBox( height: 2.0,),
          Container(
            width: 52.0,
            height: 35.0,
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                  bottom: BorderSide(width: 0.9, style: BorderStyle.solid, color: Colors.grey.shade400),
                  top: BorderSide(width: 0.9, style: BorderStyle.solid, color: Colors.grey.shade400),
                  left: BorderSide(width: 0.9, style: BorderStyle.solid, color: Colors.grey.shade400),
                  right: BorderSide(width: 0.9, style: BorderStyle.solid, color: Colors.grey.shade400)
              ),
            ),
            child: Text(
              texto,
              style: TextStyle( fontSize: sizeFonte, fontWeight: FontWeight.bold ),
            ),
          ),
        ],
      );
  }

  Widget campoTextoPequenoComBorda2({var titulo, var texto}){
    double sizeFonte = texto.toString().length > 2 ? 16.0 : 20.0;
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            titulo,
            style: TextStyle( fontSize: 10.0, color: Colors.black87 ),
          ),
          SizedBox( height: 2.0,),
          Container(
            width: 52.0,
            height: 35.0,
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                  bottom: BorderSide(width: 0.9, style: BorderStyle.solid, color: Colors.grey.shade400),
                  top: BorderSide(width: 0.9, style: BorderStyle.solid, color: Colors.grey.shade400),
                  left: BorderSide(width: 0.9, style: BorderStyle.solid, color: Colors.grey.shade400),
                  right: BorderSide(width: 0.9, style: BorderStyle.solid, color: Colors.grey.shade400)
              ),
            ),
            child: Text(
              texto,
              style: TextStyle( fontSize: sizeFonte, fontWeight: FontWeight.bold ),
            ),
          ),
        ],
      );
  }

  Widget campoTexto({var titulo, var texto}){
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            titulo,
            style: TextStyle( fontSize: 10.0, color: Colors.black87 ),
          ),
          SizedBox( height: 2.0,),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 10.0),
            child: Text(
              texto,
              style: TextStyle( fontSize: 14.0, fontWeight: FontWeight.bold ),
            ),
          ),
        ],
      );
  }

  Widget get checkedConcluido =>
      Container(
        padding: const EdgeInsets.fromLTRB(30.0, 150.0, 30.0, 150.0),
        color: Colors.black87.withOpacity(0.3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11.0),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Image.asset('images/checked2.gif',),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Text('Concluído com sucesso!', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  )
                ],
              )
          ),
        ),
      );

  Widget get checkedError =>
      Container(
        padding: const EdgeInsets.fromLTRB(30.0, 100.0, 30.0, 100.0),
        color: Colors.black87.withOpacity(0.3),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11.0),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Image.asset('images/error.gif',),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Text('Ops! Ocorreu um erro inesperado.', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  )
                ],
              )
            ),
        ),
      );

  Widget checkedFinalizadoOk({required BuildContext context, required Function function}) =>
      Container(
        padding: const EdgeInsets.fromLTRB(10.0, 130.0, 10.0, 130.0),
        color: Colors.black87.withOpacity(0.3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11.0),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  Image.asset('images/checked.gif',),
                  Positioned(
                    bottom: 60,
                    left: 20,
                    right: 20,
                    child: Text('Finalizado com sucesso!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center,),
                  ),

                  Positioned(
                    bottom: 4,
                    right: 70,
                    left: 70,
                    child: ElevatedButton(
                      child: Padding(padding: EdgeInsets.only(top: 3, bottom: 3), child: Text("OK"),),
                      onPressed: ()=>function(),
                    ),
                  ),

                ],
              )
          ),
        ),
      );
}