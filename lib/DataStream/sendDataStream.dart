import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_amzl_proto/Controller/databaseController.dart';
import 'package:flutter_app_amzl_proto/Model/routeModel.dart';
import 'package:flutter_app_amzl_proto/Pages/routeCards.dart';

class DataStream extends StatefulWidget {
  @override
  _DataStreamState createState() => _DataStreamState();
}

class _DataStreamState extends State<DataStream> {

  @override
  void initState()
  {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RouteModel>>(
      future: DatabaseController().getRouteDataAsync(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active)
          {
            List<RouteModel> routes = snapshot.data;
            return ListView.builder(
                itemCount: routes.length,
                itemBuilder: (context, index){
                  return RouteCards(routeModel: routes[index],);
                });
          }else if(snapshot.connectionState == ConnectionState.none)
            {
              print("Connection to Database has been terminated");
            }
        return Container(
          child: Text("Data not ready yet!!"),
        );
      },
    );
  }

//  Future<RouteModel> mapRouteModel async(DataSnapshot snapshot){
//    return RouteModel.fromMap(snapshot.value[])
//  }
}
