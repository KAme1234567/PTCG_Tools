import sqlite3

def get_db_connection(db_name):
    try:
        conn = sqlite3.connect(f"E:/Projects/PTCG_Tools/backend/app/database/{db_name}")
        conn.row_factory = sqlite3.Row
        conn.text_factory = str  # 確保處理文本資料時使用 UTF-8
        return conn
    except Exception as e:
        raise Exception(f"Database connection error: {e}")
    
