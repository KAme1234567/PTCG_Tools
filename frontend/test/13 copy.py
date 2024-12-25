import sqlite3

# 確保資料庫連接正常
conn = sqlite3.connect("ptcg_cards.db")
cursor = conn.cursor()

# 檢查資料庫編碼
cursor.execute("PRAGMA encoding;")
encoding = cursor.fetchone()[0]
print(f"Database Encoding: {encoding}")

# 如果不是 UTF-8，需要重新創建資料庫
if encoding != "UTF-8":
    print("Database is not UTF-8 encoded. Please recreate the database with UTF-8.")
