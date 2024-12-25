from fastapi import APIRouter, HTTPException
from app.database import get_db_connection

router = APIRouter()

@router.get("/attributes")
def get_attributes():
    """取得所有屬性分類"""
    try:
        conn = get_db_connection("ptcg_cards.db")
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM attributes")
        attributes = cursor.fetchall()
        conn.close()
        return [dict(row) for row in attributes]
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error retrieving attributes: {e}")

@router.post("/attributes")
def add_attribute(attribute: dict):
    """新增屬性分類"""
    try:
        conn = get_db_connection("ptcg_cards.db")
        cursor = conn.cursor()
        cursor.execute('''
            INSERT INTO attributes (category, value)
            VALUES (?, ?)
        ''', (attribute["category"], attribute["value"]))
        conn.commit()
        attribute_id = cursor.lastrowid
        conn.close()
        return {"id": attribute_id, "message": "Attribute added successfully!"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error adding attribute: {e}")
