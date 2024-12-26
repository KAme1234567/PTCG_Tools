# backend\app\routes\special_cases.py
from fastapi import APIRouter, HTTPException
from fastapi.responses import JSONResponse
from app.database import get_db_connection

router = APIRouter()

DATABASE_NAME = "ptcg_special_cases.db"

@router.get("/special_cases")
def list_special_cases():
    """
    列出所有特殊判例
    """
    try:
        conn = get_db_connection(DATABASE_NAME)
        cursor = conn.cursor()
        cursor.execute("SELECT id, title, description, image_url FROM special_cases")
        cases = cursor.fetchall()
        return JSONResponse(
            content=[dict(case) for case in cases],
            media_type="application/json; charset=utf-8"
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"發生錯誤: {e}")
    finally:
        conn.close()

@router.get("/special_cases/{case_id}")
def get_special_case(case_id: int):
    """
    根據 ID 獲取特殊判例詳細資訊
    """
    try:
        conn = get_db_connection(DATABASE_NAME)
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM special_cases WHERE id = ?", (case_id,))
        case = cursor.fetchone()
        if not case:
            raise HTTPException(status_code=404, detail="未找到該特殊判例")
        return JSONResponse(content=dict(case), media_type="application/json; charset=utf-8")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"發生錯誤: {e}")
    finally:
        conn.close()
