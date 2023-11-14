import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageUtil {
  static Future<void> saveBackendResponse(String response, KeyTypes key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key.name, response);
  }

  static Future<String?> getBackendResponse(KeyTypes key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key.name);
  }
}

enum KeyTypes { fireTypesList, selectedType, currentRecording, selectedPhotos }
