from fastapi import APIRouter, HTTPException, Query
from app.database import get_db_connection
from fastapi.responses import JSONResponse
router = APIRouter()

@router.get("/cards")
def get_cards(
    name: str = Query(None, description="卡牌名稱"),
    evolution_stage: str = Query(None, description="進化階段"),
    rarity: str = Query(None, description="卡牌稀有度"),
    card_type: str = Query(None, alias="type", description="卡牌屬性"),
    min_hp: int = Query(None, ge=0, description="最低HP"),
    max_hp: int = Query(None, ge=0, description="最高HP"),
    move: str = Query(None, description="招式名稱"),
    effect: str = Query(None, description="效果描述"),
    min_damage: int = Query(None, ge=0, description="最低傷害"),
    max_damage: int = Query(None, ge=0, description="最高傷害"),
    weakness: str = Query(None, description="弱點屬性"),
    resistance: str = Query(None, description="抗性屬性"),
    retreat_cost: int = Query(None, ge=0, description="逃跑能量需求")
):
    """
    取得所有卡牌信息，支援多條件搜尋。
    - `name`: 根據名稱搜尋
    - `evolution_stage`: 根據進化階段搜尋
    - `rarity`: 根據稀有度搜尋
    - `type`: 根據屬性搜尋
    - `min_hp`: 搜尋HP大於等於此值的卡牌
    - `max_hp`: 搜尋HP小於等於此值的卡牌
    - `move`: 根據招式名稱搜尋
    - `effect`: 根據效果描述搜尋
    - `min_damage`: 搜尋傷害大於等於此值的卡牌
    - `max_damage`: 搜尋傷害小於等於此值的卡牌
    - `weakness`: 根據弱點屬性搜尋
    - `resistance`: 根據抗性屬性搜尋
    - `retreat_cost`: 根據逃跑能量需求搜尋
    """
    try:
        conn = get_db_connection("ptcg_cards.db")
        cursor = conn.cursor()
        
        # 動態構建 SQL 語句
        query = "SELECT * FROM cards WHERE 1=1"
        params = []

        if name:
            query += " AND name LIKE ?"
            params.append(f"%{name}%")
        if evolution_stage:
            query += " AND evolution_stage = ?"
            params.append(evolution_stage)
        if rarity:
            query += " AND rarity = ?"
            params.append(rarity)
        if card_type:
            query += " AND type = ?"
            params.append(card_type)
        if min_hp is not None:
            query += " AND hp >= ?"
            params.append(min_hp)
        if max_hp is not None:
            query += " AND hp <= ?"
            params.append(max_hp)
        if move:
            query += " AND move LIKE ?"
            params.append(f"%{move}%")
        if effect:
            query += " AND effect LIKE ?"
            params.append(f"%{effect}%")
        if min_damage is not None:
            query += " AND damage >= ?"
            params.append(min_damage)
        if max_damage is not None:
            query += " AND damage <= ?"
            params.append(max_damage)
        if weakness:
            query += " AND weakness LIKE ?"
            params.append(f"%{weakness}%")
        if resistance:
            query += " AND resistance LIKE ?"
            params.append(f"%{resistance}%")
        if retreat_cost is not None:
            query += " AND retreat_cost = ?"
            params.append(retreat_cost)

        cursor.execute(query, params)
        cards = cursor.fetchall()
        conn.close()

        return JSONResponse(content=[dict(row) for row in cards], media_type="application/json; charset=utf-8")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error retrieving cards: {e}")

@router.post("/cards")
def add_card(card: dict):
    """新增卡牌"""
    try:
        conn = get_db_connection("ptcg_cards.db")
        cursor = conn.cursor()
        cursor.execute('''
            INSERT INTO cards (name, evolution_stage, rarity, hp, type, move, effect, damage, weakness, resistance, retreat_cost, image_url)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            card["name"], card["evolution_stage"], card["rarity"], card["hp"],
            card["type"], card["move"], card["effect"], card["damage"],
            card["weakness"], card["resistance"], card["retreat_cost"], card["image_url"]
        ))
        conn.commit()
        card_id = cursor.lastrowid
        conn.close()
        return {"id": card_id, "message": "Card added successfully!"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error adding card: {e}")
