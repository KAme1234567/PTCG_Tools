from databases import Database
from sqlalchemy import create_engine, MetaData
DATABASE_URL = "sqlite:///E:/Projects/PTCG_Tools/backend/app/database/test.db"

 # SQLite 資料庫路徑

database = Database(DATABASE_URL)
metadata = MetaData()
# 引入表格模型
from .models import items
engine = create_engine(DATABASE_URL)
metadata.create_all(engine)
