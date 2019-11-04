import 'dart:math';

import 'package:chika/RedditPost.dart';
import 'package:chika/api/oauth.dart';
import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'home.dart';

void main() async {
  await RedditClient().setup();
  runApp(App());
}

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        '/frontpage': (_) => Home(),
        '/': (_) => Login()
      },
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        primaryColor: Colors.orange[600],
        accentColor: Colors.orange[800],
        brightness: Brightness.dark
      ),
      theme: ThemeData(
        primaryColor: Colors.orange[600],
        accentColor: Colors.orange[800],
        brightness: Brightness.light
      ),
    );
  }


}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {

  var loggedIn = false;
  Uri url;
  var reddit;

  void _doOauth() async {
    String authCode = "";

    if(!reddit.auth.isValid) {

      if(url == null){
        url = reddit.auth.url(['*'],"${Random(21930).nextInt(100000)}", compactLogin: true);
      }

      flutterWebViewPlugin.launch(url.toString(), allowFileURLs: true);

      Observable<String>(flutterWebViewPlugin.onUrlChanged)
          .map((val) => Uri.parse(val))
          .where((val) => val.toString().contains("chika://oauth"))
          .listen((data) async {
        print(data);
        if(data.queryParameters["code"] != null) {
          flutterWebViewPlugin.close();
          if(!loggedIn){
            await reddit.auth.authorize(data.queryParameters["code"]);
            loggedIn = true;
          }
          setState(() {});
          RedditClient().saveCreds();
          await RedditClient().setMe();
          Navigator.pushReplacementNamed(context, "/frontpage");
        }
        else {
          flutterWebViewPlugin.close();
        }
      });
    }
    else {
      await RedditClient().setMe();
      Navigator.pushReplacementNamed(context, "/frontpage");
    }
  }

  @override
  void initState() {
    super.initState();
    reddit = RedditClient().reddit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => setState(() {

            }),
          )
        ],
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () => _doOauth(),
          color: Theme.of(context).primaryColor,
          child: FutureBuilder(
              future: reddit.user.me(),
              builder: (ctx, AsyncSnapshot<Redditor> snapshot) {
                if(snapshot.hasData) {
                  return Text(snapshot.data.displayName);
                }
                else
                  return Text("Login");
              }
          ),
        ),
      ),
    );
  }
}