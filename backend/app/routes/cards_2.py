# E:\Projects\PTCG_Tools\backend\app\routes\cards_2.py
from fastapi import APIRouter, HTTPException, Query
from fastapi.responses import JSONResponse
from app.database import get_db_connection
import sqlite3

router = APIRouter()

def get_energy_image_url(attribute: str) -> str:
    """
    根據屬性名稱返回對應的圖片網址。
    """
    energy_urls = {
        "無": "https://asia.pokemon-card.com/various_images/energy/Colorless.png",
        "火": "https://asia.pokemon-card.com/various_images/energy/Fire.png",
        "水": "https://asia.pokemon-card.com/various_images/energy/Water.png",
        "草": "https://asia.pokemon-card.com/various_images/energy/Grass.png",
        "電": "https://asia.pokemon-card.com/various_images/energy/Lightning.png",
        "超": "https://asia.pokemon-card.com/various_images/energy/Psychic.png",
        "格": "https://asia.pokemon-card.com/various_images/energy/Fighting.png",
        "惡": "https://asia.pokemon-card.com/various_images/energy/Darkness.png",
        "鋼": "https://asia.pokemon-card.com/various_images/energy/Metal.png",
        "龍": "https://asia.pokemon-card.com/various_images/energy/Dragon.png",
    }
    return energy_urls.get(attribute, "")

def get_energy_image_url_2(attribute: str) -> str:
    """
    根據屬性名稱返回對應的圖片網址。
    """
    energy_urls = {


        "無": "",
        "火": "https://asia.pokemon-card.com/various_images/energy/Fire.png",
        "水": "https://asia.pokemon-card.com/various_images/energy/Water.png",
        "草": "https://asia.pokemon-card.com/various_images/energy/Grass.png",
        "電": "https://asia.pokemon-card.com/various_images/energy/Lightning.png",
        "超": "https://asia.pokemon-card.com/various_images/energy/Psychic.png",
        "格": "https://asia.pokemon-card.com/various_images/energy/Fighting.png",
        "惡": "https://asia.pokemon-card.com/various_images/energy/Darkness.png",
        "鋼": "https://asia.pokemon-card.com/various_images/energy/Metal.png",
        "龍": "https://asia.pokemon-card.com/various_images/energy/Dragon.png",
    }
    return energy_urls.get(attribute, "")
def generate_retreat_cost_images(retreat_cost: str) -> list:

    # 能量圖片網址
    energy_url = ""
    if retreat_cost == "無限制":
        return energy_url
    for i in range(0, int(retreat_cost)):
        energy_url = energy_url + "https://asia.pokemon-card.com/various_images/energy/Colorless.png"+ "," 
    energy_url = energy_url[:-1]


    return energy_url

@router.get("/cards2")
def get_cards(
    name: str = Query(None, description="卡牌名稱"),
    stage: str = Query(None, description="進化階段"),
    min_hp: int = Query(None, ge=0, description="最低HP"),
    max_hp: int = Query(None, ge=0, description="最高HP"),
    skill_name: str = Query(None, description="招式名稱"),
    skill_effect: str = Query(None, description="招式效果"),
    weakness: str = Query(None, description="弱點屬性"),
    resistance: str = Query(None, description="抗性屬性"),
    type: str = Query(None, description="屬性類型"),
    retreat_cost: str = Query(None, description="退場所需能量"),
    page: int = Query(1, ge=1, description="頁碼"),
    limit: int = Query(10, ge=1, description="每頁顯示的卡片數量")
):


    """
    取得卡牌資訊，支持多條件搜尋。
    - `name`: 根據名稱搜尋
    - `stage`: 根據進化階段搜尋
    - `min_hp`: 搜尋HP大於等於此值的卡牌
    - `max_hp`: 搜尋HP小於等於此值的卡牌
    - `skill_name`: 根據招式名稱搜尋
    - `skill_effect`: 根據招式效果搜尋
    - `weakness`: 根據弱點屬性搜尋
    - `resistance`: 根據抗性屬性搜尋
    - `type`: 根據屬性類型搜尋
    - `retreat_cost`: 根據退場所需能量搜尋
    - `page`: 頁碼
    - `limit`: 每頁顯示的卡片數量
    """
    offset = (page - 1) * limit

    try:
        conn = get_db_connection("pokemon_cards.db")
        cursor = conn.cursor()

        # 動態構建SQL語句
        query = "SELECT * FROM cards WHERE 1=1"
        params = []
        
        if name:
            query += " AND name LIKE ?"
            params.append(f"%{name}%")
        if stage and not stage == '全部':
            query += " AND stage = ?"
            params.append((stage))
        if min_hp is not None:
            query += " AND hp >= ?"
            params.append(min_hp)
        if max_hp is not None:
            query += " AND hp <= ?"
            params.append(max_hp)
        if weakness:
            query += " AND weakness_img LIKE ?"
            params.append(f"%{get_energy_image_url_2(weakness)}%")
        if resistance:
            query += " AND resistance_img LIKE ?"
            params.append(f"%{get_energy_image_url_2(resistance)}%")
        if type:
            query += " AND attribute_img = ?"
            params.append(get_energy_image_url(type))
        if retreat_cost and not retreat_cost == "無限制":
            query += " AND retreat_img = ?"
            params.append(generate_retreat_cost_images(retreat_cost))


        query += " LIMIT ? OFFSET ?"
        params.extend([limit, offset])

        cursor.execute(query, params)
        cards = cursor.fetchall()

        # 處理技能過濾條件
        if skill_name or skill_effect:
            filtered_cards = []
            for card in cards:
                cursor.execute("SELECT * FROM skills WHERE card_id = ?", (card["id"],))
                skills = cursor.fetchall()

                for skill in skills:
                    if skill_name and skill_name not in skill["name"]:
                        continue
                    if skill_effect and skill_effect not in skill["effect"]:
                        continue
                    filtered_cards.append(card)
                    break
            cards = filtered_cards
    # 將結果轉換為字典格式
        result = [dict(card) for card in cards]

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"檢索卡片時發生錯誤: {e}")
    finally:
        conn.close()

    return JSONResponse(content=[dict(card) for card in cards], media_type="application/json; charset=utf-8")

@router.get("/cards2/{card_id}")
def get_card_details(card_id: int):
    """
    獲取單張卡片的詳細信息。
    - `card_id`: 卡片的唯一標識符
    """
    try:
        conn = get_db_connection("pokemon_cards.db")
        conn.row_factory = sqlite3.Row  # 確保返回行為字典格式
        cursor = conn.cursor()

        # 查詢卡片基本資訊
        cursor.execute("SELECT * FROM cards WHERE id = ?", (card_id,))
        card = cursor.fetchone()
        if not card:
            raise HTTPException(status_code=404, detail="Card not found")

        # 將 sqlite3.Row 轉換為字典
        card = dict(card)

        # 查詢卡片的技能
        cursor.execute("SELECT * FROM skills WHERE card_id = ?", (card_id,))
        skills = cursor.fetchall()
        card["skills"] = [dict(skill) for skill in skills]

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error retrieving card details: {e}")
    finally:
        conn.close()

    return JSONResponse(content=card, media_type="application/json; charset=utf-8")
