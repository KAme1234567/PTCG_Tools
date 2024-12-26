# backend\app\routes\columns.py
from fastapi import APIRouter, HTTPException
from fastapi.responses import JSONResponse
from app.database import get_db_connection

router = APIRouter()

DATABASE_NAME = "ptcg_column_articles.db"

@router.get("/columns")
def list_articles():
    """
    列出所有專欄文章。
    """
    try:
        conn = get_db_connection(DATABASE_NAME)
        cursor = conn.cursor()
        cursor.execute("SELECT id, title, author, image_url FROM articles")
        articles = cursor.fetchall()
        return JSONResponse(
            content=[dict(article) for article in articles],
            media_type="application/json; charset=utf-8"
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"發生錯誤: {e}")
    finally:
        conn.close()

@router.get("/columns/{article_id}")
def get_article(article_id: int):
    """
    根據文章 ID 獲取文章詳細資訊。
    - `article_id`: 文章的唯一標識符
    """
    try:
        conn = get_db_connection(DATABASE_NAME)
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM articles WHERE id = ?", (article_id,))
        article = cursor.fetchone()
        if not article:
            raise HTTPException(status_code=404, detail="未找到對應的文章")
        return JSONResponse(
            content=dict(article),
            media_type="application/json; charset=utf-8"
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"發生錯誤: {e}")
    finally:
        conn.close()