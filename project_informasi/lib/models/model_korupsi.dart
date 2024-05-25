class ModelKorupsi {
  ModelKorupsi({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  late final bool isSuccess;
  late final String message;
  late final List<Korupsi> data;

  ModelKorupsi.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    data = List.from(json['data']).map((e) => Korupsi.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['isSuccess'] = isSuccess;
    _data['message'] = message;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Korupsi {
  Korupsi({
    required this.id_korupsi,
    required this.id_user,
    required this.nama_pelapor,
    required this.no_hp,
    required this.ktp,
    required this.ktp_pdf,
    required this.uraian,
    required this.laporan,
    required this.laporan_pdf,
    required this.status,
  });

  late final String id_korupsi;
  late final String id_user;
  late final String nama_pelapor;
  late final String no_hp;
  late final String ktp;
  late final String ktp_pdf;
  late final String uraian;
  late final String laporan;
  late final String laporan_pdf;
  late final String status;

  Korupsi.fromJson(Map<String, dynamic> json) {
    id_korupsi = json['id_korupsi'].toString(); // Konversi ke String
    id_user = json['id_user'].toString(); // Konversi ke String
    nama_pelapor = json['nama_pelapor'];
    no_hp = json['no_hp'];
    ktp = json['ktp'];
    ktp_pdf = json['ktp_pdf'];
    uraian = json['uraian'];
    laporan = json['laporan'];
    laporan_pdf = json['laporan_pdf'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id_user'] = id_user;
    _data['id_korupsi'] = id_korupsi;
    _data['nama_pelapor'] = nama_pelapor;
    _data['no_hp'] = no_hp;
    _data['ktp'] = ktp;
    _data['ktp_pdf'] = ktp_pdf;
    _data['uraian'] = uraian;
    _data['laporan'] = laporan;
    _data['laporan_pdf'] = laporan_pdf;
    _data['status'] = status;
    return _data;
  }
}
