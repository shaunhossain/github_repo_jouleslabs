import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:github_repo_jouleslabs/Models/Repo.dart';
import 'package:github_repo_jouleslabs/Requests/GithubRequest.dart';

class RepositoryProvider with ChangeNotifier {
  Repo repo;
  String errorMessage;
  bool loading = false;

  Future<bool> fetchUser(username) async {
    setLoading(true);

    await Github(username).fetchUser().then((data) {
      setLoading(false);

      if (data.statusCode == 200) {
        setUser(Repo.fromJson(json.decode(data.body)));
      } else {
        Map<String, dynamic> result = json.decode(data.body);
        setMessage(result['message']);
      }
    });

    return isUser();
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  bool isLoading() {
    return loading;
  }

  void setUser(value) {
    repo = value;
    notifyListeners();
  }

  Repo getUSer() {
    return repo;
  }

  void setMessage(value) {
    errorMessage = value;
    notifyListeners();
  }

  String getMessage() {
    return errorMessage;
  }

  bool isUser() {
    return repo != null ? true : false;
  }
}