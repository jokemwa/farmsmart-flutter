import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsmart_flutter/model/entities/article_entity.dart';
import 'package:farmsmart_flutter/model/entities/entities_const.dart';
//TODO: deprecated remove when not referenced 
class ArticlesDirectoryEntity {
  List<ArticleEntity> articles;
  List<String> articlesPathReference;

  ArticlesDirectoryEntity({
    this.articles,
    this.articlesPathReference
  });

  factory ArticlesDirectoryEntity.empty() =>
      ArticlesDirectoryEntity(
        articles: List(),
        articlesPathReference: List<String>(),
      );

  factory ArticlesDirectoryEntity.featuredArticlesFromDocument(DocumentSnapshot featuredArticlesDocument) =>
      ArticlesDirectoryEntity(
        articles: List(),
        articlesPathReference: extractArticlesPaths(featuredArticlesDocument),
      );

  void addArticle(ArticleEntity article) {
    this.articles.add(article);
  }
}

List<String> extractArticlesPaths(DocumentSnapshot document) {
  if (document.data[ARTICLES] != null) {
    return List<String>.from(
        document.data[ARTICLES].map((article) => article[ARTICLE].path));
  }
  return null;
}
