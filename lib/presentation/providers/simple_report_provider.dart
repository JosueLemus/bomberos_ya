import 'package:bomberos_ya/config/services/api_services.dart';
import 'package:bomberos_ya/models/fire_types.dart';
import 'package:bomberos_ya/presentation/screens/wizard_report/comment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final simpleReportProvider =
    ChangeNotifierProvider((ref) => _SimpleReportProvider());

class _SimpleReportProvider extends ChangeNotifier {
  FireTypes? selectedType;
  String audioBase64 = '';
  List<XFile> selectedImages = [];
  List<FireTypes> fireTypes = [];
  final services = ApiServices();

  _SimpleReportProvider() {
    getFireTypes();
  }
  void getFireTypes() async {
    fireTypes = await services.getFireTypes();
    notifyListeners();
  }

  void postData() async {
    final images = await ImageConversionUtil.convertImagesToBase64(selectedImages);
    services.postReport(audioBase64, images);
    
  }
}
