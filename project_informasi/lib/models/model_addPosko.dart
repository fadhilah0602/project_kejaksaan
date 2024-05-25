import 'dart:convert';

ModelAddPosko modelAddPoskoFromJson(String str) =>
    ModelAddPosko.fromJson(json.decode(str));

String modelAddPoskoToJson(ModelAddPosko data) =>
    json.encode(data.toJson());

class ModelAddPosko {
  bool isSuccess;
  String message;

  ModelAddPosko({
    required this.isSuccess,
    required this.message,
  });

  factory ModelAddPosko.fromJson(Map<String, dynamic> json) =>
      ModelAddPosko(
        isSuccess: json["isSuccess"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
  };
}
