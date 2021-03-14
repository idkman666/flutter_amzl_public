import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_amzl_proto/Model/routeModel.dart';


class DatabaseController{
  // DataSnapshot _dbReference;
  // StreamSubscription<Event> _dataStreamSubscription;
  // DatabaseError _dbError;
  // Map<String, dynamic> datavalue;
  // int dataCount = 0 ;



  Future <List<RouteModel>> getRouteDataAsync () async
  {
    List<RouteModel> _routesFromDb = [];
//     _dbReference = await FirebaseDatabase.instance.reference().child('Routes').orderByChild("Wave").once();
//     FirebaseDatabase.instance.reference().child("Routes/").keepSynced(true);
//
//     final FirebaseDatabase database = FirebaseDatabase.instance;
//     database.setPersistenceCacheSizeBytes(1000000);
//     database.setPersistenceEnabled(true);
//
// /*    _dataStreamSubscription = _dbReference.onValue.listen((event) {
//       datavalue = Map<String,dynamic>.from( event.snapshot.value);
//       datavalue.forEach((key, value) {
//         RouteModel routeModel =  new RouteModel(dsp: value["Dsp"], name: value["Name"], wave: value["Wave"], id: value["Id"], status: value["Status"]);
//         _routesFromDb.add(routeModel);
//       });
//     });*/
//     if(_dbReference.value != null )
//       {
//         datavalue = Map<String,dynamic>.from( _dbReference.value);
//         datavalue.forEach((key,value){
//           RouteModel routeModel =  new RouteModel(cx: value["Cx"], dsp: value["Dsp"], name: value["Name"], wave: value["Wave"], id: value["Id"], status: value["Status"]);
//           _routesFromDb.add(routeModel);
//         });
//       }
//     globals.GlobalValues.routeDataGlobal = _routesFromDb;
    return _routesFromDb;
  }

  // Future<void> checkInDriver (DatabaseReference id, RouteModel updatedStatus)async{
  //   id.update(updatedStatus.toJson());
  // }

  //Firestore calls
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
 Future <List<RouteModel>> getRouteData() async {

    List<RouteModel> routeList = [];
    try{
      Stream<QuerySnapshot> collectionReference = _firestore.collection('RouteList').snapshots();

      collectionReference.forEach((element) {
        element.docs.forEach((element) {
          var data = element.data();
          RouteModel _routeModel = RouteModel(cx: data["Cx"], dsp: data["Dsp"], wave: data["Wave"], id: element.id , status: data["Status"], name: data["Name"], zone: data["Zone"] );
          routeList.add(_routeModel);
        });
      });


    }catch(e)
    {
      print("error:" + e);
    }

    return routeList;
  }

}
