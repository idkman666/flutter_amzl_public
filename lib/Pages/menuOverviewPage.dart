import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_amzl_proto/Pages/waveOverviewPage.dart';

class MenuOverviewPage extends StatefulWidget {
  @override
  _MenuOverviewPageState createState() => _MenuOverviewPageState();
}

class _MenuOverviewPageState extends State<MenuOverviewPage> {
  Map<int,int> waitingMap = new Map<int,int>();
  Map<int,int> checkedInMap = new Map<int,int>();
  Map<int,int> droppedMap = new Map<int,int>();
  Map<int, int> waitingCountForWave = new Map<int,int>();
  Map<int, int> droppedCountForWave = new Map<int,int>();
  Map<int, int> checkedInCountForWave = new Map<int,int>();
  Map<String, Map<int,int>> countMap = new Map<String, Map<int,int>>();
  Map<String, Map<int,int>> valueMap = new Map<String, Map<int,int>>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countMap["WAITING"] = waitingMap;
    countMap["CHECKED IN"] = checkedInMap;
    countMap["DROPPED"] = droppedMap;
    initializeWaveCounts();
    getData();
  }

  void initializeWaveCounts()
  {
    int waveLength = 5;
    List<String> statusList = ["WAITING", "CHECKED IN", "DROPPED"];
    List<Map<int,int>> mapList = [waitingCountForWave, checkedInCountForWave, droppedCountForWave];
    for(int i = 0 ; i < statusList.length  ; i++)
      {
        valueMap[statusList[i]] = mapList[i];
      }

    //initializing every wave for every status to 0
    for(int i = 1 ; i< waveLength + 1 ; i++ )
      {
        waitingCountForWave[i] = 0;
        checkedInCountForWave[i] = 0;
        droppedCountForWave[i] = 0;
      }
  }

  Future <void> getData() async
  {
    await FirebaseFirestore.instance.collection("RouteList").get().then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        setData(doc);
      })
    });
    print(waitingMap.length);
  }

  void setData(doc)
  {
    switch(doc["Wave"])
    {
      case 1:
        setStatusCount(doc["Wave"],"WAITING", doc);
        setStatusCount(doc["Wave"],"DROPPED", doc);
        setStatusCount(doc["Wave"],"CHECKED IN", doc);
        break;
      case 2:
        setStatusCount(doc["Wave"],"WAITING", doc);
        setStatusCount(doc["Wave"],"DROPPED", doc);
        setStatusCount(doc["Wave"],"CHECKED IN", doc);
        break;
      case 3:
        setStatusCount(doc["Wave"],"WAITING", doc);
        setStatusCount(doc["Wave"],"DROPPED", doc);
        setStatusCount(doc["Wave"],"CHECKED IN", doc);
        break;
      case 4:
        setStatusCount(doc["Wave"],"WAITING", doc);
        setStatusCount(doc["Wave"],"DROPPED", doc);
        setStatusCount(doc["Wave"],"CHECKED IN", doc);
        break;
      case 5:
        setStatusCount(doc["Wave"],"WAITING", doc);
        setStatusCount(doc["Wave"],"DROPPED", doc);
        setStatusCount(doc["Wave"],"CHECKED IN", doc);
        break;
      default:
        break;
    }
  }

  void setStatusCount(waveNo, status, doc)
  {
    //get type of status being counted
    Map<int,int> _map = countMap[status];
    if(doc["Status"] == status)
    {
      setState(() {
        countMap[status][waveNo] = ++valueMap[status][waveNo];
      });
    }
  }


  String title = "Waves";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title.toUpperCase()),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            waveButton("wave 1",1),
            waveButton("wave 2",2),
            waveButton("wave 3",3),
            waveButton("wave 4",4),
            waveButton("wave 5",5)
          ],
        ),
      ),
      backgroundColor: Colors.blueGrey,
    );
  }
  
  Widget waveButton(waveName, waveNumber)
  {
    return Card(
      elevation: 12,
      color: Colors.blue,
      child: InkWell(
        onTap: (){
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => WaveOverviewPage(waveName: waveName, waveNumber: waveNumber))
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.90,
          height: MediaQuery.of(context).size.height * 0.15,
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Text(waveName.toString().toUpperCase()),
              Row(
                children: [

                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget totalDrivers()
  {
    return Column(
      children: [
        AutoSizeText("TOTAL",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white10),
          maxLines: 1,
        )

      ],
    );
  }
  Widget checkedInTotal()
  {

  }
  Widget waitingTotal()
  {

  }
  Widget droppedTotal()
  {

  }
}
