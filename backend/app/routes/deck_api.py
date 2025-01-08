from fastapi import APIRouter, HTTPException, Query
from fastapi.responses import JSONResponse
from app.database import get_db_connection
import sqlite3

router = APIRouter()

@router.get("/decks")
def get_decks(page: int = Query(1, ge=1, description="頁碼"),
              limit: int = Query(10, ge=1, description="每頁顯示的牌組數量")):
    """
    獲取所有牌組，支持分頁。
    - `page`: 頁碼
    - `limit`: 每頁顯示的牌組數量
    """
    offset = (page - 1) * limit

    try:
        conn = get_db_connection("decks.db")
        cursor = conn.cursor()
        
        cursor.execute("SELECT * FROM decks LIMIT ? OFFSET ?", (limit, offset))
        decks = cursor.fetchall()
        
        result = [dict(deck) for deck in decks]
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"檢索牌組時發生錯誤: {e}")
    finally:
        conn.close()

    return JSONResponse(content=result, media_type="application/json; charset=utf-8")

@router.post("/decks")
def add_deck(name: str, description: str):
    """
    添加新牌組。
    - `name`: 牌組名稱
    - `description`: 牌組描述
    """
    try:
        conn = get_db_connection("decks.db")
        cursor = conn.cursor()
        
        cursor.execute("INSERT INTO decks (name, description) VALUES (?, ?)", (name, description))
        conn.commit()
        
        return {"message": "牌組已成功添加", "deck_id": cursor.lastrowid}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"添加牌組時發生錯誤: {e}")
    finally:
        conn.close()

@router.delete("/decks/{deck_id}")
def delete_deck(deck_id: int):
    """
    刪除指定的牌組。
    - `deck_id`: 牌組的唯一標識符
    """
    try:
        conn = get_db_connection("decks.db")
        cursor = conn.cursor()
        
        cursor.execute("DELETE FROM decks WHERE id = ?", (deck_id,))
        conn.commit()

        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="牌組未找到")
        
        return {"message": "牌組已成功刪除"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"刪除牌組時發生錯誤: {e}")
    finally:
        conn.close()

@router.post("/decks/{deck_id}/cards")
def add_card_to_deck(deck_id: int, card_id: int):
    """
    添加卡片到指定牌組。
    - `deck_id`: 牌組的唯一標識符
    - `card_id`: 卡片的唯一標識符
    """
    try:
        conn = get_db_connection("decks.db")
        cursor = conn.cursor()

        # 獲取當前卡片數量
        cursor.execute("SELECT card_count FROM deck_cards WHERE deck_id = ? AND card_id = ?", (deck_id, card_id))
        result = cursor.fetchone()

        if result:
            card_count = result[0]
            if card_count >= 4:
                raise HTTPException(status_code=400, detail="同一張卡片已達到 4 張的上限")
            
            cursor.execute("UPDATE deck_cards SET card_count = card_count + 1 WHERE deck_id = ? AND card_id = ?", (deck_id, card_id))
        else:
            cursor.execute("INSERT INTO deck_cards (deck_id, card_id, card_count) VALUES (?, ?, 1)", (deck_id, card_id))

        conn.commit()
        return {"message": "卡片已成功添加到牌組"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"添加卡片時發生錯誤: {e}")
    finally:
        conn.close()

@router.delete("/decks/{deck_id}/cards/{card_id}")
def remove_card_from_deck(deck_id: int, card_id: int):
    """
    從指定牌組中移除卡片。
    - `deck_id`: 牌組的唯一標識符
    - `card_id`: 卡片的唯一標識符
    """
    try:
        conn = get_db_connection("decks.db")
        cursor = conn.cursor()

        cursor.execute("SELECT card_count FROM deck_cards WHERE deck_id = ? AND card_id = ?", (deck_id, card_id))
        result = cursor.fetchone()

        if not result:
            raise HTTPException(status_code=404, detail="卡片未找到")

        card_count = result[0]
        if card_count > 1:
            cursor.execute("UPDATE deck_cards SET card_count = card_count - 1 WHERE deck_id = ? AND card_id = ?", (deck_id, card_id))
        else:
            cursor.execute("DELETE FROM deck_cards WHERE deck_id = ? AND card_id = ?", (deck_id, card_id))

        conn.commit()
        return {"message": "卡片已成功從牌組移除"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"移除卡片時發生錯誤: {e}")
    finally:
        conn.close()

@router.get("/decks/{deck_id}/cards")
def get_deck_cards(deck_id: int):
    """
    獲取指定牌組中的所有卡片 ID。
    - `deck_id`: 牌組的唯一標識符
    """
    try:
        conn = get_db_connection("decks.db")
        cursor = conn.cursor()

        cursor.execute("SELECT card_id, card_count FROM deck_cards WHERE deck_id = ?", (deck_id,))
        cards = cursor.fetchall()

        result = [{"card_id": card[0], "card_count": card[1]} for card in cards]
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"檢索卡片時發生錯誤: {e}")
    finally:
        conn.close()

    return JSONResponse(content=result, media_type="application/json; charset=utf-8")
