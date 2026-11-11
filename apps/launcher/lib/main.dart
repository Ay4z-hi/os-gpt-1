import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

const violet=Color(0xFFB16CFF), lime=Color(0xFFD5FF63), cyan=Color(0xFF62E8FF), coral=Color(0xFFFF718B), ink=Color(0xFF09090D), panel=Color(0xFF17171E), raised=Color(0xFF23232C), muted=Color(0xFFAAAAB5);
const catalog=<AppInfo>[
 AppInfo('Files','Workspace','FILE',true),AppInfo('Browser','Live internet','WEB',true),AppInfo('Terminal','Command desk','TERM',true),AppInfo('Settings','Personalise','CTRL',true),AppInfo('Store','Get more tools','GET',true),
 AppInfo('Music','Frequency player','MUSIC',false),AppInfo('Video','Local cinema','VIDEO',false),AppInfo('Notes','Quick notes','NOTE',false),AppInfo('Calculator','Basic arithmetic','CALC',false),AppInfo('Clock','Live local time','TIME',false),AppInfo('Reader','Read the web','READ',false),AppInfo('YouTube','Video platform','YT',false),AppInfo('Instagram','Social camera','IG',false),AppInfo('Viber','Calls & messages','VB',false),AppInfo('AI Studio','API-powered coding agent','AI',true)
];
class AppInfo{final String name,desc,glyph;final bool core;const AppInfo(this.name,this.desc,this.glyph,this.core);}
Future<void> main() async{
 WidgetsFlutterBinding.ensureInitialized();
 try{await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);}catch(_){}
 try{await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);}catch(_){}
 try{await windowManager.ensureInitialized();const o=WindowOptions(size:Size(960,600),center:true,title:'SMTH OS Preview',backgroundColor:ink);windowManager.waitUntilReadyToShow(o,()async{await windowManager.setMinimumSize(const Size(720,450));await windowManager.show();await windowManager.focus();});}catch(_){}
 runApp(const Smth());
}
class Smth extends StatelessWidget{const Smth({super.key});@override Widget build(BuildContext c)=>MaterialApp(debugShowCheckedModeBanner:false,title:'SMTH OS',theme:ThemeData(useMaterial3:true,brightness:Brightness.dark,fontFamily:'Arial',scaffoldBackgroundColor:ink,colorScheme:const ColorScheme.dark(primary:violet,secondary:lime,surface:panel)),home:const Desktop());}
class Desktop extends StatefulWidget{const Desktop({super.key});@override State<Desktop> createState()=>_DesktopState();}
class _DesktopState extends State<Desktop> with TickerProviderStateMixin{
 late final AnimationController motion=AnimationController(vsync:this,duration:const Duration(seconds:28))..repeat();
 final Set<String> installed={'Files','Browser','Terminal','Settings','Store','Music','Video','Notes','Calculator','Clock','AI Studio'};final Set<String> desktopApps={};
 final List<String> terminal=['SMTH // COMMAND DESK','Type help for available commands.'];
 bool ahian=false,wifi=true,bluetooth=false,quiet=false,contrast=false,pointerOn=false,notice=false,menu=false,zen=false;String wallpaper='metal',activeApp='';
 Offset pointer=const Offset(80,80);String note='Welcome to SMTH Notes.\n\nA small space for your thoughts.';
 @override void initState(){super.initState();_load();}
 Future<void> _load()async{final p=await SharedPreferences.getInstance();if(!mounted)return;setState((){ahian=p.getBool('ahian')??false;wifi=p.getBool('wifi')??true;bluetooth=p.getBool('bluetooth')??false;quiet=p.getBool('quiet')??false;contrast=p.getBool('contrast')??false;pointerOn=p.getBool('pointer')??true;wallpaper=p.getString('wallpaper')??'metal';note=p.getString('note')??note;installed.addAll(p.getStringList('installed')??[]);desktopApps.addAll(p.getStringList('desktopApps')??[]);});}
 Future<void> save(String k,Object v)async{final p=await SharedPreferences.getInstance();if(v is bool)await p.setBool(k,v);if(v is String)await p.setString(k,v);if(v is List<String>)await p.setStringList(k,v);}
 void ahianToggle(){setState(()=>ahian=!ahian);save('ahian',ahian);}
 void open(String n){if(n=='YouTube'||n=='Instagram'||n=='Viber'){final uri=Uri.parse(n=='YouTube'?'vnd.youtube://':n=='Instagram'?'instagram://app':'viber://');launchUrl(uri,mode:LaunchMode.externalApplication).then((ok){if(!ok&&mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(n+' app is not installed. Install its official app first.')));});return;}if(!installed.contains(n)){show('Store');return;}setState(()=>activeApp=n);show(n);}
 void show(String n){Offset position=Offset.zero;showGeneralDialog(context:context,barrierDismissible:true,barrierLabel:n,barrierColor:Colors.black.withOpacity(.7),transitionDuration:const Duration(milliseconds:220),pageBuilder:(c,a,b)=>StatefulBuilder(builder:(dialogContext,setDialogState)=>Center(child:Transform.translate(offset:position,child:AppWindow(name:n,ahian:ahian,installed:installed,wifi:wifi,bluetooth:bluetooth,quiet:quiet,contrast:contrast,pointerOn:pointerOn,note:note,terminal:terminal,onMove:(delta)=>setDialogState(()=>position+=delta),onClose:(){setState(()=>activeApp='');Navigator.pop(c);},wallpaper:wallpaper,onWallpaper:(v){setState(()=>wallpaper=v);save('wallpaper',v);},onToggle:(k,v){setState((){switch(k){case'wifi':wifi=v;break;case'bluetooth':bluetooth=v;break;case'quiet':quiet=v;break;case'contrast':contrast=v;break;case'pointer':pointerOn=v;break;}});save(k,v);},onInstall:(name,v){setState((){if(v){installed.add(name);}else{installed.remove(name);}});save('installed',installed.toList());},onNote:(v){note=v;save('note',v);},onCommand:command,onAhian:ahianToggle,onOpen:(x){Navigator.pop(c);open(x);},onDesktopAdd:(x){setState(()=>desktopApps.add(x));save('desktopApps',desktopApps.toList());})))),transitionBuilder:(c,a,b,child)=>FadeTransition(opacity:a,child:ScaleTransition(scale:Tween<double>(begin:.96,end:1).animate(CurvedAnimation(parent:a,curve:Curves.easeOutCubic)),child:child)));}
 void command(String raw){final s=raw.trim();if(s.isEmpty)return;final parts=s.split(' ');setState((){terminal.add('smth@desk  '+s);switch(parts.first.toLowerCase()){
 case'help':terminal.add('Built-ins: help, echo, open, ahian, clear. Other commands run in the app user shell.');break;
 case'echo':terminal.add(s.length>5?s.substring(5):'');break;
 case'ahian':if(parts.length>1&&parts[1].toLowerCase()=='on'){ahian=true;}else if(parts.length>1&&parts[1].toLowerCase()=='off'){ahian=false;}else{ahian=!ahian;}save('ahian',ahian);terminal.add('AHIAN easter egg '+(ahian?'unlocked — all systems animated':'closed'));break;
 case'clear':terminal.clear();break;
 case'open':if(parts.length>1){final target=parts[1].toLowerCase();final match=catalog.where((x)=>x.name.toLowerCase()==target);if(match.isNotEmpty){terminal.add('Opening '+match.first.name);Future.microtask(()=>open(match.first.name));}else{terminal.add('No app named '+parts[1]);}}else{terminal.add('Usage: open [app]');}break;
 default:terminal.add('Running in '+Platform.operatingSystem+' user shell…');Future.microtask(()=>runHostCommand(s));
 }if(terminal.length>100)terminal.removeRange(0,terminal.length-100);});}
 Future<void> runHostCommand(String value)async{try{final result=await Process.run(Platform.isWindows?'cmd.exe':'sh',Platform.isWindows?['/c',value]:['-c',value]);final out=(result.stdout.toString()+'\n'+result.stderr.toString()).trim();if(mounted)setState(()=>terminal.add(out.isEmpty?'[exit '+result.exitCode.toString()+']':out));}catch(e){if(mounted)setState(()=>terminal.add('Command unavailable in this app sandbox: '+e.toString()));}}
 @override void dispose(){motion.dispose();super.dispose();}
 @override Widget build(BuildContext c)=>Scaffold(body:MouseRegion(cursor:pointerOn?SystemMouseCursors.none:SystemMouseCursors.basic,onHover:(e)=>setState(()=>pointer=e.localPosition),child:Listener(onPointerHover:(e)=>setState(()=>pointer=e.localPosition),onPointerDown:(e)=>setState(()=>pointer=e.localPosition),child:Stack(children:[
 Positioned.fill(child:AnimatedBuilder(animation:motion,builder:(c,_)=>CustomPaint(painter:Wallpaper(ahian,motion.value,contrast,wallpaper)))),
 SafeArea(child:AnimatedBuilder(animation:motion,builder:(context,child){final t=motion.value*math.pi*2;return Transform.translate(offset:ahian?Offset(math.sin(t)*2,math.cos(t*1.3)*1.5):Offset.zero,child:Transform.scale(scale:ahian?1+math.sin(t*2)*.002:1,child:child));},child:Column(children:[top(),Expanded(child:workspace()),dock()]))),
 if(activeApp.isNotEmpty)Positioned(top:7,left:0,right:0,child:Center(child:GestureDetector(onTap:()=>open(activeApp),child:AnimatedBuilder(animation:motion,builder:(context,_){final pulse=.5+.5*math.sin(motion.value*math.pi*2);return AnimatedContainer(duration:const Duration(milliseconds:320),padding:const EdgeInsets.symmetric(horizontal:18,vertical:9),decoration:BoxDecoration(color:ink,borderRadius:BorderRadius.circular(28),border:Border.all(color:(ahian?lime:Colors.white).withOpacity(.25+pulse*.25)),boxShadow:[BoxShadow(color:(ahian?lime:Colors.black).withOpacity(.10+pulse*.12),blurRadius:20)]),child:Row(mainAxisSize:MainAxisSize.min,children:[Icon(activeApp=='Music'?Icons.graphic_eq:activeApp=='Video'?Icons.play_circle_outline:activeApp=='Files'?Icons.folder_open_rounded:Icons.apps_rounded,size:15,color:lime),const SizedBox(width:8),Text(activeApp.toUpperCase(),style:const TextStyle(fontSize:9,fontWeight:FontWeight.w800,letterSpacing:1.4)),const SizedBox(width:9),Container(width:5,height:5,decoration:BoxDecoration(color:lime,shape:BoxShape.circle,boxShadow:[BoxShadow(color:lime.withOpacity(pulse),blurRadius:7)]))]));})))),if(menu)Positioned(left:16,bottom:76,child:startMenu()),
 if(notice&&!quiet&&!zen)Positioned(right:18,top:58,child:notifications()),
 
 ]))));
 Widget top()=>const SizedBox(height:4);
 Widget _pill(Widget child,VoidCallback tap,{String? label})=>Material(color:ink.withOpacity(.88),borderRadius:BorderRadius.circular(30),child:InkWell(onTap:tap,borderRadius:BorderRadius.circular(30),child:Container(height:34,padding:EdgeInsets.symmetric(horizontal:label==null?11:14),decoration:BoxDecoration(border:Border.all(color:Colors.white.withOpacity(.14)),borderRadius:BorderRadius.circular(30)),child:Row(mainAxisSize:MainAxisSize.min,children:[child,if(label!=null)Padding(padding:const EdgeInsets.only(left:8),child:Text(label,style:const TextStyle(fontSize:10,color:Colors.white70)))]))));
 Widget status(IconData i,String t)=>Row(children:[Icon(i,color:muted,size:14),const SizedBox(width:5),Text(t,style:const TextStyle(color:muted,fontSize:9,letterSpacing:1))]);
 Widget workspace(){final size=MediaQuery.sizeOf(context);return Padding(padding:const EdgeInsets.fromLTRB(24,6,24,6),child:Stack(children:[
  if(desktopApps.isNotEmpty)Positioned(left:0,top:8,bottom:150,width:math.min(210.0,size.width*.24),child:Wrap(spacing:8,runSpacing:8,children:[for(final app in desktopApps)InkWell(onTap:()=>open(app),child:Container(width:58,padding:const EdgeInsets.all(5),decoration:BoxDecoration(color:ink.withOpacity(.55),borderRadius:BorderRadius.circular(10),border:Border.all(color:Colors.white.withOpacity(.12))),child:Column(children:[Icon(Icons.apps_rounded,color:lime,size:20),const SizedBox(height:3),Text(app,style:const TextStyle(fontSize:8),maxLines:1,overflow:TextOverflow.ellipsis)])))])),
  Positioned(left:0,bottom:34,child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text(TimeOfDay.now().format(context),style:const TextStyle(fontSize:28,fontWeight:FontWeight.w300,letterSpacing:-3,color:Colors.white)),
    const SizedBox(height:8),
    Row(crossAxisAlignment:CrossAxisAlignment.center,children:[Text('SMTH',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900,letterSpacing:-3,color:Colors.white,shadows:[Shadow(color:Colors.white.withOpacity(.22),blurRadius:12)])),const SizedBox(width:12),Container(width:3,height:42,color:violet),const SizedBox(width:10),const Text('SYSTEM / 01',style:TextStyle(fontSize:9,letterSpacing:2.5,color:Colors.white70))]),
    const SizedBox(height:8),Text(DateTime.now().toLocal().toString().split(' ').first.toUpperCase(),style:const TextStyle(fontSize:9,color:Colors.white60,letterSpacing:2))
  ])),
  Positioned(right:0,top:12,child:Material(color:ink.withOpacity(.82),borderRadius:BorderRadius.circular(12),child:InkWell(onTap:()=>open('Clock'),borderRadius:BorderRadius.circular(12),child:Padding(padding:const EdgeInsets.symmetric(horizontal:10,vertical:7),child:Row(mainAxisSize:MainAxisSize.min,children:[const Icon(Icons.schedule_rounded,size:13,color:lime),const SizedBox(width:7),Text(TimeOfDay.now().format(context),style:const TextStyle(fontSize:11,fontWeight:FontWeight.w700)),const SizedBox(width:8),const Text('OPEN CLOCK',style:TextStyle(fontSize:7,color:muted,letterSpacing:1))]))))),
 ]));}
 Widget _metalWidget({required Widget child})=>Container(width:double.infinity,padding:const EdgeInsets.all(7),decoration:BoxDecoration(color:ink.withOpacity(.86),borderRadius:BorderRadius.circular(13),border:Border.all(color:Colors.white.withOpacity(.2)),boxShadow:[BoxShadow(color:Colors.black.withOpacity(.24),blurRadius:12,offset:const Offset(0,4))]),child:child);
 Widget _desktopShortcut(String label,IconData icon,VoidCallback tap)=>Padding(padding:const EdgeInsets.only(right:18),child:InkWell(onTap:tap,borderRadius:BorderRadius.circular(12),child:Column(children:[Container(width:28,height:28,decoration:BoxDecoration(color:ink.withOpacity(.86),shape:BoxShape.circle,border:Border.all(color:Colors.white.withOpacity(.16))),child:Icon(icon,size:16,color:label=='STORE'?lime:Colors.white)),const SizedBox(height:5),Text(label,style:const TextStyle(fontSize:8,color:muted,letterSpacing:1))])));
 Widget _statusLine(IconData icon,String title,String value,bool active)=>Padding(padding:const EdgeInsets.only(bottom:9),child:Row(children:[Icon(icon,size:13,color:active?lime:muted),const SizedBox(width:8),Expanded(child:Text(title,style:const TextStyle(fontSize:8,color:muted,letterSpacing:1))),Text(value,style:TextStyle(fontSize:8,color:active?Colors.white:muted))]));
 Widget iconTile(AppInfo a)=>MouseRegion(cursor:SystemMouseCursors.click,child:GestureDetector(onTap:()=>open(a.name),child:AnimatedContainer(duration:const Duration(milliseconds:220),padding:const EdgeInsets.all(5),decoration:BoxDecoration(color:Colors.white.withOpacity(.04),border:Border.all(color:Colors.white.withOpacity(.08)),borderRadius:BorderRadius.circular(12)),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Expanded(child:CustomPaint(painter:Glyph(a.glyph,ahian),size:const Size(38,30))),const SizedBox(height:5),Text(a.name,style:const TextStyle(fontSize:8,fontWeight:FontWeight.w700)),Text(a.desc,style:const TextStyle(fontSize:6,color:muted),maxLines:1,overflow:TextOverflow.ellipsis)]))));
 Widget dock()=>Padding(padding:const EdgeInsets.fromLTRB(14,0,14,12),child:Center(child:Container(height:34,padding:const EdgeInsets.symmetric(horizontal:6),decoration:BoxDecoration(color:ink.withOpacity(.94),border:Border.all(color:Colors.white.withOpacity(.16)),borderRadius:BorderRadius.circular(28),boxShadow:[BoxShadow(color:Colors.black.withOpacity(.25),blurRadius:18,offset:const Offset(0,5))]),child:Row(mainAxisSize:MainAxisSize.min,children:[
  for(final item in [('MENU',Icons.apps_rounded),('Files',Icons.folder_open_rounded),('Browser',Icons.language_rounded),('Terminal',Icons.terminal_rounded),('Music',Icons.graphic_eq),('Video',Icons.play_circle_outline),('Notes',Icons.sticky_note_2_outlined),('Settings',Icons.tune_rounded),('Store',Icons.grid_view_rounded)])
   Padding(padding:const EdgeInsets.symmetric(horizontal:4),child:Tooltip(message:item.$1,child:InkWell(onTap:()=>item.$1=='MENU'?setState(()=>menu=!menu):open(item.$1),borderRadius:BorderRadius.circular(24),child:Container(width:25,height:25,decoration:BoxDecoration(color:raised.withOpacity(.9),shape:BoxShape.circle),child:Icon(item.$2,size:12,color:item.$1=='Store'?lime:Colors.white))))),
  const SizedBox(width:6),Tooltip(message:zen?'Exit Zen mode':'Enter Zen mode',child:InkWell(onTap:()=>setState(()=>zen=!zen),borderRadius:BorderRadius.circular(20),child:Container(width:28,height:28,decoration:BoxDecoration(color:zen?lime:raised,shape:BoxShape.circle),child:Icon(Icons.spa_rounded,size:15,color:zen?ink:lime)))),const SizedBox(width:6),Container(width:1,height:20,color:Colors.white24),const SizedBox(width:8),IconButton(padding:EdgeInsets.zero,constraints:const BoxConstraints.tightFor(width:28,height:28),onPressed:()=>setState(()=>notice=!notice),icon:const Icon(Icons.notifications_none,size:15,color:lime))
 ]))));
 Widget startMenu()=>Container(width:260,padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:ink.withOpacity(.97),border:Border.all(color:Colors.white.withOpacity(.16)),borderRadius:BorderRadius.circular(18),boxShadow:[BoxShadow(color:Colors.black.withOpacity(.45),blurRadius:30)]),child:Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisSize:MainAxisSize.min,children:[const Text('SMTH / QUICK ACCESS',style:TextStyle(color:lime,fontSize:9,letterSpacing:2,fontWeight:FontWeight.bold)),const SizedBox(height:12),for(final a in catalog.where((x)=>x.core||installed.contains(x.name)))InkWell(onTap:(){setState(()=>menu=false);open(a.name);},child:Padding(padding:const EdgeInsets.symmetric(vertical:7),child:Row(children:[Container(width:28,height:28,decoration:BoxDecoration(color:raised,borderRadius:BorderRadius.circular(9)),child:Center(child:Text(a.glyph.substring(0,math.min(2,a.glyph.length)),style:const TextStyle(color:violet,fontSize:8,fontWeight:FontWeight.w900)))),const SizedBox(width:11),Expanded(child:Text(a.name,style:const TextStyle(fontSize:11))),const Icon(Icons.arrow_outward,size:12,color:muted)])))]));
 Widget notifications()=>Container(width:230,padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:panel,border:Border.all(color:lime),borderRadius:BorderRadius.circular(12)),child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('ACTIVITY',style:TextStyle(color:lime,fontSize:9,letterSpacing:2)),SizedBox(height:12),Text('All clear.',style:TextStyle(fontWeight:FontWeight.bold)),Text('SMTH is ready when you are.',style:TextStyle(color:muted,fontSize:11))]));
}
class AppWindow extends StatefulWidget{
 final String name;final bool ahian,wifi,bluetooth,quiet,contrast,pointerOn;final String wallpaper;final Set<String> installed;final String note;final List<String> terminal;
 final VoidCallback onClose,onAhian;final ValueChanged<Offset> onMove;final void Function(String,bool) onToggle,onInstall;final ValueChanged<String> onNote,onCommand,onOpen,onWallpaper,onDesktopAdd;
 const AppWindow({super.key,required this.name,required this.ahian,required this.installed,required this.wifi,required this.bluetooth,required this.quiet,required this.contrast,required this.pointerOn,required this.wallpaper,required this.note,required this.terminal,required this.onWallpaper,required this.onMove,required this.onClose,required this.onAhian,required this.onToggle,required this.onInstall,required this.onNote,required this.onCommand,required this.onOpen,required this.onDesktopAdd});
 @override State<AppWindow> createState()=>_AppWindowState();
}
class _AppWindowState extends State<AppWindow>{
 late final TextEditingController address=TextEditingController(text:'https://www.google.com'),note=TextEditingController(text:widget.note),command=TextEditingController(),calc=TextEditingController(),aiKey=TextEditingController(),aiPrompt=TextEditingController(),aiEndpoint=TextEditingController(text:'https://api.openai.com/v1/chat/completions'),aiModel=TextEditingController(text:'gpt-4o-mini');String aiProvider='OpenAI-compatible';String browserMsg='Your window to the live web.',result='',aiReply='Choose an API provider, add its key and model, then send a prompt.';bool aiBusy=false;final List<String> aiHistory=[];
 late bool _wifi,_bluetooth,_quiet,_contrast,_pointerOn,_ahian;Offset _dragOffset=Offset.zero;int _clockTab=0;final Stopwatch _stopwatch=Stopwatch();Directory? _root;List<FileSystemEntity> _items=[];final AudioPlayer audio=AudioPlayer();final List<PlatformFile> tracks=[];final List<PlatformFile> videos=[];bool playing=false;String currentTrack='';String _wallpaper='metal';
 @override void initState(){super.initState();_wifi=widget.wifi;_bluetooth=widget.bluetooth;_quiet=widget.quiet;_contrast=widget.contrast;_pointerOn=widget.pointerOn;_wallpaper=widget.wallpaper;_ahian=widget.ahian;if(widget.name=='Files')loadFiles();}
 @override void dispose(){address.dispose();note.dispose();command.dispose();calc.dispose();aiKey.dispose();aiPrompt.dispose();aiEndpoint.dispose();aiModel.dispose();audio.dispose();super.dispose();}
 @override Widget build(BuildContext c)=>Material(child:LayoutBuilder(builder:(context,limits)=>Container(width:math.min(680.0,limits.maxWidth-28).toDouble(),height:math.min(400.0,limits.maxHeight-28).toDouble(),decoration:BoxDecoration(color:panel,border:Border.all(color:widget.ahian?lime:violet,width:1.2),borderRadius:BorderRadius.circular(14),boxShadow:[BoxShadow(color:Colors.black.withOpacity(.55),blurRadius:40)]),child:Column(children:[GestureDetector(onPanUpdate:(d)=>widget.onMove(d.delta),child:Container(height:34,padding:const EdgeInsets.symmetric(horizontal:11),decoration:const BoxDecoration(color:ink,borderRadius:BorderRadius.vertical(top:Radius.circular(13))),child:Row(children:[Container(width:27,height:27,decoration:BoxDecoration(color:violet.withOpacity(.15),borderRadius:BorderRadius.circular(9)),child:Center(child:Icon(widget.name=='Music'?Icons.graphic_eq:widget.name=='Video'?Icons.play_circle_outline:widget.name=='Files'?Icons.folder_open_rounded:widget.name=='Settings'?Icons.tune_rounded:Icons.apps_rounded,size:15,color:lime))),const SizedBox(width:10),Text(widget.name.toUpperCase(),style:const TextStyle(fontWeight:FontWeight.w900,fontSize:10,letterSpacing:2)),const Spacer(),const Text('SMTH / APP',style:TextStyle(color:muted,fontSize:9,letterSpacing:1)),const SizedBox(width:12),IconButton(onPressed:widget.onClose,style:IconButton.styleFrom(backgroundColor:raised,minimumSize:const Size(29,29)),icon:const Icon(Icons.close,size:15,color:lime))]))),Expanded(child:Padding(padding:const EdgeInsets.all(14),child:content()))]))));
 Future<void> loadFiles()async{try{final dir=_root??await getApplicationDocumentsDirectory();_root=dir;await dir.create(recursive:true);final list=await dir.list().toList();list.sort((a,b)=>a.path.toLowerCase().compareTo(b.path.toLowerCase()));if(mounted)setState((){_root=dir;_items=list;}); }catch(e){if(mounted)setState(()=>browserMsg='Files unavailable: '+e.toString());}}
 Future<void> addFile()async{if(_root==null)return;final name=TextEditingController(text:'untitled.txt');final chosen=await showDialog<String>(context:context,builder:(c)=>AlertDialog(backgroundColor:panel,title:const Text('Create a file'),content:TextField(controller:name,autofocus:true,decoration:const InputDecoration(hintText:'name.txt / .md / .json / .csv')),actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('CANCEL')),FilledButton(onPressed:()=>Navigator.pop(c,name.text.trim()),child:const Text('CREATE'))]));if(chosen==null||chosen.isEmpty)return;final safe=chosen.split(Platform.pathSeparator).last.replaceAll('/','').replaceAll('\\','');if(safe.isEmpty)return;final file=File(_root!.path+'/'+safe);if(!await file.exists())await file.writeAsString('');await loadFiles();}
 Future<void> chooseFolder()async{final path=await FilePicker.platform.getDirectoryPath();if(path!=null){_root=Directory(path);await loadFiles();}}
 Future<void> goUp()async{if(_root==null)return;final parent=_root!.parent;if(parent.path!=_root!.path){_root=parent;await loadFiles();}}
 Future<void> importFiles()async{final result=await FilePicker.platform.pickFiles(allowMultiple:true,type:FileType.any);if(result==null||_root==null)return;for(final item in result.files){if(item.path!=null){final name=item.name;final target=File('${_root!.path}/$name');if(!await target.exists())await File(item.path!).copy(target.path);}}await loadFiles();}
 Future<void> addFolder()async{if(_root==null)return;final dir=Directory(_root!.path+'/New Folder '+DateTime.now().millisecondsSinceEpoch.toString());await dir.create(recursive:true);await loadFiles();}
 Future<void> removeItem(FileSystemEntity item)async{await item.delete(recursive:true);await loadFiles();}
 Future<void> previewFile(FileSystemEntity item)async{if(item is Directory){_root=item;await loadFiles();return;}if(item is File){final ext=item.path.split('.').last.toLowerCase();if(!['txt','md','json','csv','log','yaml','yml','xml','html','css','js','dart','ini','conf','sh'].contains(ext)){await OpenFilex.open(item.path);return;}try{final data=await item.readAsString();if(!mounted)return;final editor=TextEditingController(text:data);await showDialog(context:context,builder:(c)=>AlertDialog(backgroundColor:panel,title:Text(item.uri.pathSegments.last),content:SizedBox(width:560,height:330,child:TextField(controller:editor,maxLines:null,expands:true,style:const TextStyle(fontFamily:'monospace',fontSize:11),decoration:const InputDecoration(filled:true,fillColor:ink,border:InputBorder.none,contentPadding:EdgeInsets.all(12)))),actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('CANCEL')),FilledButton(onPressed:()async{await item.writeAsString(editor.text);if(c.mounted)Navigator.pop(c);await loadFiles();},child:const Text('SAVE'))]));editor.dispose();}catch(_){if(mounted)setState(()=>browserMsg='This file cannot be edited here.');}}}
 
 
 Future<void> pickMusic()async{final r=await FilePicker.platform.pickFiles(type:FileType.audio,allowMultiple:true);if(r!=null&&mounted)setState(()=>tracks.addAll(r.files.where((x)=>x.path!=null)));}
 Future<void> playMusic(PlatformFile file)async{if(file.path==null)return;try{if(currentTrack==file.path&&playing){await audio.pause();setState(()=>playing=false);}else if(currentTrack==file.path){await audio.resume();setState(()=>playing=true);}else{await audio.stop();await audio.play(DeviceFileSource(file.path!));setState((){currentTrack=file.path!;playing=true;});}}catch(e){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Could not play this audio: $e')));}}
 Future<void> pickVideos()async{final r=await FilePicker.platform.pickFiles(type:FileType.video,allowMultiple:true);if(r!=null&&mounted)setState(()=>videos.addAll(r.files.where((x)=>x.path!=null)));}
 Widget musicContent()=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
 Row(children:[const Text('FREQUENCY / YOUR LIBRARY',style:TextStyle(color:lime,fontSize:9,letterSpacing:2)),const Spacer(),FilledButton.icon(onPressed:pickMusic,icon:const Icon(Icons.add,size:16),label:const Text('IMPORT'))]),
 const SizedBox(height:9),
 Container(width:double.infinity,padding:const EdgeInsets.all(12),decoration:BoxDecoration(color:raised,borderRadius:BorderRadius.circular(16),border:Border.all(color:Colors.white12)),child:Row(children:[
  Container(width:54,height:54,decoration:BoxDecoration(gradient:LinearGradient(colors:[violet.withOpacity(.5),lime.withOpacity(.16)]),borderRadius:BorderRadius.circular(13)),child:const Icon(Icons.graphic_eq,size:29,color:Colors.white)),
  const SizedBox(width:11),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
   const Text('NOW IN ROTATION',style:TextStyle(fontSize:8,color:lime,letterSpacing:1.5)),
   Text(currentTrack.isEmpty?'Choose a track':currentTrack.split(Platform.pathSeparator).last,style:const TextStyle(fontSize:12,fontWeight:FontWeight.w800),maxLines:1,overflow:TextOverflow.ellipsis),
   const SizedBox(height:4),Text(playing?'PLAYING':'READY TO PLAY',style:const TextStyle(fontSize:8,color:muted,letterSpacing:1))
  ])),
  IconButton(onPressed:currentTrack.isEmpty?pickMusic:()=>playMusic(tracks.firstWhere((t)=>t.path==currentTrack,orElse:()=>tracks.first)),icon:Icon(playing?Icons.pause_circle_filled:Icons.play_circle_filled,color:lime,size:27))
 ])),
 const SizedBox(height:6),
 StreamBuilder<Duration>(stream:audio.onPositionChanged,initialData:Duration.zero,builder:(c,s){final pos=s.data??Duration.zero;return FutureBuilder<Duration?>(future:audio.getDuration(),builder:(c,d){final total=d.data??Duration.zero;final maxMs=math.max(1,total.inMilliseconds);return Row(children:[
  Text(_time(pos),style:const TextStyle(fontSize:8,color:muted)),
  Expanded(child:Slider(min:0,max:maxMs.toDouble(),value:pos.inMilliseconds.clamp(0,maxMs).toDouble(),onChanged:total==Duration.zero?null:(v)=>audio.seek(Duration(milliseconds:v.round())))),
  Text(_time(total),style:const TextStyle(fontSize:8,color:muted))
 ]);});}),
 const SizedBox(height:4),
 Expanded(child:tracks.isEmpty?Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.album_outlined,size:40,color:muted),const SizedBox(height:8),const Text('Build your rotation',style:TextStyle(fontWeight:FontWeight.bold)),const SizedBox(height:5),const Text('Import MP3, WAV, FLAC, M4A and more.',style:TextStyle(color:muted,fontSize:10))])):ListView.builder(itemCount:tracks.length,itemBuilder:(c,i){final t=tracks[i];final selected=currentTrack==t.path;return Container(margin:const EdgeInsets.only(bottom:3),decoration:BoxDecoration(color:selected?violet.withOpacity(.12):Colors.transparent,borderRadius:BorderRadius.circular(10)),child:ListTile(dense:true,leading:Container(width:35,height:35,decoration:BoxDecoration(color:selected?lime.withOpacity(.16):raised,borderRadius:BorderRadius.circular(10)),child:Icon(selected&&playing?Icons.graphic_eq:Icons.music_note,color:selected?lime:violet,size:18)),title:Text(t.name,style:const TextStyle(fontSize:11,fontWeight:FontWeight.w700),maxLines:1,overflow:TextOverflow.ellipsis),subtitle:Text((t.extension??'AUDIO').toUpperCase(),style:const TextStyle(color:muted,fontSize:9)),trailing:IconButton(onPressed:()=>playMusic(t),icon:Icon(selected&&playing?Icons.pause_circle:Icons.play_circle,color:lime,size:25)),onTap:()=>playMusic(t)));}))
 ]);
 String _time(Duration d)=>'${d.inMinutes.remainder(60).toString().padLeft(2,'0')}:${d.inSeconds.remainder(60).toString().padLeft(2,'0')}';
 Widget videoContent()=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[const Text('VIDEO LIBRARY',style:TextStyle(color:lime,fontSize:9,letterSpacing:2)),const Spacer(),FilledButton.icon(onPressed:pickVideos,icon:const Icon(Icons.add,size:16),label:const Text('ADD VIDEO'))]),const SizedBox(height:12),Expanded(child:videos.isEmpty?Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.video_library_outlined,size:44,color:muted),const SizedBox(height:10),const Text('Your videos, one place',style:TextStyle(fontWeight:FontWeight.bold)),const SizedBox(height:5),const Text('Choose a video to open it in your device player.',style:TextStyle(color:muted,fontSize:10))])):GridView.builder(itemCount:videos.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3,childAspectRatio:1.5,crossAxisSpacing:9,mainAxisSpacing:9),itemBuilder:(c,i){final v=videos[i];return InkWell(onTap:()=>OpenFilex.open(v.path!),borderRadius:BorderRadius.circular(13),child:Container(padding:const EdgeInsets.all(10),decoration:BoxDecoration(color:raised,borderRadius:BorderRadius.circular(13),border:Border.all(color:Colors.white12)),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.play_circle_fill,size:32,color:lime),const SizedBox(height:7),Text(v.name,style:const TextStyle(fontSize:9,fontWeight:FontWeight.w700),maxLines:2,overflow:TextOverflow.ellipsis,textAlign:TextAlign.center),Text((v.extension??'VIDEO').toUpperCase(),style:const TextStyle(color:muted,fontSize:8))])));}))]);
 Widget content(){switch(widget.name){case'Files':return Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
 Row(children:[const Text('APP DOCUMENTS / PRIVATE WORKSPACE',style:TextStyle(color:lime,fontSize:9,letterSpacing:2)),const Spacer(),PopupMenuButton<String>(tooltip:'Add an app to desktop',icon:const Icon(Icons.add_to_home_screen,color:lime),onSelected:widget.onDesktopAdd,itemBuilder:(c)=>widget.installed.where((x)=>!['Files','Store','Terminal'].contains(x)).map((x)=>PopupMenuItem(value:x,child:Text('Add '+x+' to desktop'))).toList()),IconButton(tooltip:'New text file',onPressed:addFile,icon:const Icon(Icons.note_add_outlined,color:lime)),IconButton(tooltip:'New folder',onPressed:addFolder,icon:const Icon(Icons.create_new_folder_outlined,color:violet)),IconButton(tooltip:'Choose folder',onPressed:chooseFolder,icon:const Icon(Icons.folder_open,color:violet)),IconButton(tooltip:'Import files',onPressed:importFiles,icon:const Icon(Icons.file_upload_outlined,color:lime)),IconButton(tooltip:'Parent folder',onPressed:goUp,icon:const Icon(Icons.arrow_upward_rounded)),IconButton(tooltip:'Refresh',onPressed:loadFiles,icon:const Icon(Icons.refresh))]),
 Expanded(child:_root==null?const Center(child:CircularProgressIndicator()):_items.isEmpty?const Center(child:Text('This folder is empty. Create a file to start.',style:TextStyle(color:muted))):ListView(children:[for(final item in _items)ListTile(dense:true,leading:Icon(item is Directory?Icons.folder_outlined:Icons.description_outlined,color:item is Directory?violet:lime),title:Text(item.uri.pathSegments.isEmpty?item.path:item.uri.pathSegments.last),subtitle:Text(item is Directory?'Folder':'File',style:const TextStyle(color:muted,fontSize:10)),onTap:()=>previewFile(item),trailing:IconButton(onPressed:()=>removeItem(item),icon:const Icon(Icons.delete_outline,color:muted,size:18)))])),
 Text(_root?.path??'Opening app documents…',style:const TextStyle(color:muted,fontSize:9),maxLines:1,overflow:TextOverflow.ellipsis)
]);
 case'Browser':return Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[Expanded(child:TextField(controller:address,style:const TextStyle(fontSize:12),decoration:const InputDecoration(prefixIcon:Icon(Icons.public,color:lime),hintText:'Website or search',filled:true,fillColor:ink,border:OutlineInputBorder(borderSide:BorderSide.none,borderRadius:BorderRadius.all(Radius.circular(8)))))),const SizedBox(width:8),FilledButton(onPressed:browse,child:const Text('GO'))]),const SizedBox(height:16),Text(browserMsg,style:const TextStyle(color:muted,fontSize:12)),const SizedBox(height:14),Wrap(spacing:8,children:[for(final x in ['https://www.wikipedia.org','https://www.youtube.com','https://github.com'])ActionChip(label:Text(Uri.parse(x).host),onPressed:(){address.text=x;browse();})]),const Spacer(),const Text('Opens real pages in your device browser to keep SMTH lightweight.',style:TextStyle(color:muted,fontSize:10))]);
 case'Terminal':return Column(children:[Expanded(child:Container(width:double.infinity,padding:const EdgeInsets.all(14),decoration:BoxDecoration(color:ink,borderRadius:BorderRadius.circular(8)),child:ListView(children:[for(final l in widget.terminal)Padding(padding:const EdgeInsets.only(bottom:7),child:Text(l,style:const TextStyle(fontFamily:'monospace',fontSize:11,color:lime)))]))),const SizedBox(height:8),Row(children:[const Text('smth \$ ',style:TextStyle(color:violet,fontFamily:'monospace')),Expanded(child:TextField(controller:command,style:const TextStyle(fontFamily:'monospace',fontSize:12),decoration:const InputDecoration(hintText:'type help',isDense:true),onSubmitted:(v){widget.onCommand(v);command.clear();setState((){});})),IconButton(onPressed:(){widget.onCommand(command.text);command.clear();setState((){});},icon:const Icon(Icons.arrow_forward,color:lime))])]);
 case'Settings':return ListView(children:[const Text('PERSONALISE YOUR SPACE',style:TextStyle(color:lime,fontSize:9,letterSpacing:2)),const SizedBox(height:10),switchRow('Wi-Fi preview','Saved launcher network state',_wifi,(v){setState(()=>_wifi=v);widget.onToggle('wifi',v);},Icons.wifi),switchRow('Bluetooth preview','Saved launcher device state',_bluetooth,(v){setState(()=>_bluetooth=v);widget.onToggle('bluetooth',v);},Icons.bluetooth),switchRow('Quiet mode','Reduce notification visuals',_quiet,(v){setState(()=>_quiet=v);widget.onToggle('quiet',v);},Icons.notifications_off),switchRow('High contrast','Sharper panel outlines',_contrast,(v){setState(()=>_contrast=v);widget.onToggle('contrast',v);},Icons.contrast),const Divider(color:Colors.white12),const Text('WALLPAPER',style:TextStyle(color:lime,fontSize:9,letterSpacing:2)),const SizedBox(height:8),Wrap(spacing:10,children:[ChoiceChip(label:const Text('Metallic'),selected:_wallpaper=='metal',onSelected:(_){setState(()=>_wallpaper='metal');widget.onWallpaper('metal');}),ChoiceChip(avatar:const Icon(Icons.blur_circular,size:15),label:const Text('Event Horizon'),selected:_wallpaper=='singularity',onSelected:(_){setState(()=>_wallpaper='singularity');widget.onWallpaper('singularity');})]),const SizedBox(height:12),const ListTile(leading:Icon(Icons.screen_rotation,color:violet),title:Text('Display orientation'),subtitle:Text('Landscape locked on Android'))]);
 case'Store':
 return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
   const Text('SMTH / APP MARKET',style:TextStyle(color:lime,fontSize:9,letterSpacing:2,fontWeight:FontWeight.bold)),
   const SizedBox(height:6),
   const Text('Small tools. Useful by design.',style:TextStyle(fontSize:19,fontWeight:FontWeight.w800)),
   const SizedBox(height:10),
   Expanded(
    child: GridView.count(
     crossAxisCount:3,
     childAspectRatio:2.3,
     children:[
      for(final a in catalog.where((x)=>!x.core))
       Container(
        margin:const EdgeInsets.all(5),
        padding:const EdgeInsets.all(9),
        decoration:BoxDecoration(color:raised,borderRadius:BorderRadius.circular(9)),
        child:Row(
         children:[
          CustomPaint(size:const Size(32,32),painter:Glyph(a.glyph,widget.ahian)),
          const SizedBox(width:8),
          Expanded(
           child:Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            mainAxisAlignment:MainAxisAlignment.center,
            children:[
             Text(a.name,style:const TextStyle(fontWeight:FontWeight.bold,fontSize:11)),
             Text(a.desc,style:const TextStyle(color:muted,fontSize:9),maxLines:1,overflow:TextOverflow.ellipsis),
            ],
           ),
          ),
          TextButton(
           onPressed:(){
            final v=!widget.installed.contains(a.name);
            widget.onInstall(a.name,v);
            setState((){});
           },
           child:Text(widget.installed.contains(a.name)?'REMOVE':'ADD',style:const TextStyle(fontSize:9,color:lime)),
          ),
         ],
        ),
       ),
     ],
    ),
   ),
   const Text('Launcher apps install to this profile. The Linux ISO uses its own APT app store.',style:TextStyle(color:muted,fontSize:9)),
  ],
 );
 case'Music':return musicContent();
 case'Video':return videoContent();
 case'Notes':return Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('QUICK NOTE / AUTO-SAVED',style:TextStyle(color:lime,fontSize:9,letterSpacing:2)),const SizedBox(height:12),Expanded(child:TextField(controller:note,maxLines:null,expands:true,onChanged:widget.onNote,style:const TextStyle(fontSize:15,height:1.6),decoration:const InputDecoration(hintText:'Start writing…',border:InputBorder.none,filled:true,fillColor:ink,contentPadding:EdgeInsets.all(16))))]);
 case'Calculator':return Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('QUICK CALC',style:TextStyle(color:lime,fontSize:9,letterSpacing:2)),const SizedBox(height:22),TextField(controller:calc,keyboardType:const TextInputType.numberWithOptions(decimal:true,signed:true),decoration:const InputDecoration(hintText:'e.g. 125 * 4',filled:true,fillColor:ink),onSubmitted:(_)=>calculate()),const SizedBox(height:12),FilledButton(onPressed:calculate,child:const Text('CALCULATE')),const SizedBox(height:20),Text(result,style:const TextStyle(fontSize:28,fontWeight:FontWeight.w800,color:lime))]);
 case'Clock':return Column(children:[
   SegmentedButton<int>(
     segments:const [ButtonSegment(value:0,label:Text('Clock')),ButtonSegment(value:1,label:Text('Stopwatch')),ButtonSegment(value:2,label:Text('Alarm')),ButtonSegment(value:3,label:Text('World'))],
     selected:{_clockTab},
     onSelectionChanged:(v)=>setState(()=>_clockTab=v.first),
   ),
   const SizedBox(height:14),
   Expanded(child:Center(child:_clockTab==0
     ? Column(mainAxisAlignment:MainAxisAlignment.center,children:[
         const Text('LOCAL TIME',style:TextStyle(color:lime,letterSpacing:3,fontSize:10)),
         const SizedBox(height:14),
         StreamBuilder<DateTime>(stream:Stream.periodic(const Duration(seconds:1),(_)=>DateTime.now()),initialData:DateTime.now(),builder:(c,s)=>Text(TimeOfDay.fromDateTime(s.data!).format(c),style:const TextStyle(fontSize:64,fontWeight:FontWeight.w800))),
         Text(DateTime.now().toLocal().toString().split(' ').first,style:const TextStyle(color:muted)),
       ])
     : _clockTab==1
       ? Column(mainAxisAlignment:MainAxisAlignment.center,children:[
           StreamBuilder<int>(stream:Stream.periodic(const Duration(milliseconds:30),(_)=>_stopwatch.elapsedMilliseconds),initialData:0,builder:(c,s){final ms=s.data??0;return Text('${(ms~/60000).toString().padLeft(2,'0')}:${((ms~/1000)%60).toString().padLeft(2,'0')}.${((ms%1000)~/10).toString().padLeft(2,'0')}',style:const TextStyle(fontSize:48,fontWeight:FontWeight.w800));}),
           const SizedBox(height:16),
           Wrap(spacing:8,children:[
             FilledButton(onPressed:()=>setState(()=>_stopwatch.isRunning?_stopwatch.stop():_stopwatch.start()),child:Text(_stopwatch.isRunning?'PAUSE':'START')),
             OutlinedButton(onPressed:()=>setState(()=>_stopwatch.reset()),child:const Text('RESET')),
           ]),
         ])
       : _clockTab==2
         ? Column(mainAxisAlignment:MainAxisAlignment.center,children:[
             const Icon(Icons.alarm,size:48,color:lime),
             const SizedBox(height:10),
             const Text('ALARMS',style:TextStyle(letterSpacing:2,color:lime)),
             const SizedBox(height:10),
             FilledButton.icon(onPressed:()async{final t=await showTimePicker(context:context,initialTime:TimeOfDay.now());if(t!=null&&mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Alarm set for '+t.format(context)+' (reminder only)')));},icon:const Icon(Icons.add_alarm),label:const Text('ADD ALARM')),
           ])
         : const Column(mainAxisAlignment:MainAxisAlignment.center,children:[
             Text('WORLD CLOCK',style:TextStyle(color:lime,letterSpacing:2)),
             SizedBox(height:18),
             _WorldTime(label:'Dhaka',offset:6),
             _WorldTime(label:'London',offset:0),
             _WorldTime(label:'New York',offset:-5),
             _WorldTime(label:'Tokyo',offset:9),
           ]),
   )),
 ]);

 case'AI Studio':return aiStudio();
 case'Reader':return Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Text('READ THE OPEN WEB',style:TextStyle(color:lime,letterSpacing:2,fontSize:10)),const SizedBox(height:16),const Text('A clean reading space starts with a good page.',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),const SizedBox(height:20),FilledButton(onPressed:()=>launchUrl(Uri.parse('https://www.wikipedia.org'),mode:LaunchMode.externalApplication),child:const Text('OPEN WIKIPEDIA'))]));
 default:return const Center(child:Text('No app content available.'));
 }}
 Widget aiStudio()=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
  Row(children:[const Icon(Icons.auto_awesome,color:lime,size:18),const SizedBox(width:8),const Text('SMTH AI / UNIVERSAL API STUDIO',style:TextStyle(fontSize:10,letterSpacing:1.4,color:lime,fontWeight:FontWeight.w800)),const Spacer(),Text(aiBusy?'WORKING':'API MODE',style:const TextStyle(fontSize:8,color:muted))]),
  const SizedBox(height:7),
  Row(children:[Expanded(child:DropdownButtonFormField<String>(value:aiProvider,decoration:const InputDecoration(isDense:true,labelText:'API type',filled:true,fillColor:ink,border:OutlineInputBorder(borderSide:BorderSide.none)),items:const [DropdownMenuItem(value:'OpenAI-compatible',child:Text('OpenAI-compatible')),DropdownMenuItem(value:'Anthropic',child:Text('Anthropic')),DropdownMenuItem(value:'Google Gemini',child:Text('Google Gemini'))],onChanged:(v){if(v==null)return;setState((){aiProvider=v;if(v=='Anthropic'){aiEndpoint.text='https://api.anthropic.com/v1/messages';aiModel.text='claude-sonnet-4-5-20250929';}else if(v=='Google Gemini'){aiEndpoint.text='https://generativelanguage.googleapis.com/v1beta/models';aiModel.text='gemini-2.5-flash';}else{aiEndpoint.text='https://api.openai.com/v1/chat/completions';aiModel.text='gpt-4o-mini';}});})),const SizedBox(width:7),Expanded(child:TextField(controller:aiModel,decoration:const InputDecoration(isDense:true,labelText:'Model',filled:true,fillColor:ink,border:OutlineInputBorder(borderSide:BorderSide.none))))]),
  const SizedBox(height:6),
  TextField(controller:aiEndpoint,decoration:const InputDecoration(isDense:true,labelText:'API endpoint',prefixIcon:Icon(Icons.link,size:15),filled:true,fillColor:ink,border:OutlineInputBorder(borderSide:BorderSide.none))),
  const SizedBox(height:6),
  TextField(controller:aiKey,obscureText:true,decoration:const InputDecoration(isDense:true,prefixIcon:Icon(Icons.key,size:16),hintText:'API key',filled:true,fillColor:ink,border:OutlineInputBorder(borderSide:BorderSide.none))),
  const SizedBox(height:7),
  Expanded(child:Container(width:double.infinity,padding:const EdgeInsets.all(10),decoration:BoxDecoration(color:ink,borderRadius:BorderRadius.circular(11),border:Border.all(color:violet.withOpacity(.3))),child:ListView(children:[const Text('CODING ASSISTANT',style:TextStyle(fontSize:8,color:cyan,letterSpacing:1.4)),const SizedBox(height:8),Text(aiReply,style:const TextStyle(fontSize:11,height:1.5)),for(final line in aiHistory)Padding(padding:const EdgeInsets.only(top:9),child:Text(line,style:const TextStyle(fontSize:10,color:lime,height:1.4)))]))),
  const SizedBox(height:7),
  Row(children:[Expanded(child:TextField(controller:aiPrompt,minLines:1,maxLines:3,decoration:const InputDecoration(isDense:true,hintText:'Ask about code, bugs, commands or architecture…',filled:true,fillColor:ink,border:OutlineInputBorder(borderSide:BorderSide.none)),onSubmitted:(_)=>sendAI())),const SizedBox(width:7),FilledButton(onPressed:aiBusy?null:sendAI,child:aiBusy?const SizedBox(width:15,height:15,child:CircularProgressIndicator(strokeWidth:2)):const Icon(Icons.arrow_upward,size:16))]),
  const SizedBox(height:3),const Text('Supports OpenAI-compatible APIs, Anthropic Messages and Google Gemini. Custom endpoints must use one of these request formats. Your key stays in memory for this session.',style:TextStyle(fontSize:7,color:muted))
 ]);
 Future<void> sendAI()async{
  final key=aiKey.text.trim(),prompt=aiPrompt.text.trim(),model=aiModel.text.trim(),endpoint=aiEndpoint.text.trim();
  if(key.isEmpty||prompt.isEmpty||model.isEmpty||endpoint.isEmpty){setState(()=>aiReply='Enter an API key, model, endpoint and prompt first.');return;}
  aiPrompt.clear();setState((){aiBusy=true;aiHistory.add('YOU  /  '+prompt);});
  HttpClient? client;
  try{
   client=HttpClient();client.connectionTimeout=const Duration(seconds:30);
   Uri uri=Uri.parse(endpoint);Map<String,String> headers={HttpHeaders.contentTypeHeader:'application/json'};Map<String,dynamic> payload={};
   if(aiProvider=='Anthropic'){
    headers['x-api-key']=key;headers['anthropic-version']='2023-06-01';headers['anthropic-dangerous-direct-browser-access']='true';
    payload={'model':model,'max_tokens':1800,'system':'You are SMTH AI Studio, a concise coding assistant. Help with code, debugging, architecture and terminal commands. You cannot directly change files in this version; provide exact patches or commands and explain risks.','messages':[{'role':'user','content':prompt}]};
   }else if(aiProvider=='Google Gemini'){
    final base=endpoint.endsWith('/')?endpoint.substring(0,endpoint.length-1):endpoint;
    uri=Uri.parse('$base/$model:generateContent').replace(queryParameters:{'key':key});
    payload={'systemInstruction':{'parts':[{'text':'You are SMTH AI Studio, a concise coding assistant. Help with code, debugging, architecture and terminal commands. You cannot directly change files in this version; provide exact patches or commands and explain risks.'}]},'contents':[{'role':'user','parts':[{'text':prompt}]}],'generationConfig':{'maxOutputTokens':1800}};
   }else{
    headers[HttpHeaders.authorizationHeader]='Bearer $key';
    payload={'model':model,'max_tokens':1800,'messages':[{'role':'system','content':'You are SMTH AI Studio, a concise coding assistant. Help with code, debugging, architecture and terminal commands. You cannot directly change files in this version; provide exact patches or commands and explain risks.'},{'role':'user','content':prompt}]};
   }
   final req=await client.postUrl(uri);headers.forEach((k,v)=>req.headers.set(k,v));req.write(jsonEncode(payload));
   final response=await req.close();final body=await response.transform(utf8.decoder).join();final data=jsonDecode(body);
   if(response.statusCode<200||response.statusCode>=300)throw Exception(data['error']?['message']??data['message']??'API request failed (HTTP ${response.statusCode})');
   String answer='';
   if(aiProvider=='Anthropic'){answer=((data['content'] as List? ?? []).where((x)=>x['type']=='text').map((x)=>x['text'].toString()).join('\\n'));}
   else if(aiProvider=='Google Gemini'){final candidates=data['candidates'] as List? ?? [];final parts=candidates.isEmpty?const []:(candidates.first['content']?['parts'] as List? ?? []);answer=parts.map((x)=>x['text']??'').join('\\n');}
   else{answer=(data['choices'] as List).first['message']['content'].toString();}
   if(mounted)setState(()=>aiReply=answer.isEmpty?'The API returned no text.':answer);
  }catch(e){if(mounted)setState(()=>aiReply='Request failed: ${e.toString()}');}
  finally{client?.close(force:true);if(mounted)setState(()=>aiBusy=false);}
 }
 Widget switchRow(String t,String d,bool v,ValueChanged<bool> f,IconData i)=>SwitchListTile(value:v,onChanged:f,activeColor:lime,secondary:Icon(i,color:violet),title:Text(t,style:const TextStyle(fontSize:12)),subtitle:Text(d,style:const TextStyle(fontSize:10,color:muted)));
 Future<void> browse()async{var raw=address.text.trim();if(raw.isEmpty)return;if(!raw.contains('://')){raw=raw.contains('.')&&!raw.contains(' ')?'https://'+raw:'https://www.google.com/search?q='+Uri.encodeQueryComponent(raw);}try{final u=Uri.parse(raw);final ok=await launchUrl(u,mode:LaunchMode.externalApplication);if(mounted)setState(()=>browserMsg=ok?'Opened '+u.host:'Could not open this address.');}catch(_){if(mounted)setState(()=>browserMsg='Could not open this address.');}}
 void calculate(){final s=calc.text.replaceAll(' ','');final m=RegExp(r'^(-?\d+(?:\.\d+)?)([+\-*/])(-?\d+(?:\.\d+)?)$').firstMatch(s);if(m==null){setState(()=>result='Use: 12 + 4');return;}final a=double.parse(m.group(1)!);final b=double.parse(m.group(3)!);final op=m.group(2);final v=op=='+'?a+b:op=='-'?a-b:op=='*'?a*b:b==0?double.nan:a/b;setState(()=>result=v.isNaN?'Cannot divide by zero':v.toString());}
}
class _WorldTime extends StatelessWidget{final String label;final int offset;const _WorldTime({required this.label,required this.offset});@override Widget build(BuildContext c)=>Padding(padding:const EdgeInsets.symmetric(vertical:7,horizontal:30),child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[Text(label,style:const TextStyle(fontSize:15)),Text(TimeOfDay.fromDateTime(DateTime.now().toUtc().add(Duration(hours:offset))).format(c),style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:lime))]));}
class Brand extends StatelessWidget{final double size;const Brand({super.key,required this.size});@override Widget build(BuildContext c)=>CustomPaint(size:Size(size,size),painter:BrandPainter());}
class BrandPainter extends CustomPainter{@override void paint(Canvas c,Size s){c.drawCircle(Offset(s.width/2,s.height/2),s.width*.32,Paint()..style=PaintingStyle.stroke..strokeWidth=1.7..color=violet);c.drawArc(Rect.fromCircle(center:Offset(s.width/2,s.height/2),radius:s.width*.47),-.7,2.8,false,Paint()..style=PaintingStyle.stroke..strokeWidth=2..color=lime);c.drawCircle(Offset(s.width*.52,s.height*.5),s.width*.12,Paint()..color=Colors.white);}@override bool shouldRepaint(covariant CustomPainter o)=>false;}
class Glyph extends CustomPainter{final String glyph;final bool alt;Glyph(this.glyph,this.alt);@override void paint(Canvas c,Size s){final color=alt?lime:violet;final p=Paint()..style=PaintingStyle.stroke..strokeWidth=2.4..strokeCap=StrokeCap.round..strokeJoin=StrokeJoin.round..color=color;final fill=Paint()..color=ink;final r=Rect.fromCenter(center:Offset(s.width/2,s.height/2),width:s.width*.68,height:s.height*.68);switch(glyph){
 case'FILE':c.drawRRect(RRect.fromRectAndRadius(r,const Radius.circular(5)),p);for(int i=0;i<3;i++)c.drawLine(Offset(r.left+7,r.top+12+i*8),Offset(r.right-7-(i==2?10:0),r.top+12+i*8),p);break;
 case'WEB':c.drawCircle(r.center,r.width*.48,p);c.drawOval(Rect.fromCenter(center:r.center,width:r.width*.35,height:r.height*.95),p);c.drawLine(Offset(r.left,r.center.dy),Offset(r.right,r.center.dy),p);break;
 case'TERM':c.drawPath(Path()..moveTo(r.left+7,r.top+12)..lineTo(r.left+20,r.center.dy)..lineTo(r.left+7,r.bottom-12),p);c.drawLine(Offset(r.left+25,r.bottom-12),Offset(r.right-6,r.bottom-12),p);break;
 case'CTRL':for(int i=0;i<3;i++){final y=r.top+10+i*12;c.drawLine(Offset(r.left+4,y),Offset(r.right-4,y),p);c.drawCircle(Offset(r.left+13+i*9,y),3,fill);c.drawCircle(Offset(r.left+13+i*9,y),3,p);}break;
 case'GET':c.drawRRect(RRect.fromRectAndRadius(r,const Radius.circular(6)),p);c.drawArc(Rect.fromLTWH(r.left+12,r.top-5,r.width-24,25),math.pi,math.pi,false,p);c.drawLine(Offset(r.left+12,r.center.dy),Offset(r.right-12,r.center.dy),p);break;
 case'NOTE':c.drawRRect(RRect.fromRectAndRadius(r,const Radius.circular(4)),p);for(int i=0;i<3;i++)c.drawLine(Offset(r.left+8,r.top+12+i*9),Offset(r.right-8-(i==2?10:0),r.top+12+i*9),p);break;
 case'CALC':c.drawRRect(RRect.fromRectAndRadius(r,const Radius.circular(5)),p);for(int i=0;i<2;i++)for(int j=0;j<2;j++)c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(r.left+8+j*15,r.top+8+i*15,8,8),const Radius.circular(2)),fill);break;
 case'MUSIC':c.drawCircle(r.center,r.width*.42,p);c.drawPath(Path()..moveTo(r.left+10,r.center.dy)..lineTo(r.left+10,r.top+10)..lineTo(r.right-9,r.top+6)..lineTo(r.right-9,r.center.dy),p);c.drawCircle(Offset(r.left+10,r.center.dy+8),5,p);c.drawCircle(Offset(r.right-9,r.center.dy+8),5,p);break;
 case'VIDEO':c.drawRRect(RRect.fromRectAndRadius(r,const Radius.circular(7)),p);c.drawPath(Path()..moveTo(r.center.dx-5,r.center.dy-8)..lineTo(r.center.dx+9,r.center.dy)..lineTo(r.center.dx-5,r.center.dy+8)..close(),p);break;
 case'TIME':c.drawCircle(r.center,r.width*.46,p);c.drawLine(r.center,Offset(r.center.dx,r.top+8),p);c.drawLine(r.center,Offset(r.right-9,r.center.dy+4),p);break;
 case'READ':c.drawPath(Path()..moveTo(r.center.dx,r.top+7)..quadraticBezierTo(r.left,r.top-1,r.left+4,r.center.dy)..lineTo(r.left+4,r.bottom-7)..quadraticBezierTo(r.center.dx-4,r.bottom-14,r.center.dx,r.bottom-5)..quadraticBezierTo(r.center.dx+4,r.bottom-14,r.right-4,r.bottom-7)..lineTo(r.right-4,r.center.dy)..quadraticBezierTo(r.right,r.top-1,r.center.dx,r.top+7),p);break;
 default:c.drawCircle(r.center,r.width*.42,p);c.drawCircle(r.center,r.width*.2,fill);
 }}@override bool shouldRepaint(covariant Glyph o)=>o.glyph!=glyph||o.alt!=alt;}
