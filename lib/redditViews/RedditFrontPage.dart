import 'package:chika/api/oauth.dart';
import 'package:chika/redditViews/RedditListView.dart';
import 'package:chika/redditViews/SubredditPage.dart';
import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class RedditFrontPage extends StatelessWidget {

  final reddit = RedditClient().reddit;

  final _formKey = GlobalKey<FormState>();
  String _requestedSub;

  _askForSubreddit(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Please enter subreddit name"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextFormField(
                  validator: (val) {
                    if(val.startsWith("r/"))
                      return "Name without the r/";
                    if(val == "")
                      return "Write Something...";
                    return null;
                  },
                  onSaved: (val) {
                    _requestedSub = val;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () {
                      if(_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => SubredditPage(_requestedSub)));
                      }
                    },
                    child: Text("Go", style: TextStyle(color: Theme.of(context).primaryColor,),),
                  ),
                )
              ],
            ),
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chika"),
          actions: <Widget>[],
        ),
        drawer: new Drawer(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).accentColor,
                        ],
                      )
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black87,
                                  spreadRadius: 1,
                                  blurRadius: 30
                              )
                            ]
                        ),
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(90),
                          child: Image.network(
                            RedditClient().me.iconImg,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                            RedditClient().me.displayName,
                            style: TextStyle(
                                fontSize: 20,
                            )
                        ),
                      ),
                    ],
                  )
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Text("Goto Subreddit"),
                      onTap: () => _askForSubreddit(context),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        body: RedditListView(
          initalObservable: reddit.front.best(limit: 10),
          loadMoreObservable: (postOffset) => reddit.front.best(limit: 10, after: postOffset),
        )
    );;
  }
}
