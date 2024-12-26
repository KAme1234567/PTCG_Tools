// frontend\lib\pages\Column\project_list_page.dart
import 'package:flutter/material.dart';
import 'project_detail_page.dart';
import '../../widgets/Column/project_api.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({Key? key}) : super(key: key);

  @override
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  late Future<List<Map<String, dynamic>>> _articles;

  final List<int> pinnedArticleIds = [1145, 1146, 1147];

  @override
  void initState() {
    super.initState();
    _articles = ProjectAPI.fetchArticleList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('專案文章列表'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _articles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('發生錯誤: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('沒有可用的文章'));
          } else {
            final articles = snapshot.data!;
            final pinnedArticles = articles
                .where((article) => pinnedArticleIds.contains(article['id']))
                .toList();
            final otherArticles = articles
                .where((article) => !pinnedArticleIds.contains(article['id']))
                .toList();

            return ListView(
              children: [
                ...pinnedArticles.map(
                    (article) => _buildArticleCard(article, isPinned: true)),
                const Divider(),
                ...otherArticles.map(
                    (article) => _buildArticleCard(article, isPinned: false)),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article,
      {bool isPinned = false}) {
    return Card(
      elevation: isPinned ? 6 : 4,
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: article['image_url'] != null
            ? Image.network(
                article['image_url'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.image_not_supported),
        title: Row(
          children: [
            if (isPinned)
              const Icon(Icons.push_pin, color: Colors.red, size: 18),
            if (isPinned) const SizedBox(width: 5),
            Expanded(
              child: Text(
                article['title'],
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        subtitle: Text('作者: ${article['author']}'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectDetailPage(articleId: article['id']),
            ),
          );
        },
      ),
    );
  }
}
