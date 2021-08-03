import 'package:flutter/material.dart';
import 'package:github_repo_jouleslabs/Models/Repo.dart';
import 'package:github_repo_jouleslabs/db/repos_database.dart';

class SaveRepositoryPage extends StatefulWidget {
  @override
  _SaveRepositoryPageState createState() => _SaveRepositoryPageState();
}

class _SaveRepositoryPageState extends State<SaveRepositoryPage> {
  List<Repo> allRepos;


  // @override
  // void dispose() {
  //   ReposDatabase.instance.close();
  //
  //   super.dispose();
  // }

  Future refreshNotes() async {

    this.allRepos = await ReposDatabase.instance.readAllRepos();
    print(allRepos[2].name);
    setState(() {
      this.allRepos = allRepos;
    });
  }

  @override
  void initState() {
    refreshNotes();
    super.initState();

  }



  @override
  Widget build(BuildContext context) {

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
              expandedHeight: 30,
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  height: 600,
                  child:
                  allRepos != null ?

                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: allRepos.length,
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
                                Text(allRepos[index].name, style: TextStyle(fontSize: 20, color: Colors.grey.shade700),),
                                SizedBox(
                                  width: 250.0,
                                  child: Text(
                                    allRepos[index].description ,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                                  ),
                                ),
                                Text('Stars :'+ allRepos[index].stargazersCount.toString(), style: TextStyle(color: Colors.blue),)
                              ],
                            ),
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
}