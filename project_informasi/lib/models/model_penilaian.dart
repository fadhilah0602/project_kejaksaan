class ModelPenilaian {
  ModelPenilaian({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  late final bool isSuccess;
  late final String message;
  late final List<Penilaian> data;

  ModelPenilaian.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    data = List.from(json['data']).map((e) => Penilaian.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['isSuccess'] = isSuccess;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Penilaian {
  Penilaian({
    required this.id_penilaian,
    required this.id_user,
    required this.rating,
  });

  late final String id_penilaian;
  late final String id_user;
  late final String rating;

  Penilaian.fromJson(Map<String, dynamic> json) {
    id_user = json['id_user'].toString(); // Konversi ke String
    id_penilaian = json['id_penilaian'].toString(); // Konversi ke String
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id_penilaian'] = id_penilaian;
    _data['id_user'] = id_user;
    _data['rating'] = rating;
    return _data;
  }
}
