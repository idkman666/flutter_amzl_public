import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_amzl_proto/Service/authenticationService.dart';
class SingnInPage extends StatefulWidget {
  @override
  _SingnInPageState createState() => _SingnInPageState();
}

class _SingnInPageState extends State<SingnInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText("AMZL PROTO",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 55),
              maxLines: 1,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
                child: signInCard()
            ),
            ElevatedButton(onPressed: (){

              context.read<AuthenticationService>().singIn(email: emailController.text.trim(), password: passwordController.text.trim());
            }, child: Text("SUBMIT"),

            )
          ],
        ) ,
      ),
    );
  }

  Widget signInCard(){
    return Card(
      elevation: 8,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: "Email"
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password"
              ),
            ),
          ),
        ],
      ),
    );
  }
}
