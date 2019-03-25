class MetaData{
  final String title;
  final String headline;
  final String description;
  final String publishDate;
  final String howLongAgo;
  final String slug;
  final List<String> networks;
  final String state;
  final int duration;
  final String videoSeries;

  MetaData({
    this.title,
    this.headline,
    this.description,
    this.publishDate,
    this.howLongAgo,
    this.slug,
    this.networks,
    this.state,
    this.duration,
    this.videoSeries,
  });

  factory MetaData.fromJson(Map<String, dynamic> json){
    final Duration dur = DateTime.now().difference(DateTime.parse(json["publishDate"]));
    String howLongAgo;
    if(dur.inSeconds < 60){
      howLongAgo = dur.inSeconds.toString() + " seconds";
    } else if(dur.inMinutes < 60){
      howLongAgo = dur.inMinutes.toString() + " minutes";
    } else if(dur.inHours < 24){
      howLongAgo = dur.inHours.toString() + " hours";
    } else{
      howLongAgo = dur.inDays.toString() + " days";
    }

    return MetaData(
      title : json['title'],
      headline : json['headline'],
      description : json['description'],
      publishDate : json['publishDate'],
      howLongAgo: howLongAgo,
      slug: json['slug'],
      networks: json['networks'].cast<String>(),
      state: json['state'],
      duration: json['duration'],
      videoSeries: json['videoSeries']
    );
  }
}