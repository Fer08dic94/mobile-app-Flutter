import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Creating a class user to store the data;
class Musica {
  final String title;
  final String description;
  //final String urlToImage;
  //final String body;

  Musica({
    required this.title,
    required this.description,
    //required this.urlToImage,
    //required this.body,
  });
}

class Api1 extends StatefulWidget {
  @override
  State<Api1> createState() => _Api1();
}

class _Api1 extends State<Api1> {
//Applying get request.

  Future<List<Musica>> getRequest() async {
    //replace your restFull API here.
    String url =
        "https://newsapi.org/v2/everything?q=pink+floyd&language=es&from=2022-11-15&sortBy=title&apiKey=0872a8038deb480eaa46c0c5d1ecec32";
    final response = await http.get(Uri.parse(url));

    var responseData = json.decode(response.body);
    print(responseData["articles"][2]);

    //Creating a list to store input data;
    List<Musica> users = [];
    for (var singleUser in responseData["articles"]) {
      Musica musica = Musica(
          title: singleUser["title"], description: singleUser["description"]);
      //urlToImage: singleUser["urlToImage"]);
      //body: singleUser["body"]);

      //Adding user to the list.
      users.add(musica);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Http Get Request."),
          leading: Icon(
            Icons.get_app,
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: getRequest(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (ctx, index) => ListTile(
                    title: Text(snapshot.data[index].title),
                    subtitle: Text(snapshot.data[index].description),
                    contentPadding: EdgeInsets.only(bottom: 20.0),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
