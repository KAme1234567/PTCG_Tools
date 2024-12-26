import 'package:flutter/material.dart';
import '../../widgets/SQLite/deck_database.dart';

class AddEditDeckPage extends StatefulWidget {
  final Map<String, dynamic>? deck;

  const AddEditDeckPage({Key? key, this.deck}) : super(key: key);

  @override
  _AddEditDeckPageState createState() => _AddEditDeckPageState();
}

class _AddEditDeckPageState extends State<AddEditDeckPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.deck != null) {
      _nameController.text = widget.deck!['name'];
      _descriptionController.text = widget.deck!['description'];
    }
  }

  void _saveDeck() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請填寫所有欄位')),
      );
      return;
    }

    if (widget.deck == null) {
      await DeckDatabase.instance.addDeck({
        'name': name,
        'description': description,
      });
    } else {
      await DeckDatabase.instance.addDeck({
        'id': widget.deck!['id'],
        'name': name,
        'description': description,
      });
    }
    Navigator.pop(context, true);
  }

  void _deleteDeck() async {
    if (widget.deck != null) {
      await DeckDatabase.instance.deleteDeck(widget.deck!['id']);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck == null ? '新增牌組' : '編輯牌組'),
        actions: widget.deck != null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteDeck,
                )
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '牌組名稱'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: '牌組描述'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveDeck,
              child: const Text('儲存'),
            ),
          ],
        ),
      ),
    );
  }
}
