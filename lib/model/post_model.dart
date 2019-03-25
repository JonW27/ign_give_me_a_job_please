import 'thumbnail_model.dart';
import 'metadata_model.dart';

class Post{
  final String contentID;
  final String contentType;
  final List<Thumbnail> thumbnails;
  final MetaData metadata;
  final List<String> tags;

  Post({
    this.contentID,
    this.contentType,
    this.thumbnails,
    this.metadata,
    this.tags,
  });

  factory Post.fromJson(Map<String, dynamic> json){

    var list = json['thumbnails'] as List;
    List<Thumbnail> thumbnailList = list.map((i) => Thumbnail.fromJson(i)).toList();

    return Post(
      contentID: json['contentId'],
      contentType: json['contentType'],
      thumbnails: thumbnailList,
      metadata: MetaData.fromJson(json['metadata']),
      tags: json['tags'].cast<String>(),
    );
  }


}