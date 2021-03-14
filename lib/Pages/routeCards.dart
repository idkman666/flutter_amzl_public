import 'dart:collection';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_amzl_proto/Model/routeModel.dart';

class RouteCards extends StatefulWidget {
  final RouteModel routeModel;
  final DocumentSnapshot ds;
  final String docId;

  RouteCards({this.routeModel, this.ds, this.docId});

  @override
  _RouteCardsState createState() => _RouteCardsState();
}

class _RouteCardsState extends State<RouteCards>
    with AutomaticKeepAliveClientMixin {
  bool _isCheckedIn = false;
  String _buttonStatus = "CHECK IN";

  //DatabaseReference dbReference = FirebaseDatabase.instance.reference().child("Routes/");
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("RouteList");
  HashMap<String, Color> cardColors = new HashMap<String, Color>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeColors();
  }

  initializeColors() {
    cardColors["dropped"] = Colors.red;
    cardColors["waiting"] = Colors.white;
    cardColors["checked in"] = Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    DocumentSnapshot _routeModel = widget.ds;
    String docId = widget.docId;
    return _routeModel == null
        ? SizedBox.shrink()
        : Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              color: cardColors[_routeModel["Status"].toString().toLowerCase()],
              elevation: 8.0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                Column(
                  children: [
                    cxContainer(_routeModel),
                    routeStatus(_routeModel)
                  ],
                ),
                Column(
                  children: [
                    waveContainer(_routeModel),
                    _routeModel["Status"].toString().toLowerCase() == "waiting" ? checkInButton(docId, context) : SizedBox(height: 30,)
                  ],
                )
              ]),
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;

  // Future<void> onCheckInPressed(DatabaseReference id, RouteModel updatedStatus) async{
  //   setState(() {
  //     _isCheckedIn = true;
  //   });
  //   DatabaseController().checkInDriver(id, updatedStatus);
  // }
  Future<void> onCheckInPressed(
      String docId, Map<String, dynamic> routeModel, context) async {
    await collectionReference
        .doc(docId)
        .update(routeModel)
        .then((value) => print("UPDATE SUCCESS"))
        .catchError((onError) => print("UPDATE FAILED"));
    cancelPressed(context);
  }

  void showBottomMenu(docId)
  {
    showModalBottomSheet(context: context, builder: (context){
      return Container(
        height: 150,
        child: Column(
          children: [
            AutoSizeText("Are you sure?",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  //cancel button
                  padding: EdgeInsets.only(left: 0, right: 0.0),
                  child: RaisedButton(
                    textColor: Colors.black,
                    color: Colors.redAccent,
                    child: Text("CANCEL"),
                    onPressed: () {
                        cancelPressed(context);
                    },
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(100.0),
                    ),
                  ),
                ),
                Padding(
                  //Check in button
                  padding: EdgeInsets.only(left: 0, right: 0.0),
                  child: RaisedButton(
                    textColor: Colors.black,
                    color: Colors.greenAccent,
                    child: Text("YES"),
                    onPressed: (){

                        Map<String, dynamic> updatedData = {"Status": "CHECKED IN"};
                        onCheckInPressed(docId, updatedData,context);

                    },
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(100.0),
                    ),
                  )
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  void cancelPressed(context)
  {
    Navigator.pop(context);
  }

  Widget waveContainer(_routeModel) {
    return Card(
      elevation: 10,
      child: Container(
        margin: EdgeInsets.all(5),
        height: 170,
        width: 150,
        child: Column(
          children: [
            AutoSizeText(
              "WAVE",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              maxLines: 1,
            ),
            SizedBox(
              height: 6,
            ),
            AutoSizeText(
              _routeModel["Wave"].toString().toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 65),
              maxLines: 1,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText(
                    "Dsp: " + _routeModel["Dsp"].toString(),
                    style: TextStyle(fontSize: 10),
                  ),
                  AutoSizeText(
                    "Name: " + _routeModel["Name"].toString(),
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget cxContainer(_routeModel) {
    return Card(
      elevation: 10,
      child: Container(
        margin: EdgeInsets.all(5),
        height: 170,
        width: 150,
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: AutoSizeText(
                _routeModel["Cx"].toString().toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 65),
                maxLines: 1,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            zoneContainer(_routeModel),
          ],
        ),
      ),
    );
  }

  Widget checkInButton(docId,context)
  {
    return Container(
      height: 30,
      child: Padding(
        padding: EdgeInsets.only(left: 18.0, right: 0.0),
        child: RaisedButton(
          textColor: Colors.black,
          color: Colors.lightBlueAccent,
          child: Text("Check In"),
          onPressed: () {
            showBottomMenu(docId);
          },
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }

  Widget zoneContainer(_routeModel) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: AutoSizeText(
              "ZONE:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              maxLines: 1,
            ),
          ),
          Container(
            height: 80,
            child: AutoSizeText(
              _routeModel["Zone"].toString().toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                  fontFamily: "RobotoMono"),
            ),
          )
        ],
      ),
    );
  }

  Widget routeStatus(_routeModel) {
    return Container(
      width: 150,
      alignment: Alignment.center,
      padding: EdgeInsets.all(2),
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: AutoSizeText(
        _routeModel["Status"].toString().toUpperCase(),
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            fontFamily: "RobotoMono"),
        maxLines: 1,
      ),
    );
  }
}
