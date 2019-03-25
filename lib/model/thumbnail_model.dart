class Thumbnail{
  final String url;
  final String size;
  final int width;
  final int height;

  Thumbnail({
    this.url,
    this.size,
    this.width,
    this.height
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json){
    return Thumbnail(
      url : json['url'],
      size : json['size'],
      width : json['width'],
      height : json['height']
    );
  }
}