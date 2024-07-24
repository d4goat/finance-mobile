import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:frontend/utils/config.dart';

// Model Data Tagihan
class Bill {
  final String id;
  final String title;
  final double amount;
  final DateTime dueDate;
  final List<BillDetail> details;

  Bill({
    required this.id,
    required this.title,
    required this.amount,
    required this.dueDate,
    required this.details,
  });
}

class BillDetail {
  final String description;
  final double amount;

  BillDetail({
    required this.description,
    required this.amount,
  });
}

class CopyHome extends StatefulWidget {
  const CopyHome({super.key});

  @override
  State<CopyHome> createState() => _CopyHomeState();
}

class _CopyHomeState extends State<CopyHome> {
  late Map<String, dynamic> user;

  // Contoh data tagihan
  Bill? _bill; // Tagihan bisa kosong atau ada

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (ModalRoute.of(context) != null) {
      user = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      // Simulasi pemuatan data tagihan
      // Anda dapat menggantinya dengan data nyata dari API atau database
      _bill = Bill(
        id: '1',
        title: 'Tagihan Air Bulanan',
        amount: 150000,
        dueDate: DateTime.now().add(Duration(days: 7)),
        details: [
          BillDetail(description: 'Konsumsi Air', amount: 100000),
          BillDetail(description: 'Biaya Admin', amount: 50000),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("${user['penghuni']['nama']}"),
        backgroundColor: Config.primaryColor,
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      // Kondisi untuk menampilkan notifikasi tagihan atau pesan kosong
                      _bill != null
                          ? _buildBillNotificationCard()
                          : Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 350,
                                    child: ClipRRect(
                                      child: Image.asset('assets/illust2.png'),
                                    ),
                                  ),
                                  Config.spaceSmall,
                                  const Text(
                                    "Tidak Ada Tagihan untuk Saat Ini",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan notifikasi tagihan
  Widget _buildBillNotificationCard() {
    return Container(
      width: Config.screenWidth,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Navigasi ke halaman detail tagihan jika diperlukan
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BillDetailsPage(bill: _bill!),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _bill!.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Jumlah: Rp${_bill!.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Jatuh Tempo: ${DateFormat('dd MMM yyyy').format(_bill!.dueDate)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman Detail Tagihan
class BillDetailsPage extends StatelessWidget {
  final Bill bill;

  BillDetailsPage({required this.bill});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Tagihan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Tagihan untuk ${bill.title}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Jatuh Tempo: ${DateFormat('dd MMM yyyy').format(bill.dueDate)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: bill.details.length,
                itemBuilder: (context, index) {
                  final detail = bill.details[index];
                  return ListTile(
                    title: Text(detail.description),
                    trailing: Text(
                      'Rp${detail.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
