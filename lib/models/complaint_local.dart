class ComplaintLocal {
  String? id;
  String? hash;
  String? correo;
  String? tipoEmergencia;
  String? estado;
  String? lon;
  String? lat;
  String? audioUrl;
  List<String> imagenesUrls;
  String? createdAt;

  ComplaintLocal({
    this.id = '',
    this.hash = '',
    this.correo = '',
    this.tipoEmergencia = '',
    this.estado = '',
    this.lon = '',
    this.lat = '',
    this.audioUrl = '',
    List<String>? imagenesUrls,
    this.createdAt = '',
  }) : this.imagenesUrls = imagenesUrls ?? [];

  factory ComplaintLocal.fromJson(Map<String, dynamic> json) => ComplaintLocal(
        id: json["_id"],
        hash: json["hash"],
        correo: json["correo"],
        tipoEmergencia: json["tipoEmergencia"],
        estado: json["estado"],
        lon: json["lon"],
        lat: json["lat"],
        audioUrl: json["audioUrl"],
        imagenesUrls: List<String>.from(json["imagenesUrls"]),
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "hash": hash,
        "correo": correo,
        "tipoEmergencia": tipoEmergencia,
        "estado": estado,
        "lon": lon,
        "lat": lat,
        "audioUrl": audioUrl,
        "imagenesUrls": imagenesUrls,
        "createdAt": createdAt,
      };

  static List<ComplaintLocal> fromJsonList(List<dynamic> json) {
    final complaints =
        json.map((data) => ComplaintLocal.fromJson(data)).toList();
    return complaints;
  }
}
