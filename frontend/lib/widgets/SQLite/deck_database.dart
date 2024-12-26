// frontend\lib\widgets\SQLite\deck_database.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DeckDatabase {
  static final DeckDatabase instance = DeckDatabase._init();
  static Database? _database;

  DeckDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('decks.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(
      path,
      version: 2, // 更新版本號
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  static Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'decks.db');
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      print('資料庫文件已刪除');
    } else {
      print('資料庫文件不存在');
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE decks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE deck_cards (
        deck_id INTEGER NOT NULL,
        card_id INTEGER NOT NULL,
        card_count INTEGER NOT NULL CHECK(card_count <= 4),
        PRIMARY KEY (deck_id, card_id),
        FOREIGN KEY (deck_id) REFERENCES decks (id) ON DELETE CASCADE
      )
    ''');
    print('資料庫表已創建');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS deck_cards (
          deck_id INTEGER NOT NULL,
          card_id INTEGER NOT NULL,
          card_count INTEGER NOT NULL CHECK(card_count <= 4),
          PRIMARY KEY (deck_id, card_id),
          FOREIGN KEY (deck_id) REFERENCES decks (id) ON DELETE CASCADE
        )
      ''');
      print('資料庫升級完成，新增 deck_cards 表');
    }
  }

  // 添加新牌組
  Future<int> addDeck(Map<String, dynamic> deck) async {
    final db = await instance.database;
    return await db.insert('decks', deck);
  }

  // 獲取所有牌組
  Future<List<Map<String, dynamic>>> fetchDecks() async {
    final db = await instance.database;
    return await db.query('decks', orderBy: 'id DESC');
  }

  // 刪除牌組
  Future<int> deleteDeck(int id) async {
    final db = await instance.database;
    return await db.delete('decks', where: 'id = ?', whereArgs: [id]);
  }

  // 添加卡片到牌組
  Future<int> addCardToDeck(int deckId, int cardId) async {
    final db = await instance.database;

    // 獲取當前牌組的卡片
    final currentCards = await fetchCardsWithCount(deckId);

    // 檢查牌組是否已滿 60 張
    final totalCardCount =
        currentCards.isEmpty ? 0 : currentCards.values.reduce((a, b) => a + b);
    if (totalCardCount >= 60) {
      throw Exception('牌組已滿 60 張，無法添加更多卡片');
    }

    // 檢查是否同一張卡超過 4 張
    final cardCount = currentCards[cardId] ?? 0;
    if (cardCount >= 4) {
      throw Exception('同一張卡片已達到 4 張的上限');
    }

    // 添加或更新卡片到牌組
    try {
      if (currentCards.containsKey(cardId)) {
        await db.update(
          'deck_cards',
          {'card_count': cardCount + 1},
          where: 'deck_id = ? AND card_id = ?',
          whereArgs: [deckId, cardId],
        );
        print(
            '卡片數量更新成功 - Deck ID: $deckId, Card ID: $cardId, New Count: ${cardCount + 1}');
      } else {
        await db.insert('deck_cards', {
          'deck_id': deckId,
          'card_id': cardId,
          'card_count': 1,
        });
        print('卡片已成功添加到牌組 - Deck ID: $deckId, Card ID: $cardId');
      }
      return 1;
    } catch (e) {
      print('添加失敗: $e');
      rethrow;
    }
  }

  // 獲取牌組中的卡片和數量
  Future<Map<int, int>> fetchCardsWithCount(int deckId) async {
    final db = await instance.database;
    final result = await db.query(
      'deck_cards',
      columns: ['card_id', 'card_count'],
      where: 'deck_id = ?',
      whereArgs: [deckId],
    );
    return {
      for (var row in result) row['card_id'] as int: row['card_count'] as int
    };
  }

  // 獲取牌組中的卡片
  Future<List<int>> fetchCardsInDeck(int deckId) async {
    final cardsWithCount = await fetchCardsWithCount(deckId);
    return cardsWithCount.keys.toList();
  }

  // 從牌組中移除卡片
  Future<int> removeCardFromDeck(int deckId, int cardId) async {
    final db = await instance.database;

    final currentCards = await fetchCardsWithCount(deckId);
    final cardCount = currentCards[cardId] ?? 0;

    if (cardCount > 1) {
      // 減少數量
      await db.update(
        'deck_cards',
        {'card_count': cardCount - 1},
        where: 'deck_id = ? AND card_id = ?',
        whereArgs: [deckId, cardId],
      );
      print(
          '卡片數量減少成功 - Deck ID: $deckId, Card ID: $cardId, New Count: ${cardCount - 1}');
      return 1;
    } else {
      // 完全移除卡片
      return await db.delete(
        'deck_cards',
        where: 'deck_id = ? AND card_id = ?',
        whereArgs: [deckId, cardId],
      );
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
