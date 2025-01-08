// frontend\lib\pages\Column\project_detail_page.dart
import 'package:flutter/material.dart';
import '../../widgets/Column/project_api.dart';

class ProjectDetailPage extends StatelessWidget {
  final int articleId;

  const ProjectDetailPage({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('文章內容'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ProjectAPI.fetchArticleDetail(articleId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('發生錯誤: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('找不到文章'));
          } else {
            final article = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article['title'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '作者: ${article['author']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      article['content'],
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    if (article['image_url'] != null &&
                        article['image_url'].isNotEmpty)
                      Image.network(
                        article['image_url'],
                        fit: BoxFit.cover,
                      ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
