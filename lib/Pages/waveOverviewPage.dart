import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_amzl_proto/Pages/routeCards.dart';
class WaveOverviewPage extends StatefulWidget {
  final int waveNumber;
  final String waveName;
  WaveOverviewPage({this.waveNumber, this.waveName});
  @override
  _WaveOverviewPageState createState() => _WaveOverviewPageState();
}

class _WaveOverviewPageState extends State<WaveOverviewPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    int waveNumber = widget.waveNumber;
    return Scaffold(
      appBar: AppBar(title: Text(widget.waveName.toUpperCase())),
      backgroundColor: Colors.white12,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("RouteList").snapshots() ,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done){
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index){
                List<QueryDocumentSnapshot> docs = snapshot.data.docs;
                if(docs[index]["Wave"] == waveNumber )
                  {
                    return RouteCards(ds: docs[index], docId: docs[index].id);
                  }
                return SizedBox.shrink();
            }

            );
          }
          return Text("Loading...");
        },

      ),
    );
  }
}
