import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_app/utils/todolist.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  await Hive.initFlutter();
  await Hive.openBox('mybox');

  runApp(MyApp());
}
 final box= Hive.box('mybox');
 

// ignore: must_be_immutable
class MyApp extends StatefulWidget{
  MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = TextEditingController();
  final TextEditingController searchController=TextEditingController();
  List toDOList = [];
  List filterdList=[];
  
  
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
    filterdList=List.from(toDOList);
  }

  void saveNewtask() {
    setState(() {
      toDOList.add([_controller.text, false]);
    });
    box.put('TODOList', toDOList);
  
    _controller.clear();

    
  }
   

void serachTasks(String value){
  setState(() {
    filterdList=toDOList.where((task){
      return task[0]
      .toString()
      .toLowerCase()
      .contains(value.toLowerCase());
    }).toList();
  });
}

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        
        backgroundColor: Colors.purple.shade400,
        appBar: AppBar(
          title: Text("Simple TO DO", style: TextStyle(fontSize: 15)),
          backgroundColor: const Color.fromARGB(255, 110, 2, 129),
          foregroundColor: Colors.white,
        
        ),
        
        body: ListView.builder(
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
                box.put("TODOList", toDOList);
              },
            );
          },
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Add a new todo items",
                      filled: true,
                      fillColor: Colors.deepPurple.shade200,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purple),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),
              FloatingActionButton(
                 child: Icon(Icons.add),
                onPressed: () {
                  saveNewtask();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  

}


