import 'package:http/http.dart' as http;

class Github {
  final String userName;
  final String url = 'https://api.github.com/';
  static String client_id = '09f38088445cfd410280';
  static String client_secret = 'fe61c6c4180c776940c5537bac04eca58c3770a5';

  final String query = "?client_id=${client_id}&client_secret=${client_secret}";

  Github(this.userName);

  Future<http.Response> fetchUser() {
    return http.get(Uri.parse((url + 'users/' + userName + query)));
  }

  Future<http.Response> fetchFollowing() {
    return http.get(Uri.parse((url + 'users/' + userName + '/following' + query)));
  }

  Future<http.Response> fetchRepository() {
    return http.get(Uri.parse((url + 'users/' + userName + '/repos' + query)));
  }
}
