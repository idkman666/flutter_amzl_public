import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_amzl_proto/Pages/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_amzl_proto/Pages/singnInPage.dart';
import 'package:flutter_app_amzl_proto/Service/authenticationService.dart';
import 'package:provider/provider.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseApp app = await Firebase.initializeApp(
      name: 'db',
      options:  FirebaseOptions(
        appId: '1:108823766589:android:b83190acb34f7a789b6c54',
        apiKey: 'AIzaSyCPtT2tsWoynYl5DDzWE58bYwOzpBPsMFM',
        projectId: 'protoamzl',
        messagingSenderId: "108823766589",
      )
  );
  print("Firebase DB set");
  runApp(MyApp(app));
}

class MyApp extends StatelessWidget {
  final FirebaseApp app;
  MyApp(this.app);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Morning Dispatch', app: app,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final FirebaseApp app;
  MyHomePage({Key key, this.title, this.app}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: MultiProvider(
              providers: [
                Provider<AuthenticationService>(
                  create: (e) => AuthenticationService(FirebaseAuth.instance),
                ),
                StreamProvider(create: (e) => e.read<AuthenticationService>().authStateChanges)
              ],
              child: AuthenticationWrapper()
          ),
        ),
            // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  } 
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if(firebaseUser != null)
      {
        //return home
        return HomePage();
      }
    return SingnInPage();
  }
}


