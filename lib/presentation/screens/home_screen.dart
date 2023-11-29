import 'package:bomberos_ya/config/helpers/local_storage_util.dart';
import 'package:bomberos_ya/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../config/navigation/application_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    verifyPreviousReport();
  }

  void verifyPreviousReport() async {
    final selectedType =
        await LocalStorageUtil.getLocalData(KeyTypes.selectedType);
    if (selectedType != null && mounted) {
      _showAlertDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('Home'),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        notchMargin: 10,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 66,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomNavigationItem(Icons.history, 'Historial', 0),
              _buildBottomNavigationItem(Icons.person, 'Perfil', 3),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(Routes.reportIncident);
        },
      ),
    );
  }

  Widget _buildBottomNavigationItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    final color = isSelected ? AppColors.primaryColor : AppColors.secondaryText;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
            ),
            Text(
              label,
              style: TextStyle(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showAlertDialog(BuildContext mainContext) async {
  return showDialog<void>(
    barrierDismissible: false,
    context: mainContext,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Tienes un reporte en progreso'),
        content: const Text(
            '¿Quieres continuar con tu reporte? Al presionar cancelar se borrará el reporte.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(mainContext).pushNamed(Routes.reportIncident);
            },
            child: const Text('Continuar'),
          ),
        ],
      );
    },
  );
}
