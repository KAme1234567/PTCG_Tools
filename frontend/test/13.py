import sqlite3

# 建立資料庫連接
conn = sqlite3.connect('ptcg_cards.db')
cursor = conn.cursor()
base_url = "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_"
# 創建卡牌表格
cursor.execute('''
CREATE TABLE IF NOT EXISTS cards (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    evolution_stage TEXT,
    rarity TEXT,
    hp INTEGER,
    type TEXT,
    move TEXT,
    effect TEXT,
    damage INTEGER,
    weakness TEXT,
    resistance TEXT,
    retreat_cost INTEGER,
    image_url TEXT
)
''')

# 創建屬性分類表格
cursor.execute('''
CREATE TABLE IF NOT EXISTS attributes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category TEXT,
    value TEXT
)
''')

# 插入屬性分類資料
attributes_data = [
    # 環境
    ("環境", "標準"),
    ("環境", "開放"),
    ("環境", "全部"),
    # 卡牌種類
    ("卡牌種類", "全部"),
    ("卡牌種類", "寶可夢"),
    ("卡牌種類", "訓練家"),
    ("卡牌種類", "能量"),
    # 進化
    ("進化", "基礎"),
    ("進化", "1階進化"),
    ("進化", "2階進化"),
    ("進化", "V進化"),
    ("進化", "V-UNION"),
    # 寶可夢種類
    ("寶可夢種類", "寶可夢ex"),
    ("寶可夢種類", "寶可夢V"),
    ("寶可夢種類", "寶可夢VMAX"),
    ("寶可夢種類", "寶可夢VSTAR"),
    ("寶可夢種類", "寶可夢GX"),
    ("寶可夢種類", "究極異獸"),
    # 其他能力
    ("其他能力", "無特性"),
    ("其他能力", "有特性"),
    ("其他能力", "太晶化"),
    # 屬性
    ("屬性", "草"),
    ("屬性", "火"),
    ("屬性", "水"),
    ("屬性", "電"),
    ("屬性", "超"),
    ("屬性", "格"),
    ("屬性", "惡"),
    ("屬性", "鋼"),
    ("屬性", "無"),
    ("屬性", "妖"),
    ("屬性", "龍"),
    # 弱點
    ("弱點", "草"),
    ("弱點", "火"),
    ("弱點", "水"),
    ("弱點", "電"),
    ("弱點", "超"),
    ("弱點", "格"),
    ("弱點", "惡"),
    ("弱點", "鋼"),
    ("弱點", "無"),
    ("弱點", "妖"),
    ("弱點", "龍"),
    ("弱點", "無弱點"),
    # 抵抗力
    ("抵抗力", "草"),
    ("抵抗力", "火"),
    ("抵抗力", "水"),
    ("抵抗力", "電"),
    ("抵抗力", "超"),
    ("抵抗力", "格"),
    ("抵抗力", "惡"),
    ("抵抗力", "鋼"),
    ("抵抗力", "無"),
    ("抵抗力", "妖"),
    ("抵抗力", "龍"),
    ("抵抗力", "無抵抗力"),
    # 特別卡牌
    ("特別卡牌", "ACE SPEC"),
    ("特別卡牌", "古代"),
    ("特別卡牌", "未來"),
    ("特別卡牌", "一擊"),
    ("特別卡牌", "連擊"),
    ("特別卡牌", "匯流"),
    ("特別卡牌", "TagTeam"),
    ("特別卡牌", "稜柱之星"),
    # 稀有度
    ("稀有度", "R"),
    ("稀有度", "RR"),
    ("稀有度", "RRR"),
    ("稀有度", "SR"),
    ("稀有度", "CHR"),
    ("稀有度", "CSR"),
    ("稀有度", "AR"),
    ("稀有度", "SAR"),
    ("稀有度", "S"),
    ("稀有度", "SSR"),
    ("稀有度", "HR"),
    ("稀有度", "UR")
]

cursor.executemany('''
INSERT INTO attributes (category, value)
VALUES (?, ?)
''', attributes_data)

