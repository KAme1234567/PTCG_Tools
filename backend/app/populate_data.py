import asyncio
from backend.app import database, models

 # 確保路徑正確，`models` 是資料表的定義

async def populate_data():
    await database.connect()  # 連接資料庫

    query = models.items.insert()  # 準備插入語句
    fake_data = [
        {
            "title": "太晶慶典",
            "thumbnail": "https://cs-a.ecimg.tw/items/DGBJQ9A900I3AOX/000001_1732084186.jpg",
            "description": "這是一段測試描述文字114514。",
        },
        *[
            {
                "title": f"項目 {i}",
                "thumbnail": "https://via.placeholder.com/80",
                "description": f"這是項目的簡要描述 {i}."
            }
            for i in range(1,10)  # 插入 120 筆測試數據
        ]
    ]
    # 插入假數據到資料庫
    await database.execute_many(query=query, values=fake_data)

    await database.disconnect()  # 關閉資料庫連接
    print("資料填充完成！")

if __name__ == "__main__":
    asyncio.run(populate_data())  # 運行資料填充函數
