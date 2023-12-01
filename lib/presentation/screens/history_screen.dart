import 'dart:ffi';

import 'package:bomberos_ya/config/services/api_services.dart';
import 'package:bomberos_ya/config/theme/app_colors.dart';
import 'package:bomberos_ya/models/complaint_local.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectedFilter = 'Todos';
  List<ComplaintLocal> complaintLocal = [];
  List<ComplaintLocal> copyComplaintLocal = [];
  @override
  void initState() {
    getList();
    super.initState();
  }

  void getList() async {
    complaintLocal = await ApiServices().getHistoryList();
    copyComplaintLocal = complaintLocal;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            const Text(
              'HISTORIAL DE REPORTES',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            _buildFilterChips(),
            Expanded(
              child: ListView.builder(
                  itemCount: complaintLocal.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: HomeReportCard(
                          complaintLocal: complaintLocal[index],
                          onTap: () {
                            print("hello");
                            ApiServices().getHistoryList();
                          }),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('Todos'),
          _buildFilterChip('Pendiente'),
          _buildFilterChip('Solucionadas'),
          _buildFilterChip('Canceladas'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    bool isSelected = selectedFilter == filter;
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: FilterChip(
        label: Text(
          filter,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.primaryColor,
        showCheckmark: false,
        onSelected: (bool selected) {
          setState(() {
            selectedFilter = filter;
            complaintLocal = copyComplaintLocal;
            if (selectedFilter != "Todos") {
              complaintLocal = complaintLocal
                  .where((objeto) =>
                      objeto.estado?.toUpperCase() == filter.toUpperCase())
                  .toList();
            }
          });
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }
}

class HomeReportCard extends StatelessWidget {
  final ComplaintLocal complaintLocal;
  final Function onTap;
  const HomeReportCard(
      {super.key, required this.complaintLocal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color getColorByEstado(String estado) {
      switch (estado) {
        case 'ACEPTADA':
          return Colors.green;
        case 'CANCELADO':
          return Colors.red;
        case 'RECHAZADA':
          return Colors.orange;
        case 'PENDIENTE':
          return Colors.yellow;
        default:
          return Colors.grey;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => onTap(),
        child: Card(
            child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    complaintLocal.imagenesUrls.isNotEmpty
                        ? complaintLocal.imagenesUrls[0]
                        : 'https://www.namepros.com/attachments/empty-png.89209/',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.network(
                        'https://www.namepros.com/attachments/empty-png.89209/',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      );
                    },
                  )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      complaintLocal.tipoEmergencia ?? "xD",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        complaintLocal.tipoEmergencia ?? "xD",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          complaintLocal.tipoEmergencia!.length > 15
                              ? '${complaintLocal.tipoEmergencia!.toUpperCase().substring(0, 15)}...'
                              : complaintLocal.tipoEmergencia!.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 10, fontStyle: FontStyle.italic),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                  color: getColorByEstado(
                                      complaintLocal.estado ?? ""),
                                  borderRadius: BorderRadius.circular(3)),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              complaintLocal.estado ?? "",
                              style: const TextStyle(
                                  fontSize: 10, fontStyle: FontStyle.italic),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