# 插入範例卡牌資料
cards_data = [
    ("含羞苞", "基礎", "R", 30, "草", "癢癢花粉", "在下個對手的回合，對手無法從手牌使出物品卡", 10, "火×2", "電-30", 3, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_001.jpg"),
    ("噴火龍", "2階進化", "SR", 170, "火", "火焰風暴", "丟棄2張能量卡，造成大範圍傷害", 120, "水×2", "無", 4, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_2.jpg"),
    ("皮卡丘", "基礎", "RR", 60, "電", "十萬伏特", "有50%的機率讓對手麻痺", 50, "格×2", "鋼-30", 1, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_3.jpg"),
    ("小火龍", "基礎", "R", 50, "火", "小火苗", "基礎攻擊", 20, "水×2", "無", 1, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_4.jpg"),
    ("卡比獸", "基礎", "RR", 120, "無", "滾動", "基礎傷害並可能麻痺對手", 40, "格×2", "無", 4, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_5.jpg"),
    ("水箭龜", "2階進化", "SR", 140, "水", "水砲", "對目標造成大範圍傷害", 100, "電×2", "無", 3, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_6.jpg"),
    ("妙蛙種子", "基礎", "R", 40, "草", "綠葉攻擊", "回復自身生命", 20, "火×2", "水-30", 1, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_7.jpg"),
    ("胡地", "2階進化", "RR", 90, "超", "念力攻擊", "對對手造成精神傷害", 50, "惡×2", "超-30", 2, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_8.jpg"),
    ("噴水魚", "基礎", "R", 30, "水", "水花飛濺", "對敵方造成小範圍水攻擊", 10, "電×2", "無", 0, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_9.jpg"),
    ("暴鯉龍", "1階進化", "SR", 160, "水", "龍捲風", "強力水屬性傷害", 130, "電×2", "鋼-30", 4, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_010.jpg"),
    ("雷丘", "1階進化", "RR", 90, "電", "雷擊", "快速放電", 60, "格×2", "鋼-30", 1, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_011.jpg"),
    ("伊布", "基礎", "R", 50, "無", "尾巴甩動", "基礎物理傷害", 30, "格×2", "無", 1, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_012.jpg"),
    ("拉普拉斯", "基礎", "RR", 110, "水", "冰凍光線", "冰凍敵人", 70, "電×2", "無", 3, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_013.jpg"),
    ("烈焰猴", "2階進化", "SR", 140, "火", "火焰拳", "基礎火焰傷害", 90, "水×2", "草-30", 2, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_014.jpg"),
    ("噪音鳥", "基礎", "R", 40, "妖", "歌聲攻擊", "對敵人造成聲音傷害", 20, "鋼×2", "超-30", 1, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_015.jpg"),
    ("雙彈瓦斯", "1階進化", "RR", 90, "毒", "毒霧", "讓對手進入中毒狀態", 40, "超×2", "鋼-30", 1, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_016.jpg"),
    ("巨金怪", "2階進化", "SR", 150, "鋼", "鋼爪", "強力金屬攻擊", 100, "火×2", "草-30", 3, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_017.jpg"),
    ("快龍", "2階進化", "RR", 160, "龍", "龍息", "可能讓對手麻痺", 120, "妖×2", "無", 3, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_018.jpg"),
    ("小磁怪", "基礎", "R", 30, "電", "磁場控制", "對敵方造成小範圍傷害", 10, "火×2", "鋼-30", 1, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_019.jpg"),
    ("超夢", "基礎", "SR", 130, "超", "念動波", "對敵方造成強烈精神攻擊", 90, "惡×2", "格-30", 2, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_020.jpg"),
    ("大岩蛇", "基礎", "R", 100, "岩", "地震", "對所有敵方造成傷害", 50, "水×2", "草-30", 4, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_021.jpg"),
    ("胖丁", "基礎", "RR", 60, "妖", "可愛歌聲", "讓對方進入睡眠狀態", 20, "鋼×2", "無", 1, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_022.jpg"),
    ("火焰鳥", "基礎", "SR", 120, "火", "火焰之翼", "大範圍火焰攻擊", 100, "水×2", "草-30", 2, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_023.jpg"),
    ("大嘴蝠", "1階進化", "R", 70, "毒", "毒擊", "讓對手進入中毒狀態", 30, "電×2", "格-30", 1, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_024.jpg"),
    ("風速狗", "1階進化", "RR", 120, "火", "火焰衝撞", "快速火焰攻擊", 80, "水×2", "草-30", 2, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_025.jpg"),
    ("鯉魚王", "基礎", "R", 20, "水", "飛濺", "沒有實際效果", 0, "電×2", "無", 0, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_026.jpg"),
    ("凱路迪歐", "基礎", "RR", 90, "水", "水之刃", "對對手造成快速水攻擊", 60, "電×2", "火-30", 1, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_027.jpg"),
    ("暗影獸", "基礎", "SR", 100, "惡", "暗影爪", "對敵方造成高強度傷害", 90, "格×2", "無", 2, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_028.jpg"),
    ("閃電鳥", "基礎", "SR", 100, "電", "閃電俯衝", "快速放電傷害", 80, "格×2", "鋼-30", 1, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_029.jpg"),
    ("急凍鳥", "基礎", "SR", 100, "水", "寒冰之力", "凍結對手", 80, "電×2", "無", 2, "https://as.ptcgsp.com/assets/images/card_images/tc/SV8a/SV8a_030.jpg")
]

cursor.executemany('''
INSERT INTO cards (name, evolution_stage, rarity, hp, type, move, effect, damage, weakness, resistance, retreat_cost, image_url)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
''', cards_data)

# 保存並關閉資料庫
conn.commit()
conn.close()

print("卡牌資料庫已建立並插入分類與範例數據！")