class Wallpaper extends CustomPainter{
 final bool ahian,contrast;final double phase;final String style;Wallpaper(this.ahian,this.phase,this.contrast,this.style);
 @override void paint(Canvas c,Size s){
  final rect=Offset.zero&s;if(style=='singularity'){_singularity(c,s,phase,ahian);return;}c.drawRect(rect,Paint()..color=const Color(0xFF252529));
  final base=Paint()..shader=const LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[Color(0xFF08080B),Color(0xFF77777A),Color(0xFF17171A),Color(0xFF8A8A8D),Color(0xFF101014)],stops:[0,.22,.48,.73,1]).createShader(rect);c.drawRect(rect,base);
  final band=Paint()..style=PaintingStyle.stroke..strokeWidth=5;
  for(int i=0;i<30;i++){final y=i*s.height/29;final shimmer=math.sin(phase*math.pi*2+i*.42);band.shader=LinearGradient(begin:Alignment.centerLeft,end:Alignment.centerRight,colors:[Colors.black.withOpacity(.9),Colors.white.withOpacity(.28+shimmer.abs()*.12),Colors.black.withOpacity(.78),Colors.white.withOpacity(.2+shimmer.abs()*.12),Colors.black.withOpacity(.9)]).createShader(Rect.fromLTWH(0,y,s.width,5));c.drawLine(Offset(0,y+math.sin(phase*6+i*.3)*(ahian?5:1)),Offset(s.width,y),band);}
  final sheen=Paint()..shader=RadialGradient(center:Alignment(-.45+phase*.15,-.3),radius:1.1,colors:[Colors.white.withOpacity(.34),Colors.white.withOpacity(.04),Colors.transparent],stops:const [0,.25,1]).createShader(rect);c.drawRect(rect,sheen);
  if(ahian){for(int i=0;i<18;i++){final x=(i/18*s.width+phase*s.width*.24)%s.width;final hue=(phase*360+i*22)%360;final accent=Paint()..style=PaintingStyle.stroke..strokeWidth=1.35..color=HSVColor.fromAHSV(.72,hue,.78,1).toColor();c.drawLine(Offset(x,0),Offset(x-s.height*.22,s.height),accent);}final pulse=.5+.5*math.sin(phase*math.pi*2);c.drawCircle(Offset(s.width*.5,s.height*.48),40+pulse*12,Paint()..color=lime.withOpacity(.035+pulse*.045));}
 }
 void _singularity(Canvas c,Size s,double phase,bool animate){final rect=Offset.zero&s;c.drawRect(rect,Paint()..color=const Color(0xFF030306));final center=Offset(s.width*.52,s.height*.5);final radius=math.min(s.width,s.height)*.22;final ring=Paint()..style=PaintingStyle.stroke..strokeWidth=3;for(int i=0;i<34;i++){final a=i*math.pi/34+phase*(animate ? .18 : 0);ring.color=Colors.white.withOpacity(.025+(i%4)*.018);final path=Path();for(int j=0;j<=80;j++){final t=j/80*math.pi*2;final x=math.cos(t)*radius*(1+.22*math.cos(a));final y=math.sin(t)*radius*.42;final point=Offset(center.dx+x*math.cos(a)-y*math.sin(a),center.dy+x*math.sin(a)+y*math.cos(a));if(j==0)path.moveTo(point.dx,point.dy);else path.lineTo(point.dx,point.dy);}c.drawPath(path,ring);}c.drawCircle(center,radius*.64,Paint()..color=Colors.black);final glow=Paint()..shader=RadialGradient(colors:[Colors.white.withOpacity(.18),Colors.transparent]).createShader(Rect.fromCircle(center:center,radius:radius*1.6));c.drawCircle(center,radius*1.6,glow);}
 @override bool shouldRepaint(covariant Wallpaper o)=>o.ahian!=ahian||o.phase!=phase||o.contrast!=contrast||o.style!=style;
}
class OrbitMark extends CustomPainter{
 final bool alt;final double phase;OrbitMark(this.alt,this.phase);
 @override void paint(Canvas c,Size s){final p=Paint()..style=PaintingStyle.stroke..strokeWidth=1.2;final center=Offset(s.width/2,s.height/2);for(int i=0;i<5;i++){p.color=(i.isEven?violet:lime).withOpacity(.4);c.drawOval(Rect.fromCenter(center:center,width:80+i*25,height:42+i*19),p);}c.drawCircle(center,19,Paint()..color=ink);c.drawCircle(center,19,Paint()..style=PaintingStyle.stroke..strokeWidth=1.4..color=Colors.white.withOpacity(.75));final dot=Offset(center.dx+math.cos(phase*math.pi*2)*68,center.dy+math.sin(phase*math.pi*2)*35);c.drawCircle(dot,3,Paint()..color=alt?lime:violet);}
 @override bool shouldRepaint(covariant OrbitMark o)=>o.alt!=alt||o.phase!=phase;
}
class PointerShape extends CustomPainter{final bool alt;PointerShape(this.alt);@override void paint(Canvas c,Size s){final path=Path()..moveTo(2,1)..lineTo(2,27)..lineTo(9,21)..lineTo(14,33)..lineTo(19,30)..lineTo(14,18)..lineTo(25,18)..close();c.drawPath(path,Paint()..color=Colors.black..style=PaintingStyle.stroke..strokeWidth=3);c.drawPath(path,Paint()..color=(alt?lime:Colors.white)..style=PaintingStyle.fill);}@override bool shouldRepaint(covariant PointerShape o)=>o.alt!=alt;}
