from fastapi import APIRouter, Query, Depends
from .. import database
from ..models import items
from typing import List, Dict
from fastapi.responses import JSONResponse

router = APIRouter()

@router.get("/api/items")
async def get_items(page: int = Query(1, ge=1), limit: int = Query(10, le=50)):
    start = (page - 1) * limit
    query = items.select().offset(start).limit(limit)
    result = await database.fetch_all(query)

    # 確保 Record 轉換為字典格式
    result_dicts = [dict(row) for row in result]

    # 返回時指定 UTF-8
    return JSONResponse(
        content=result_dicts,
        media_type="application/json",
        headers={"Content-Type": "application/json; charset=utf-8"}
    )