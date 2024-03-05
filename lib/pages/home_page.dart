import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:motion_toast/motion_toast.dart';

import '../data/database.dart';
import '../util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // if this is the 1st time ever openin the app, then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose(); // Membersihkan controller saat widget dihapus
    super.dispose();
  }

  // text controller
  final _controller = TextEditingController();

  // checkbox was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
    MotionToast toast = MotionToast.success(
      title: const Text(
        'Succes!',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: const Text(
        'a task Added',
        style: TextStyle(fontSize: 12),
      ),
      layoutOrientation: ToastOrientation.rtl,
      animationType: AnimationType.fromBottom,
      dismissable: true,
    );
    toast.show(context);
    Future.delayed(const Duration(seconds: 4)).then((value) {
      toast.closeOverlay();
    });
  }

  // create a new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0), // Spasi horizontal
          child: AlertDialog(
            title: Text('Add New Task'),
            content: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter task name', // Hint untuk input teks
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    saveNewTask();
                  } else {
                    MotionToast.warning(
                      title: const Text(
                        'Warning,',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      description: const Text('Please enter a task name'),
                      animationCurve: Curves.bounceIn,
                      borderRadius: 0,
                      animationDuration: const Duration(milliseconds: 1000),
                    ).show(context);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue, // Warna latar belakang tombol
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
    MotionToast.delete(
      title: const Text(
        'Deleted',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text('The task deleted'),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.bottom,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Warna teks untuk bagian 'May'
            ),
            children: [
              TextSpan(text: 'May '),
              TextSpan(
                text: 'List',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey, // Warna teks untuk bagian 'List'
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Image.asset(
          'assets/add.gif',
          height: 32,
          width: 32,
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: db.toDoList.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
            );
          },
        ),
      ),
    );
  }
}
