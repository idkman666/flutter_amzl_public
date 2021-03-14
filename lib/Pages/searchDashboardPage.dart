import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_amzl_proto/Controller/databaseController.dart';
import 'package:flutter_app_amzl_proto/Model/routeModel.dart';
import 'package:flutter_app_amzl_proto/Pages/routeCards.dart';

class SearchDashboardPage extends StatefulWidget {
  @override
  _SearchDashboardPageState createState() => _SearchDashboardPageState();
}

class _SearchDashboardPageState extends State<SearchDashboardPage> {
  TextEditingController _searchController = TextEditingController();
  List<RouteModel> allRoutes = [];
  HashMap<String, RouteModel> cxToRouteMap = HashMap<String, RouteModel>();
  bool isSearchFieldEmpty = true;
  List<RouteModel> searchResults = [];
  bool _isNameSearch = false;
  FocusNode _focusNode = new FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _focusNode.addListener(_onFocusChange);
    getDatabase();
  }

  void _onFocusChange(){
    print("focus status" + _focusNode.hasFocus.toString());
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _focusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _onSearchChanged() {
    if(_searchController.text != ""  || _searchController.text != null)
      {
        setState(() {
          isSearchFieldEmpty = false;
        });
      }else
        {
          setState(() {
            isSearchFieldEmpty = true;
          });
        }
    print(_searchController.text);
  }

  Future<void> getDatabase() async {
    // // allRoutes = await DatabaseController().getRouteDataAsync();
    // Stream<QuerySnapshot> snapShotQuery = FirebaseFirestore.instance.collection("RouteList").snapshots();
    // //putting data in hashmap with cx as key
    //
    // snapShotQuery.forEach((element) {
    //   print(element);
    // });
    // allRoutes.forEach((element) {
    //   cxToRouteMap[element.cx.toString().toLowerCase()] = element;
    // });
    // print("database extraction complete");
    //var datafromDB = DatabaseController().getRouteData();
    //print(datafromDB);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search for CX number"),
      ),
      backgroundColor: Colors.grey,
      body: Padding(
        padding: EdgeInsets.all(2),
        child: Column(
          children: [
            searchContainer(),
            SizedBox(
              height: 3,
            ),
            Flexible(
              flex: 5,
              fit: FlexFit.loose,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("RouteList")
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> snapshotData) {
                    if (snapshotData.connectionState ==
                        ConnectionState.active ||
                        snapshotData.connectionState == ConnectionState.done) {
                      return ListView.builder(
                          itemCount: snapshotData.data.docs.length,
                          itemBuilder: (context, index) {
                            List<QueryDocumentSnapshot> docs =
                                snapshotData.data.docs;
                            return RouteCards(
                              docId: isSearchFieldEmpty
                                  ? (docs[index] == null ? "" : docs[index].id)
                                  : (_isNameSearch ? (searchSnapshotWithName(docs[index],
                                  _searchController.text) ==
                                  null
                                  ? ""
                                  : searchSnapshotWithName(docs[index],
                                  _searchController.text)
                                  .id) :(searchSnapshot(docs[index],
                                  _searchController.text) ==
                                  null
                                  ? ""
                                  : searchSnapshot(docs[index],
                                  _searchController.text)
                                  .id)),
                              ds: isSearchFieldEmpty
                                  ? docs[index]
                                  : _isNameSearch ? (searchSnapshotWithName(
                                  docs[index], _searchController.text)) :(searchSnapshot(
                                  docs[index], _searchController.text)),
                            );
                          });
                    }
                    return Text("Loading...");
                  }),
            )
          ],
        ),
      ),
    );
  }

  String CX = "cx";

  DocumentSnapshot searchSnapshot(DocumentSnapshot ds, String searchedField) {
    if (ds["Cx"]
        .toString()
        .toLowerCase()
        .contains(CX + searchedField.toLowerCase())) {
      return ds;
    }
    return null;
  }

  DocumentSnapshot searchSnapshotWithName(
      DocumentSnapshot ds, String searchedField) {
    if (ds["Name"]
        .toString()
        .toLowerCase()
        .contains(searchedField.toLowerCase())) {
      return ds;
    }
    return null;
  }

  Widget searchContainer() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: TextField(
                focusNode: _focusNode,
                controller: _searchController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search), hintText: _isNameSearch ? "Name" : "Cx Number"),
                keyboardType: _isNameSearch==true ? TextInputType.text : TextInputType.number,
              ),
            ),
            SizedBox(
              width: 40,
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    if(!_isNameSearch)
                    {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _isNameSearch = true;
                    }else
                    {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _isNameSearch = false;
                    }
                    print("is name search" + _isNameSearch.toString());
                  });
                },
                child: _isNameSearch
                    ? Icon(Icons.directions_bus)
                    : Icon(Icons.person),
              ),
            )
          ]),
        ],
      ),
    );
  }
}
