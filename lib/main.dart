import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';

import 'util.dart';
import 'model/post_model.dart';
import 'services/post_service.dart';
import 'services/comment_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'please_give_me_job_:)',
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
        brightness : Brightness.light,
        primaryColor: Color.fromRGBO(191, 19, 19, 1),

        textTheme: TextTheme(
          headline: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 24.0, color : Color.fromRGBO(191, 19, 19, 1)),
          body1: TextStyle(fontSize: 14.0),
        ),
      ),
      home: MyHomePage(title : "ign_q4_app")
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  static const int PAGE_SIZE = 10;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
        length : 2,
        child : Scaffold(
          appBar: AppBar(
          ),
          body : Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                child : TabBar(
                  indicatorColor: Color.fromRGBO(191, 19, 19, 1),
                  labelColor: Color.fromRGBO(191, 19, 19, 1),
                  unselectedLabelColor: Color.fromRGBO(185, 194, 205, 1),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 4,
                  tabs : [
                    Text(
                      "ARTICLES",
                      style: TextStyle(
                        fontSize: 24
                      ),
                    ),
                    Text(
                      "VIDEOS",
                      style: TextStyle(
                        fontSize: 24
                      ),
                    )
                  ]
                )
              ),
                Expanded(
                  child : TabBarView(
                    children : [
                      Column(
                        children : [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children : [
                              Icon(Icons.arrow_left),
                              Text("Swipe Between Sections"),
                              Icon(Icons.arrow_right)
                            ]
                          ),
                          Divider(),
                          Expanded(
                            child : PagewiseListView(
                              pageSize: PAGE_SIZE,
                              itemBuilder: this._itemBuilder,
                              pageFuture : (pageIndex) => fetchPosts(pageIndex * PAGE_SIZE)
                            )
                          )
                        ]
                      ),
                      Column(
                        children : [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children : [
                              Icon(Icons.arrow_left),
                              Text("Swipe Between Sections"),
                              Icon(Icons.arrow_right)
                            ]
                          ),
                          Divider(),
                          Expanded(
                            child : PagewiseListView(
                              pageSize: PAGE_SIZE,
                              itemBuilder: this._videoItemBuilder,
                              pageFuture: (pageIndex) => fetchPosts(pageIndex * PAGE_SIZE),
                            )
                          )
                        ]
                      ),
                    ]
                  )
              )
            ],
          )
        ),
      );
  }

  Widget _itemBuilder(context, Post entry, _){
    if(entry.contentType == "article"){
          return Padding(
            padding :EdgeInsets.symmetric(
              horizontal: 10.0
            ),
            child : Column(
              children: <Widget>[
                GestureDetector(
                  onTap : (){
                    _createWebView(DateTime.parse(entry.metadata.publishDate), entry.metadata.slug);
                  },
                  child : Container(
                    margin:EdgeInsets.symmetric(
                      horizontal: 14.0
                    ),
                    child : Column(
                      children: <Widget>[
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              entry.metadata.howLongAgo + " ago",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                                entry.metadata.headline,
                                style : Theme.of(context).textTheme.headline
                            ),
                          ],
                        ),
                        Padding(
                          padding : EdgeInsets.symmetric(
                            vertical : 8.0
                          )
                        ),
                        Image.network(entry.thumbnails[0].url),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 4.0
                          ),
                        ),
                        Text(
                          entry.metadata.description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Color.fromRGBO(171, 170, 170, 1)
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 4.0
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Read",
                              style: TextStyle(
                                color: Color.fromRGBO(171, 170, 170, 1),
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            FutureBuilder(
                              future: fetchCommentCount(entry.contentID),
                              builder: (context, snapshot){
                                if(snapshot.hasData){
                                  return Text.rich(
                                      TextSpan(
                                        text: "Comment ",
                                        style: TextStyle(
                                          color: Color.fromRGBO(171, 170, 170, 1),
                                          fontWeight: FontWeight.bold
                                        ),
                                        children : <TextSpan>[
                                          TextSpan(
                                            text : snapshot.data.toString(),
                                            style : TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(93, 164, 208, 1)
                                            )
                                          )
                                        ]
                                      )
                                    );
                                } else if(snapshot.hasError){
                                  print(snapshot.error);
                                  return Text("${snapshot.error}");
                                }
                                return CircularProgressIndicator();
                              }
                            )
                          ],
                        ) 
                      ],
                    )
                  )
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                ),
                Divider(height: 3.0),
                Padding(
                  padding: EdgeInsets.all(16.0),
                )
              ],
            )
          );
    } else{
      return SizedBox(
      );
    }
  }

  Widget _videoItemBuilder(context, Post entry, _){
    if(entry.contentType == "video"){
          return Column(
            children: <Widget>[
              GestureDetector(
                onTap : (){
                  _createWebViewVideo(DateTime.parse(entry.metadata.publishDate), entry.metadata.slug);
                },
                child : Container(
                  margin:EdgeInsets.symmetric(
                      horizontal: 24.0
                  ),
                  child : Column(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            entry.metadata.howLongAgo + " ago",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor
                            ),
                          ),
                          Text(
                              entry.metadata.title,
                              style : Theme.of(context).textTheme.headline
                          ),
                        ],
                      ),
                      Padding(
                        padding : EdgeInsets.all(8.0)
                      ),
                      Container(
                        constraints: BoxConstraints.expand(
                          height : 200.0
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(entry.thumbnails[0].url),
                            fit:BoxFit.cover
                          )
                        ),
                        child:Icon(
                          Icons.play_circle_filled,
                          color : Theme.of(context).primaryColor,
                          size: 80.0,
                        )
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 4.0
                          ),
                        ),
                        Text(
                          entry.metadata.description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Color.fromRGBO(171, 170, 170, 1)
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 4.0
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Watch",
                              style: TextStyle(
                                color: Color.fromRGBO(171, 170, 170, 1),
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            FutureBuilder(
                              future: fetchCommentCount(entry.contentID),
                              builder: (context, snapshot){
                                if(snapshot.hasData){
                                  return Text.rich(
                                      TextSpan(
                                        text: "Comment ",
                                        style: TextStyle(
                                          color: Color.fromRGBO(171, 170, 170, 1),
                                          fontWeight: FontWeight.bold
                                        ),
                                        children : <TextSpan>[
                                          TextSpan(
                                            text : snapshot.data.toString(),
                                            style : TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(93, 164, 208, 1)
                                            )
                                          )
                                        ]
                                      )
                                    );
                                } else if(snapshot.hasError){
                                  print(snapshot.error);
                                  return Text("${snapshot.error}");
                                }
                                return CircularProgressIndicator();
                              }
                            )
                          ],
                        )
                    ],
                  )
                )
              ),
              Padding(
                padding: EdgeInsets.all(2.0),
              ),
              Divider(height: 3.0),
              Padding(
                padding: EdgeInsets.all(16.0),
              )
            ],
          );
    } else{
      return SizedBox(
      );
    }
  }

  void _createWebView(DateTime dt, String slug){
    String year = dt.year.toString();
    String month = dt.month < 10 ? "0" + dt.month.toString() : dt.month.toString();
    String day = dt.day < 10 ? "0" + dt.day.toString() : dt.day.toString();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context){
          return Scaffold(
            appBar: AppBar(

            ),
            body : WebView(
                initialUrl: "https://www.ign.com/articles/" + year + "/" + month + "/" + day + "/" + slug,
                javascriptMode: JavascriptMode.unrestricted,
            )
          );
        }
      )
    );
  }

  void _createWebViewVideo(DateTime dt, String slug){
    String year = dt.year.toString();
    String month = dt.month < 10 ? "0" + dt.month.toString() : dt.month.toString();
    String day = dt.day < 10 ? "0" + dt.day.toString() : dt.day.toString();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context){
          return Scaffold(
            appBar: AppBar(

            ),
            body : WebView(
                initialUrl: "https://www.ign.com/videos/" + year+ "/" + month + "/" + day + "/" + slug,
                javascriptMode: JavascriptMode.unrestricted,
            )
          );
        }
      )
    );
  }
}
