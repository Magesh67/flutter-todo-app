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
         backgroundColor: Color.fromARGB(255, 107, 105, 105),
         foregroundColor: Colors.white,
         elevation: 0,
       ),
       colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
     ),
     home: Scaffold(
       backgroundColor: const Color.fromARGB(255, 184, 182, 182),
       appBar: AppBar(
         title: const Text('My Tasks', style: TextStyle(fontSize: 18, )),
         
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
                     hintText: 'Add a new task',
                     hintStyle: const TextStyle(color: Colors.grey),
                     filled: true,
                     fillColor: const Color.fromARGB(255, 105, 103, 103),
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
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


