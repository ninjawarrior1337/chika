import 'package:chika/api/oauth.dart';
import 'package:chika/redditViews/RedditListView.dart';
import 'package:draw/draw.dart';
import 'package:flutter/material.dart';

class SubredditPage extends StatelessWidget {
  final String subredditName;
  final Reddit _reddit = RedditClient().reddit;

  SubredditPage(this.subredditName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("r/$subredditName"),
      ),
      body: RedditListView(
        initalObservable: _reddit.subreddit(subredditName).hot(),
        loadMoreObservable: (postOffset) => _reddit.subreddit(subredditName).hot(after: postOffset),
      ),
    );
  }
}
