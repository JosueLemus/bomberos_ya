import 'dart:convert';
import 'package:bomberos_ya/config/helpers/base64_converter.dart';
import 'package:bomberos_ya/config/helpers/db_helper.dart';
import 'package:bomberos_ya/models/complaint_local.dart';
import 'package:bomberos_ya/models/fire_types.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final baseUrl = "192.168.137.188:3001";

  Future<List<FireTypes>> getFireTypes(String lastTimeModified) async {
    try {
      final queryParameters = {'lastTimeModified': lastTimeModified};
      final url = Uri.http(baseUrl, '/tipo-emergencias', queryParameters);
      final response = await http.get(url);

      print(response.statusCode);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print(json);
        return FireTypes.fromJsonList(json);
      } else {
        print("ERROR");
        throw Exception('Error en la solicitud HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
      throw Exception('Error en la solicitud HTTP');
    }
  }

  Future<List<ComplaintLocal>> getHistoryList() async {
    try {
      final queryParameters = {'usuario': "el ya tu sabe"};
      final url = Uri.http(baseUrl, '/emergencias', queryParameters);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ComplaintLocal.fromJsonList(json);
      } else {
        print("ERROR");
        throw Exception('Error en la solicitud HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
      throw Exception('Error en la solicitud HTTP');
    }
  }

  Future<String> postReport(ReportRequest reportRequest) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // convertir el path de las imagenes en imagenes
    List<String> listaDinamica =
        List<String>.from(jsonDecode(reportRequest.imagenes));
    final images = await Base64Converter.convertImagesToBase64(listaDinamica);
    final jsonImages = jsonEncode(images);
    String hash = "";
    final url = Uri.http(baseUrl, '/emergencias');
    final response = await http.post(
      url,
      body: {
        'usuario': reportRequest.usuario,
        'tipoEmergencia': reportRequest.tipoIncendio,
        'lon': position.longitude.toString(),
        'lat': position.latitude.toString(),
        'imagenes': jsonImages,
        'audioUrl': ""
      },
    );
    final json = jsonDecode(response.body);
    if (json["statusCode"] == 200) {
      hash = json["data"]["hash"];
    }
    print(response.statusCode);
    print("HASH OBTENIDO CON EXITO ======> " + hash);
    return hash;
  }

  Future<bool> fileParts(ReportRequest request) async {
    try {
      final part = int.parse(request.part);

      final data = obtenerParte(request.audio, 5, part);
      if (data.isEmpty) {
        throw Exception("La parte de audio está vacía");
      }

      final bodyData = {
        'part': part.toString(),
        'requestId': request.hash,
        'filename': "audio",
        'extension': "mp3",
        'data': data,
      };
      print(bodyData);

      final url = Uri.http(baseUrl, '/emergencias/filepart');
      final response = await http.post(url, body: bodyData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Manejar la respuesta exitosa si es necesario
        print("Parte del archivo enviada exitosamente");
        return true;
      } else {
        throw Exception("Error en la solicitud: ${response.statusCode}");
      }
    } catch (e) {
      // Manejar otros errores
      print("Error en la función fileParts: $e");
      throw Exception(e.toString());
    }
  }

  Future<void> joinFileParts(String hash) async {
    try {
      final url = Uri.http(baseUrl, '/emergencias/joinfileparts');
      final response = await http.post(
        url,
        body: {
          'requestId': hash,
        },
      );

      if (response.statusCode == 200) {
        // Manejar la respuesta exitosa si es necesario
        print("Parte del archivo enviada exitosamente");
      } else {
        throw Exception("Error en la solicitud: ${response.statusCode}");
      }
    } catch (e) {
      // Manejar otros errores
      print("Error en la función joinFileParts: $e");
      throw Exception(e.toString());
    }
  }

  String obtenerParte(String cadena, int partes, int parteDeseada) {
    if (partes <= 0 || parteDeseada <= 0 || parteDeseada > partes) {
      throw ArgumentError("Los parámetros no son válidos");
    }

    int longitudCadena = cadena.length;
    int caracteresPorParte = (longitudCadena / partes).ceil();
    int inicio = (parteDeseada - 1) * caracteresPorParte;
    int fin = parteDeseada * caracteresPorParte;

    if (fin > longitudCadena) {
      fin = longitudCadena;
    }

    return cadena.substring(inicio, fin);
  }
}
