import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_app/utils/todolist.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();

 await Hive.initFlutter();
 await Hive.openBox('mybox');

 runApp(const MyApp());
}

final box = Hive.box('mybox');

class MyApp extends StatefulWidget {
 const MyApp({super.key});

 @override
 State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 final _controller = TextEditingController();
 List toDOList = [];

 void checkBoxChanged(int index) {
   setState(() {
     toDOList[index][1] = !toDOList[index][1];
   });
   box.put('TODOList', toDOList);
 }

 @override
 void initState() {
   super.initState();
   toDOList = box.get('TODOList') ?? [];
 }

 void saveNewtask() {
   final task = _controller.text.trim();
   if (task.isEmpty) return;

   setState(() {
     toDOList.add([task, false]);
   });
   box.put('TODOList', toDOList);
   _controller.clear();
 }

 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     theme: ThemeData(
       scaffoldBackgroundColor: const Color(0xFFF5F5F5),
       appBarTheme: const AppBarTheme(
         backgroundColor: Color(0xFFE0E0E0),
         foregroundColor: Color(0xFF212121),
         elevation: 0,
       ),
       colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
     ),
     home: Scaffold(
       backgroundColor: const Color(0xFFF5F5F5),
       appBar: AppBar(
         title: const Text('Simple TO DO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
         centerTitle: true,
       ),
       body: Padding(
         padding: const EdgeInsets.only(top: 12, bottom: 110),
         child: ListView.builder(
           itemCount: toDOList.length,
           itemBuilder: (BuildContext context, index) {
             return Todolist(
               taskName: toDOList[index][0],
               taskCompleted: toDOList[index][1],
               onChanged: (value) => checkBoxChanged(index),
               deleteFunction: (value) {
                 setState(() {
                   toDOList.removeAt(index);
                 });
                 box.put('TODOList', toDOList);
               },
             );
           },
         ),
       ),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
       floatingActionButton: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 18),
         child: Row(
           children: [
             Expanded(
               child: Container(
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(18),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.black.withOpacity(0.05),
                       blurRadius: 12,
                       offset: const Offset(0, 4),
                     ),
                   ],
                 ),
                 child: TextField(
                   controller: _controller,
                   decoration: InputDecoration(
                     hintText: 'Add a task',
                     hintStyle: const TextStyle(color: Colors.grey),
                     filled: true,
                     fillColor: Colors.white,
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(18),
                       borderSide: BorderSide.none,
                     ),
                     contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                   ),
                 ),
               ),
             ),
             const SizedBox(width: 12),
             FloatingActionButton(
               backgroundColor: const Color(0xFF616161),
               foregroundColor: Colors.white,
               onPressed: saveNewtask,
               child: const Icon(Icons.add),
             ),
           ],
         ),
       ),
     ),
   );
 }
}


