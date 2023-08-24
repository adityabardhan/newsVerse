class NewsModel {
  NewsModel(this.status, this.totalResults, this.articles);

  String status;
  int totalResults;
  List<NewArticleModel> articles;

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'totalResults': totalResults,
      'articles': articles,
    };
  }

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
    json['status'],
    json['totalResults'],
    (json['articles'] as List<dynamic>)
        .map((e) => NewArticleModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
class SourceModel {
  SourceModel({this.id = '', required this.name});

  String? id, name;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class NewArticleModel {
  NewArticleModel(this.source, this.author, this.title, this.description, this.url,
      this.urlToImage, this.publishedAt, this.content);

  String? author, description, urlToImage, content;
  String title, url, publishedAt;
  SourceModel source;

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'description': description,
      'urlToImage': urlToImage,
      'content': content,
      'title': title,
      'url': url,
      'publishedAt': publishedAt,
      'source': source,
    };
  }

  factory NewArticleModel.fromJson(Map<String, dynamic> json) => NewArticleModel(
    SourceModel.fromJson(json['source'] as Map<String, dynamic>),
    json['author'],
    json['title'],
    json['description'],
    json['url'],
    json['urlToImage'],
    json['publishedAt'],
    json['content'],
  );
}

class SecondNewsModel {
  late String newsHead;
  late String newDes;
  late final String newImage;
  late String newUrl;
  late String content;
  late String published;

  SecondNewsModel(
      {this.newsHead='',
        this.newDes = '',
        this.newImage='',
        this.newUrl = '',
        this.published = '',
        this.content = ''});

  factory SecondNewsModel.fromMap(Map news) {
    return SecondNewsModel(
        newDes: news['description'],
        newsHead: news['title'],
        newImage: news['urlToImage'],
        newUrl: news['url'],
        content: news['content'],
        published: news['publishedAt']);
  }
}

class SecondModel {
  late String title;
  late String content;
  late String image;
  late String url;
  late String description;

  SecondModel(
      {this.title = "Title",
        this.content = "Content",
        this.image = "Image",
        this.url = "URL",
        this.description = "Description"});

  factory SecondModel.fromMap(Map news) {
    return SecondModel(
        title: news['title'],
        description: news['description'],
        image: news['image'],
        url: news['url'],
        content: news['content']);
  }
}
