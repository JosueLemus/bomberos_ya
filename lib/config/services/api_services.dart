import 'dart:convert';
import 'package:bomberos_ya/models/fire_types.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final baseUrl = "192.168.0.9:3001";

  Future<List<FireTypes>> getFireTypes(String lastTimeModified) async {
    try {
      final queryParameters = {'lastTimeModified': lastTimeModified};
      final url = Uri.http(baseUrl, '/tipo-solicitudes', queryParameters);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return FireTypes.fromJsonList(json);
      } else {
        throw Exception('Error en la solicitud HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
      throw Exception('Error en la solicitud HTTP');
    }
  }

  Future<void> postReport(String audio, List<String> images) async {
    final url = Uri.parse('$baseUrl/denuncias');
    final imagenes2 = jsonEncode(images);
    final response = await http.post(
      url,
      body: {
        'usuario': "El ya tu sabe",
        // 'titulo': "",
        // 'descripcion': "",
        // 'tipoDenuncia':"",
        // 'lon':"",
        // 'lat': "",
        'imagenes': imagenes2,
        'audio': audio,
      },
    );
    print(response);
  }
}
