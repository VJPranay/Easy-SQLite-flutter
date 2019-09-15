import 'package:flutter/material.dart';
import 'package:unfortunate/myDbModel.dart';
import 'package:unfortunate/models.dart';
import 'dart:math';

void main() => runApp(Root());

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var data;

  initialCheck() async {
    final bool isInitialized = await MyDbModel().initializeDB();
    if (isInitialized == true) {
      print("The database is ready for use");
    }
  }

  addData() async {
    var todo = Todo();
    todo.userId = 3;
    todo.title = "test ${Random().nextInt(100)}";
    todo.completed = true;
    final newId = await todo.save();
    getData();
  }

  getData() async {
    final bool isInitialized = await MyDbModel().initializeDB();
    if (isInitialized == true) {
      var dummy = await Todo().select().top(20).toList();
      setState(() {
        data = dummy;
      });
    }
  }

  updateData() async{
    final result = await Todo().select().id.equals(1).update({"title": "updated value"});
    print(result.toString());
    getData();
  }

  deleteData() async{

    var dummy = await Todo().select().delete();
    print(dummy.toString());
    getData();
  }

  deleteSingleData(index) async{
    var dummy = await Todo().select().id.equals(index).delete();
    print(dummy.toString());
    getData();
  }

  syncDataFromWeb() async {
    final todosList =
    await Todo.fromWebUrl("https://jsonplaceholder.typicode.com/todos");
    print(todosList.length);
    await Todo().saveAll(todosList);
    print(todosList);
    getData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SQFLite")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: RaisedButton(
                onPressed: () {
                  getData();
                },
                child: Text("Retrive"),
              ),
            ),
            Center(
              child: RaisedButton(
                onPressed: () {
                  addData();
                },
                child: Text("Create"),
              ),
            ),Center(
              child: RaisedButton(
                onPressed: () {
                  updateData();
                },
                child: Text("Update"),
              ),
            ),Center(
              child: RaisedButton(
                onPressed: () {
                  deleteData();
                },
                child: Text("Delete"),
              ),
            ),Center(
              child: RaisedButton(
                onPressed: () {
                  syncDataFromWeb();
                },
                child: Text("Get data from the web"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: data == null
                  ? CircularProgressIndicator()
                  : new ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return ListTile(
                          title: Text(data[index].title),
                          trailing: IconButton(
                            onPressed: () {
                              deleteSingleData(data[index].id);
                            },
                            icon: Icon(
                              Icons.delete,
                            ),
                          ),
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }
}
