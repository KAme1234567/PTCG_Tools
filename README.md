# 國立高雄科技大學 APP 設計作業

## 寶可夢卡牌攻略 APP 開發計劃

**指導老師**: 張鋇銀  
**組長**: 王建翔  
**組員**: 溫維智  

## 📚 APP 開發目的與特色

### 1. 動機與目標
- **降低學習門檻**：針對新手玩家，提供詳細的規則教學與繁體中文翻譯的熱門牌組，縮短學習曲線。
- **整合資源**：匯集日本「上位牌組」的資料，並輔以深入分析與說明，讓玩家掌握最新的國際玩法趨勢。
- **交易安全性**：通過實名認證和評價系統，建立安全可靠的卡牌交易環境，降低詐騙風險。

### 2. 功能亮點
- **遊戲教學**：結合圖文與互動方式，幫助新手快速上手。
- **牌組推薦**：定期更新比賽熱門牌組，並提供策略分析。
- **發行日期提醒**：輕鬆查詢新卡發行資訊，快速掌握市場動態。

---

## 📊 開發方法與架構

1. **後端**：採用 FastAPI 搭建輕量級 RESTful API，確保高效的數據處理與安全性。
2. **前端**：使用 Flutter 提供流暢的使用者體驗，結合狀態管理套件。
3. **資料庫**：將採用 SQL 或 NoSQL 儲存用戶、卡牌和交易數據，確保穩定性。

---

## 🔍 未來發展與展望

- **擴展社交互動**：新增玩家討論區，促進社群交流。
- **大數據分析**：通過數據分析，推薦個性化牌組與策略。
- **多語言支援**：逐步添加英語、日語版本，讓平台能服務更多地區的玩家。



## 🚀 快速開始

### 1. 🔧 後端 - 使用 FastAPI

#### 🌟 環境準備
1. 確保安裝 **Python 3.8+**。
2. 創建虛擬環境：  
   ```bash
   python -m venv fastvue
   ```
3. 啟動虛擬環境：  
   - **Windows**:  
     ```bash
     fastvue\Scripts\activate
     ```
   - **Linux/Mac**:  
     ```bash
     source fastvue/bin/activate
     ```
4. 安裝必要套件：  
   ```bash
   pip install fastapi uvicorn
   ```
5. 將依讀保存至 `requirements.txt`：  
   ```bash
   pip freeze > requirements.txt
   ```

#### ▶️ 運行後端伺服器
1. 進入後端專案資料夾：  
   ```bash
   cd backend
   ```
2. 啟動伺服器：  
   ```bash
   uvicorn app.main:app --reload
   ```
   - 或者指定特定埠號和主機：  
     ```bash
     python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8745
     ```
3. 預設伺服器將運行於 `http://127.0.0.1:8000`。

---

### 2. 🎨 前端 - 使用 Flutter

#### 🌟 環境準備
1. 確保安裝 **Flutter SDK**，並安裝依讀的開發環境。
2. 創建 Flutter 專案：  
   ```bash
   flutter create frontend
   ```
3. 進入專案資料夾：  
   ```bash
   cd frontend
   ```
4. 安裝所需套件：  
   ```bash
   flutter pub get
   ```

#### ▶️ 運行前端開發伺服器
1. 啟動 Flutter 模擬器或連接實體設備。
2. 運行應用：  
   ```bash
   flutter run
   ```
3. 預設應用將上線於連接的設備。

---

