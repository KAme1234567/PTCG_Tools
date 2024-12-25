from fastapi import APIRouter, HTTPException, Query
from app.database import get_db_connection
from fastapi.responses import JSONResponse
router = APIRouter()

@router.get("/items")
def get_items(page: int = Query(1, ge=1), limit: int = Query(10, ge=1)):
    """
    獲取項目列表，支援分頁功能。
    :param page: 第幾頁 (預設為1)
    :param limit: 每頁顯示的數量 (預設為10)
    """
    offset = (page - 1) * limit
    conn = get_db_connection("items.db")
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT * FROM items LIMIT ? OFFSET ?", (limit, offset))
        items = cursor.fetchall()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        conn.close()
    return JSONResponse(content=[dict(row) for row in items], media_type="application/json; charset=utf-8")



@router.post("/items")
def add_item(name: str, category_id: int):
    """
    新增一個項目。
    :param name: 項目名稱
    :param category_id: 分類 ID
    """
    conn = get_db_connection("items.db")
    cursor = conn.cursor()
    try:
        cursor.execute("INSERT INTO items (name, category_id) VALUES (?, ?)", (name, category_id))
        conn.commit()
        item_id = cursor.lastrowid
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        conn.close()
    return {"id": item_id, "name": name, "category_id": category_id}