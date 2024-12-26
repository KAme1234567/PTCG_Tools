from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI
from fastapi.responses import JSONResponse


from app.routes import cards, attributes, items

app = FastAPI()

# 加入 CORS 中間件
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 或指定前端 URL，例如 "http://localhost:8080"
    allow_credentials=True,
    allow_methods=["*"],  # 允許所有 HTTP 方法
    allow_headers=["*"],  # 允許所有 HTTP 標頭
)
# 包含路由
app.include_router(items.router, prefix="/api")
app.include_router(cards.router, prefix="/api")
app.include_router(attributes.router, prefix="/api")

@app.get("/")
def read_root():
    return {"message": "歡迎使用 PTCGasd 工具 API"}
