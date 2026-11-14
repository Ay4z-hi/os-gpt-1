import 'package:flutter/material.dart';
import '../design_tokens.dart';

class SmthPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? width;
  const SmthPanel({super.key,required this.child,this.padding=const EdgeInsets.all(SmthSpace.x3),this.width});
  @override Widget build(BuildContext context)=>Container(
    width:width,padding:padding,
    decoration:BoxDecoration(color:SmthColors.surface,border:Border.all(color:SmthColors.line,width:1),borderRadius:BorderRadius.circular(SmthRadius.medium)),
    child:child,
  );
}

class SmthSectionLabel extends StatelessWidget {
  final String text;
  const SmthSectionLabel(this.text,{super.key});
  @override Widget build(BuildContext context)=>Text(text.toUpperCase(),style:const TextStyle(fontFamily:SmthType.display,fontSize:SmthType.small,letterSpacing:1.1,color:SmthColors.muted));
}

class SmthAction extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool selected;
  const SmthAction({super.key,required this.label,this.onPressed,this.icon,this.selected=false});
  @override Widget build(BuildContext context)=>Material(
    color:selected?SmthColors.red:SmthColors.surface,
    child:InkWell(onTap:onPressed,child:Container(
      constraints:const BoxConstraints(minHeight:40),
      padding:const EdgeInsets.symmetric(horizontal:SmthSpace.x3,vertical:SmthSpace.x2),
      decoration:BoxDecoration(border:Border.all(color:selected?SmthColors.red:SmthColors.line)),
      child:Row(mainAxisSize:MainAxisSize.min,children:[if(icon!=null)Icon(icon,size:16,color:SmthColors.white),if(icon!=null)const SizedBox(width:SmthSpace.x2),Text(label.toLowerCase(),style:const TextStyle(fontFamily:SmthType.label,fontSize:SmthType.small,color:SmthColors.white))]),
    )),
  );
}

class SmthRule extends StatelessWidget {
  const SmthRule({super.key});
  @override Widget build(BuildContext context)=>const Divider(height:1,thickness:1,color:SmthColors.line);
}
