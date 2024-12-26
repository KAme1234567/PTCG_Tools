import requests
from bs4 import BeautifulSoup
import sqlite3
import re

def fetch_card_details(url):
    response = requests.get(url)
    if response.status_code != 200:
        print(f"Failed to fetch {url}: {response.status_code}")
        return None

    soup = BeautifulSoup(response.content, "html.parser")

    # Card name and stage
    header = soup.find("h1", class_="pageHeader cardDetail")
    if not header:
        print(f"Failed to find header for {url}")
        return None

    stage = header.find("span", class_="evolveMarker").text.strip() if header.find("span", class_="evolveMarker") else ""
    name = header.text.replace(stage, "").strip()
    PTCG_img = soup.find("div", class_="cardImage").find("img")["src"] if soup.find("div", class_="cardImage") and soup.find("div", class_="cardImage").find("img") else ""

    print(f"Stage: {stage}")
    print(f"Name: {name}")
    print(f"PTCG Image: {PTCG_img}")

    # HP and attribute
    main_info = soup.find("p", class_="mainInfomation")
    if not main_info:
        print(f"Failed to find main information for {url}")
        return None

    hp = main_info.find("span", class_="number").text.strip() if main_info.find("span", class_="number") else ""
    attribute_img = main_info.find("img")["src"] if main_info.find("img") else ""

    print(f"HP: {hp}")
    print(f"Attribute Image: {attribute_img}")

    # Skills
    skills = []
    for skill in soup.find_all("div", class_="skill"):
        skill_name = skill.find("span", class_="skillName").text.strip() if skill.find("span", class_="skillName") else ""
        skill_cost = [img["src"] for img in skill.find("span", class_="skillCost").find_all("img")] if skill.find("span", class_="skillCost") else []
        skill_damage = skill.find("span", class_="skillDamage").text.strip() if skill.find("span", class_="skillDamage") else ""
        skill_effect = skill.find("p", class_="skillEffect").text.strip() if skill.find("p", class_="skillEffect") else ""
        skills.append({"name": skill_name, "cost": skill_cost, "damage": skill_damage, "effect": skill_effect})

        print(f"Skill Name: {skill_name}")
        print(f"Skill Cost: {skill_cost}")
        print(f"Skill Damage: {skill_damage}")
        print(f"Skill Effect: {skill_effect}")

    # Additional information (weakness, resistance, retreat)
    table = soup.find("div", class_="subInformation").find("table") if soup.find("div", class_="subInformation") else None
    if not table:
        print(f"Failed to find additional information table for {url}")
        return None

    rows = table.find_all("tr") if table else []
    if len(rows) < 2:
        print(f"Failed to find enough rows in the table for {url}")
        return None

    weakness = rows[1].find("td", class_="weakpoint").text.strip() if rows[1].find("td", class_="weakpoint") else ""
    weakness_img = rows[1].find("td", class_="weakpoint").find("img")["src"].strip() if rows[1].find("td", class_="weakpoint") and rows[1].find("td", class_="weakpoint").find("img") else ""

    resistance = rows[1].find("td", class_="resist").text.strip() if rows[1].find("td", class_="resist") else ""
    resistance_img = rows[1].find("td", class_="resist").find("img")["src"].strip() if rows[1].find("td", class_="resist") and rows[1].find("td", class_="resist").find("img") else ""
    retreat_img = [img["src"] for img in rows[1].find("td", class_="escape").find_all("img")] if rows[1].find("td", class_="escape") else []

    print(f"Weakness: {weakness}")
    print(f"Weakness Image: {weakness_img}")
    print(f"Resistance: {resistance}")
    print(f"Resistance Image: {resistance_img}")
    print(f"Retreat Image: {retreat_img}")

    return {
        "stage": stage,
        "name": name,
        "PTCG_img": PTCG_img,
        "hp": hp,
        "attribute_img": attribute_img,
        "skills": skills,
        "weakness_img": weakness_img,
        "weakness": weakness,
        "resistance_img": resistance_img,
        "resistance": resistance,
        "retreat_img": retreat_img
    }

def save_to_database(cards, db_name="pokemon_cards.db"):
    conn = sqlite3.connect(db_name)
    cursor = conn.cursor()

    # Create table
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        PTCG_img TEXT,           
        stage TEXT,
        hp TEXT,
        attribute_img TEXT,
        weakness_img TEXT,
        weakness TEXT,
        resistance_img TEXT,
        resistance TEXT,
        retreat_img TEXT
    )
    """)

    cursor.execute("""
    CREATE TABLE IF NOT EXISTS skills (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        card_id INTEGER,
        name TEXT,
        cost TEXT,
        damage TEXT,
        effect TEXT,
        FOREIGN KEY (card_id) REFERENCES cards (id)
    )
    """)

    # Insert data
    for card in cards:
        cursor.execute("""
        INSERT INTO cards (name, PTCG_img, stage, hp, attribute_img, weakness_img, weakness,resistance_img, resistance, retreat_img)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            card["name"],
            card["PTCG_img"],
            card["stage"],
            card["hp"], 
            card["attribute_img"], 
            card["weakness_img"],
            card["weakness"],  
            card["resistance_img"],
            card["resistance"],
            ",".join(card["retreat_img"])
            ))

        card_id = cursor.lastrowid
        for skill in card["skills"]:
            cursor.execute("""
            INSERT INTO skills (card_id, name, cost, damage, effect)
            VALUES (?, ?, ?, ?, ?)
            """, (card_id, skill["name"], ",".join(skill["cost"]), skill["damage"], skill["effect"]))

    conn.commit()
    conn.close()

def main():
    base_url = "https://asia.pokemon-card.com/tw/card-search/detail/"
    start_id = 11526
    end_id = 11661


    cards = []

    for card_id in range(start_id, end_id + 1):
        url = f"{base_url}{card_id}/"
        print(f"抓取: {url}")
        try:
            card_details = fetch_card_details(url)
            print("獲取1")
            cards.append(card_details)
        except Exception as e:
            print(f"獲取失敗{url}: {e}")

    save_to_database(cards)
    print("資料庫保存成功！")

if __name__ == "__main__":
    main()
