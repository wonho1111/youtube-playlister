class Record {
  String channel_name;
  String video_title;

  Record(this.channel_name, this.video_title);

  Map<String, dynamic> toJson() =>
      {'channel_name': channel_name, 'video_title': video_title};
}
