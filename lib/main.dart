import 'Api.dart';
import 'package:flutter/cupertino.dart';
import 'User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Firestore',
      home: FireBaseFireStoreDemo(),
    );
  }
}

class FireBaseFireStoreDemo extends StatefulWidget{
  
  final String title="User Cloud FireStore";
  @override
  State<StatefulWidget> createState() =>FireBaseFireStoreDemoState();

}

class FireBaseFireStoreDemoState extends State<FireBaseFireStoreDemo>{

  bool showTextField =false;
  TextEditingController controller = TextEditingController();
  String collectionName = 'Users';
  bool isEditing=false;
  User curUser;
  Api api=new Api();

  Widget buildBody(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: api.getUsers(),
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Text('Error ${snapshot.error}');
        }
        if(snapshot.hasData){
          print('Document ${snapshot.data.documents.length}');
          return buildList(context, snapshot.data.documents);
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget buildList(BuildContext context,List<DocumentSnapshot> snapshot){
    return ListView(
      children: snapshot.map((data) => buildListItem(context,data)).toList(),
    );
  }

  Widget buildListItem(BuildContext context,DocumentSnapshot data){
    final user = User.fromSnapshot(data);
    return Padding(
      key: ValueKey(user.name),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(user.name),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: (){
              api.delete(user);
            },
          ),
          onTap: (){
            setUpdateUI(user);
          },
        ),
      ),
    );
  }

  setUpdateUI(User user){
    controller.text=user.name;
    setState(() {
      showTextField:true;
      isEditing=true;
      curUser=user;
    });
  }

  add(){
    if(isEditing){
      api.update(curUser, controller.text);
      setState(() {
        isEditing=false;
      });
    }else{
      api.addUser(controller.text);
    }
    controller.text="";
  }

  button(){
    return SizedBox(
      width: double.infinity,
      child: OutlineButton(
        child: Text(isEditing ? "Update" : "Add"),
        onPressed: (){
          add();
          setState(() {
            showTextField=false;
          });
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              setState(() {
                showTextField= !showTextField;
              });
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            showTextField 
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Enter Name"
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                button(),
              ],
            )
                : Container(),
            SizedBox(
              height: 20,
            ),
            Text(
              "USERS",
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900),
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: buildBody(context),
            )
          ],
        ),
      ),
    );
  }

}

