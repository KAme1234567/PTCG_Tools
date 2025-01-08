# backend\app\main.py
from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI
from fastapi.responses import JSONResponse





from app.routes import cards, attributes, items,cards_2,columns,special_cases,deck_api

app = FastAPI()


# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 或指定前端 URL，例如 "http://localhost:8080"
    allow_credentials=True,
    allow_methods=["*"],  # 允許所有 HTTP 方法
    allow_headers=["*"],  # 允許所有 HTTP 標頭
)
@app.middleware("http")
async def add_skip_warning_header(request, call_next):
    response = await call_next(request)
    response.headers["ngrok-skip-browser-warning"] = "true"
    return response
# 包含路由
app.include_router(items.router, prefix="/api")
app.include_router(cards.router, prefix="/api")
app.include_router(attributes.router, prefix="/api")
app.include_router(cards_2.router, prefix="/api")
app.include_router(columns.router, prefix="/api")
app.include_router(special_cases.router, prefix="/api")
app.include_router(deck_api.router, prefix="/api")

@app.get("/")
def read_root():
    return {"message": "歡迎使用 PTCGasd ddd工具 API"}
