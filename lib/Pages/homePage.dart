import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_amzl_proto/Controller/databaseController.dart';
import 'package:flutter_app_amzl_proto/Globals/globalValues.dart';
import 'package:flutter_app_amzl_proto/Pages/dashboardPage.dart';
import 'package:flutter_app_amzl_proto/Pages/menuOverviewPage.dart';
import 'package:flutter_app_amzl_proto/Pages/searchDashboardPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getDataFromDatabase();
  }

  Future<void> getDataFromDatabase()async{
    GlobalValues.routeDataGlobal = await DatabaseController().getRouteDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            ButtonTheme(
              minWidth: 100,
              height: 100,
              child: RaisedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (c)=> SearchDashboardPage()));
              },
                  child: Icon(Icons.search, size: 130 )),
            ),
            SizedBox(height: 20,),
            ButtonTheme(
              minWidth: 100,
              height: 100,
              child: ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (c)=>MenuOverviewPage()));
              },
                  child: Icon(Icons.menu, size: 130 )
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
                logOut();
            }, child: Text("Log Out")),

          ],
          ),
        ),
      );
  }

  Future<void> logOut() async{
    await FirebaseAuth.instance.signOut();
  }
}
