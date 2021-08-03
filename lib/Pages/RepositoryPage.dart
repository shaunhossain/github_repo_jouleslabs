import 'dart:convert';
import 'package:github_repo_jouleslabs/Models/User.dart';
import 'package:github_repo_jouleslabs/Pages/SaveRepositoryPage.dart';
import 'package:github_repo_jouleslabs/Requests/GithubRequest.dart';
import 'package:flutter/material.dart';
import 'package:github_repo_jouleslabs/Models/Repo.dart';
import 'package:github_repo_jouleslabs/Providers/UserProvider.dart';
import 'package:github_repo_jouleslabs/db/repos_database.dart';
import 'package:provider/provider.dart';

class RepositoryPage extends StatefulWidget {
  @override
  _RepositoryPageState createState() => _RepositoryPageState();
}


class _RepositoryPageState extends State<RepositoryPage> {
  User user;

  List<Repo> repos;
  int id;
  String name;
  String htmlUrl;
  int stargazersCount;
  String description;

  @override
  Widget build(BuildContext context) {
    setState(() {
      user = Provider.of<UserProvider>(context).getUSer();

      Github(user.login).fetchRepository().then((repository) {
        Iterable list = json.decode(repository.body);
        setState(() {
          repos = list.map((model) => Repo.fromJson(model)).toList();
        });
      });
    });

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              brightness: Brightness.light,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.grey,), onPressed: () {
                Navigator.pop(context);
              },
              ),
              backgroundColor: Colors.white,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(user.avatar_url),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text(user.login, style: TextStyle(fontSize: 20),)
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.save, color: Colors.grey,),
                  tooltip: 'Comment Icon',
                  focusColor: Colors.blueGrey,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SaveRepositoryPage()));
                  },
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  height: 600,
                  child:
                  repos != null ?
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: repos.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                        ),
                        child: Row( crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                           Column (
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(repos[index].name, style: TextStyle(fontSize: 20, color: Colors.grey.shade700),),
                                SizedBox(
                                  width: 250.0,
                                  child: Text(
                                    repos[index].description ?? "not description",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                                  ),
                                ),
                                Text('Stars :'+ repos[index].stargazersCount.toString(), style: TextStyle(color: Colors.blue),)
                              ],
                            ),
                            MaterialButton(
                              padding: EdgeInsets.all(5),
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Align(
                                child: Text('+', style: TextStyle(color: Colors.white),),
                              ), onPressed: () {
                              id = repos[index].id;
                              name = repos[index].name;
                              htmlUrl = repos[index].htmlUrl;
                              stargazersCount = repos[index].stargazersCount;
                              description = repos[index].description ?? "No description";
                              addRepos();
                            },
                            )
                          ],
                        ),
                      );
                    },
                  ) :
                  Container(child: Align(child: Text('Data is loading ...'))),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }

  void addRepos() async {
    print(name);
    final repos = Repo(
      id: id,
      name: name,
      htmlUrl: htmlUrl,
      stargazersCount: stargazersCount,
      description: description,
    );
    addReposToDatabase(repos);
    //print(repo);
  }
  Future addReposToDatabase(Repo repo) async {
    await ReposDatabase.instance.create(repo);
  }
}