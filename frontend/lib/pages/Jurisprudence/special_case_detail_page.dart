import 'package:flutter/material.dart';
import '../../widgets/Jurisprudence/project_api.dart';

class SpecialCaseDetailPage extends StatelessWidget {
  final int caseId;

  const SpecialCaseDetailPage({Key? key, required this.caseId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('特殊判例詳情')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: SpecialCasesAPI.fetchSpecialCaseDetail(caseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('錯誤: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('未找到相關判例'));
          } else {
            final caseData = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(caseData['title'],
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(caseData['content'],
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  if (caseData['image_url'] != null)
                    Image.network(caseData['image_url'], fit: BoxFit.cover),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
