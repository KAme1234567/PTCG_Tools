import 'package:flutter/material.dart';
import 'special_case_detail_page.dart';
import '../../widgets/Jurisprudence/project_api.dart';

class SpecialCasesListPage extends StatefulWidget {
  const SpecialCasesListPage({Key? key}) : super(key: key);

  @override
  _SpecialCasesListPageState createState() => _SpecialCasesListPageState();
}

class _SpecialCasesListPageState extends State<SpecialCasesListPage> {
  late Future<List<Map<String, dynamic>>> _specialCases;

  @override
  void initState() {
    super.initState();
    _specialCases = SpecialCasesAPI.fetchSpecialCases();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('特殊判例列表'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _specialCases,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('發生錯誤: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('沒有可用的特殊判例'));
          } else {
            final cases = snapshot.data!;
            return ListView.builder(
              itemCount: cases.length,
              itemBuilder: (context, index) {
                final caseData = cases[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: caseData['image_url'] != null
                        ? Image.network(
                            caseData['image_url'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(
                      caseData['title'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    subtitle: Text(caseData['description']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SpecialCaseDetailPage(caseId: caseData['id']),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
