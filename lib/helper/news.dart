import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:newsverse/helper/secondApiCall.dart';
import 'dart:convert';

import '../models/article_model.dart';

class News {
  List<ArticleModel> news = [];

  Future getNews({String? category}) async {
    String kDailyhuntEndpoint =
        'https://dailyhunt-api.vercel.app/dailyhunt?category=$category&items=30';
    String kinshortsEndpoint =
        'https://inshorts-api.vercel.app/shorts?category=$category';

    String newsApi = " https://newsapi.org/v2/top-headlines?country=in&apiKey=8c02b3ba6e59447ea29c296741495fce";
    String newInshorts = "https://inshorts-news.vercel.app/$category";
    String gNews = "https://gnews.io/api/v4/top-headlines?category=general&lang=en&country=in&max=10&apikey=98e000dfa69b5d7e661d6686416ee296";

    http.Client client = http.Client();
    http.Response response = await client.get(Uri.parse(kinshortsEndpoint));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);

      if (jsonData['success'] == true) {
        jsonData['data'].forEach((element) {
          if (element['imageUrl'] != "" &&
              element['content'] != "" &&
              element['read_more_url'] != null) {
            ArticleModel articleModel = ArticleModel(
              publishedDate: element['date'].toString(),
              publishedTime: element['time'].toString(),
              image: element['img_url'].toString(),
              content: element['content'].toString(),
              fullArticle: element['read_more_url'].toString(),
              title: element['title'].toString(),
            );
            news.add(articleModel);
          }
        });
      } else {
        print('ERROR');
      }
    }

    }
}
