import 'package:bomberos_ya/config/helpers/local_storage_util.dart';
import 'package:bomberos_ya/config/theme/app_colors.dart';
import 'package:bomberos_ya/presentation/providers/simple_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/navigation/application_routes.dart';
import 'screens.dart';

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
      body: _currentIndex == 0 ? const SosScreen() : Container(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        notchMargin: 10,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 66,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomNavigationItem(Icons.home, 'Inicio', 0),
              _buildBottomNavigationItem(Icons.history, 'Historial', 1),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
        onPressed: () async {
          final selectedType =
              await LocalStorageUtil.getLocalData(KeyTypes.selectedType);
          if (mounted) {
            if (selectedType != null) {
              _showAlertDialogReport(context);
            } else {
              Navigator.of(context).pushNamed(Routes.reportIncident);
            }
          }
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
        content: const Text('¿Quieres continuar con tu reporte?.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Quiza despues',
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

Future<void> _showAlertDialogReport(BuildContext mainContext) async {
  return showDialog<void>(
    context: mainContext,
    builder: (BuildContext context) {
      return const _HomeDialog();
    },
  );
}

class _HomeDialog extends ConsumerWidget {
  const _HomeDialog();

  @override
  Widget build(BuildContext context, ref) {
    return AlertDialog(
      title: const Text('Tienes un reporte en progreso'),
      content: const Text(
          '¿Deseas proseguir con tu reporte actual o prefieres iniciar uno nuevo?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(Routes.reportIncident);
          },
          child: const Text('Continuar con mi reporte anterior'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await ref.read(simpleReportProvider).removeAllData();
            // ignore: use_build_context_synchronously
            Navigator.of(context).pushNamed(Routes.reportIncident);
          },
          child: const Text('Crear uno nuevo'),
        ),
      ],
    );
  }
}
