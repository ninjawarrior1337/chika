import 'dart:io';
import 'dart:math';

import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

final flutterWebViewPlugin = FlutterWebviewPlugin();

class RedditClient
{
  Reddit reddit;
  File credsFile;
  Redditor me;

  static final RedditClient _singleton = RedditClient._internal();

  factory RedditClient() {
    return _singleton;
  }

  RedditClient._internal();

  Future<void> setup() async {
    await setupCreds();
    setupAuth();
  }

  setMe() async {
    me = await reddit.user.me();
  }

  void setupAuth()
  {
    if(this.credsFile.existsSync() && this.credsFile.readAsStringSync() != "") {
      final contents = this.credsFile.readAsStringSync();
      this.reddit = Reddit.restoreInstalledAuthenticatedInstance(
        contents,
        userAgent: "chika",
        clientId: "2K4pRT05EJN9QA",
        redirectUri: Uri.parse("chika://oauth"),
      );
    }
    else {
      this.reddit = Reddit.createInstalledFlowInstance(
        userAgent: "chika",
        clientId: "2K4pRT05EJN9QA",
        redirectUri: Uri.parse("chika://oauth"),
      );
    }
  }

  Future<void> setupCreds() async {
    final dir = await getApplicationDocumentsDirectory();
    this.credsFile = File("${dir.path}/creds.json");
  }

  void saveCreds() {
    this.credsFile.writeAsStringSync(this.reddit.auth.credentials.toJson());
  }
}

