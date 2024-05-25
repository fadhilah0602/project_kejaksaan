class ModelJms {
  ModelJms({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  late final bool isSuccess;
  late final String message;
  late final List<Jms> data;

  ModelJms.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    data = List.from(json['data']).map((e) => Jms.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['isSuccess'] = isSuccess;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Jms {
  Jms({
    required this.id_jms,
    required this.id_user,
    required this.nama_pemohon,
    required this.sekolah,
    required this.status,
  });

  late final String id_jms;
  late final String id_user;
  late final String nama_pemohon;
  late final String sekolah;
  late final String status;

  Jms.fromJson(Map<String, dynamic> json) {
    id_user = json['id_user'].toString(); // Konversi ke String
    id_jms = json['id_jms'].toString(); // Konversi ke String
    // id_jms = json['id_jms'];
    // id_user = json['id_user'];
    nama_pemohon = json['nama_pemohon'];
    sekolah = json['sekolah'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id_jms'] = id_jms;
    _data['id_user'] = id_user;
    _data['nama_pemohon'] = nama_pemohon;
    _data['sekolah'] = sekolah;
    _data['status'] = status;
    return _data;
  }
}
