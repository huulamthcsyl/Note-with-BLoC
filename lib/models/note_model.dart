import 'dart:convert';

Note noteFromJson(String str) => Note.fromJson(json.decode(str));

String noteToJson(Note data) => json.encode(data.toJson());

class Note {
  Note({
      this.id,
      this.title,
      this.contents,
  });

  int id;
  String title;
  String contents;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json["id"],
    title: json["title"],
    contents: json["contents"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "contents": contents,
  };
}
