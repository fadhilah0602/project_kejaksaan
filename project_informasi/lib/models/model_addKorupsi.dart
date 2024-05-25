import 'dart:convert';

ModelAddKorupsi modelAddKorupsiFromJson(String str) =>
    ModelAddKorupsi.fromJson(json.decode(str));

String modelAddKorupsiToJson(ModelAddKorupsi data) =>
    json.encode(data.toJson());

class ModelAddKorupsi {
  bool isSuccess;
  String message;

  ModelAddKorupsi({
    required this.isSuccess,
    required this.message,
  });

  factory ModelAddKorupsi.fromJson(Map<String, dynamic> json) =>
      ModelAddKorupsi(
        isSuccess: json["isSuccess"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
  };
}
