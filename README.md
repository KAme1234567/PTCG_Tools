此為國立高雄科技大學
app設計作業
指導老師:張鉑銀
組長:王建翔
組員:溫維智

## 🚀 快速開始

### 1. 🔧 後端 (FastAPI)

#### **🌟 環境準備**

1. 確保安裝了 🐍 Python 3.8+
2. 創建虛擬環境：
   ```bash
   python -m venv fastvue
   ```
3. 啟動虛擬環境：
   - 🪟 Windows:
     ```bash
     fastvue\Scripts\activate
     ```
   - 🐧 Linux/Mac:
     ```bash
     source fastvue/bin/activate
     ```
4. 安裝依賴：
   ```bash
   pip install fastapi uvicorn
   ```
5. 保存依賴到 `requirements.txt`：
   ```bash
   pip freeze > requirements.txt
   ```

#### **▶️ 運行後端伺服器**

```bash
cd backend
uvicorn app.main:app --reload
# 或
python -m uvicorn app.main:app --reload

```

伺服器會在 `http://127.0.0.1:8000` 運行。

---

### 2. 🎨 前端 (Vue.js)

#### **🌟 環境準備**

1. 確保安裝了 🟢 Node.js 和 📦 npm。
2. 安裝 Vue CLI：
   ```bash
   npm install -g @vue/cli
   ```
3. 初始化項目：
   ```bash
   vue create frontend
   ```
   選擇 Vue 3 並包含 Router 和 Vuex。

#### **▶️ 運行前端開發伺服器**

```bash
cd frontend
npm run serve
```

開發伺服器會在 `http://localhost:8080` 運行。

---## 🚀 快速開始

### 1. 🔧 後端 (FastAPI)

#### **🌟 環境準備**

1. 確保安裝了 🐍 Python 3.8+
2. 創建虛擬環境：
   ```bash
   python -m venv fastvue
   ```
3. 啟動虛擬環境：
   - 🪟 Windows:
     ```bash
     fastvue\Scripts\activate
     ```
   - 🐧 Linux/Mac:
     ```bash
     source fastvue/bin/activate
     ```
4. 安裝依賴：
   ```bash
   pip install fastapi uvicorn
   ```
5. 保存依賴到 `requirements.txt`：
   ```bash
   pip freeze > requirements.txt
   ```

#### **▶️ 運行後端伺服器**

```bash
cd backend
uvicorn app.main:app --reload
# 或
python -m uvicorn app.main:app --reload
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8745


```

伺服器會在 `http://127.0.0.1:8000` 運行。

---

### 2. 🎨 前端 (Vue.js)

#### **🌟 環境準備**

1. 確保安裝了 🟢 Node.js 和 📦 npm。
2. 安裝 Vue CLI：
   ```bash
   npm install -g @vue/cli
   ```
3. 初始化項目：
   ```bash
   vue create frontend
   ```
   選擇 Vue 3 並包含 Router 和 Vuex。

#### **▶️ 運行前端開發伺服器**
 
```bash
cd frontend
npm run serve
```

開發伺服器會在 `http://localhost:8080` 運行。

---