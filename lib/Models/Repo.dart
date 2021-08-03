final String tableRepos = 'repos';

class ReposFields {
  static final List<String> values = [
    /// Add all fields
    id, name, htmlUrl, stargazersCount, description
  ];

  static final String id = 'id';
  static final String name = 'name';
  static final String htmlUrl = 'html_url';
  static final String stargazersCount = 'stargazers_count';
  static final String description = 'description';
}

class Repo {
  final int id;
  final String name;
  final String htmlUrl;
  final int stargazersCount; //stargazers_count
  final String description;

  //Repo(this.id, this.name, this.htmlUrl, this.stargazersCount, this.description);

  Repo({this.id, this.name, this.htmlUrl, this.stargazersCount, this.description});

  Repo copy({
    int id,
    String name,
    String htmlUrl, // hmtl_url
    int stargazersCount, //stargazers_count
    String description,
  }) =>
      Repo(
          id: id ?? this.id,
          name: name ?? this.name,
          htmlUrl: htmlUrl ?? this.htmlUrl,
          stargazersCount: stargazersCount ?? this.stargazersCount,
          description: description ?? this.description
      );

  // Map toJson() => {
  //   'id': id,
  //   'name': name,
  //   'html_url': htmlUrl,
  //   'stargazers_count': stargazersCount,
  //   'description': description
  // };
  //
  // Repo.fromJson(Map json) :
  //     id = json['id'],
  //     name = json['name'],
  //     htmlUrl = json['html_url'],
  //     stargazersCount = json['stargazers_count'],
  //     description = json['description'];

  static Repo fromJson(Map<String, Object> json) => Repo(
    id : json[ReposFields.id] as int,
    name : json[ReposFields.name] as String,
    htmlUrl : json[ReposFields.htmlUrl] as String,
    stargazersCount : json[ReposFields.stargazersCount] as int,
    description : json[ReposFields.description] as String,
  );

  Map<String, Object> toJson() => {
    ReposFields.id: id,
    ReposFields.name: name,
    ReposFields.htmlUrl: htmlUrl,
    ReposFields.stargazersCount: stargazersCount,
    ReposFields.description: description,
  };

}
