# 🌐 Deploy AI Translation Web App

Build đã hoàn thành! Web app nằm trong folder `build/web/`

## 📁 Files đã build:

```
build/web/
├── index.html          # Main HTML file
├── main.dart.js        # Compiled Dart code
├── flutter.js          # Flutter engine
├── assets/             # App assets
├── icons/              # App icons
└── ...
```

## 🚀 Các cách deploy:

### 1️⃣ **Vercel** (Khuyến nghị - Miễn phí, dễ nhất)

```bash
# Cài Vercel CLI
npm i -g vercel

# Deploy
cd build/web
vercel --prod
```

**Hoặc dùng Vercel Dashboard:**
1. Vào https://vercel.com
2. Import project
3. Chọn folder `build/web`
4. Deploy!

---

### 2️⃣ **Netlify** (Miễn phí)

```bash
# Cài Netlify CLI
npm i -g netlify-cli

# Deploy
cd build/web
netlify deploy --prod
```

**Hoặc drag & drop:**
1. Vào https://app.netlify.com/drop
2. Kéo thả folder `build/web`
3. Done!

---

### 3️⃣ **Firebase Hosting** (Miễn phí)

```bash
# Cài Firebase CLI
npm i -g firebase-tools

# Login
firebase login

# Init
firebase init hosting

# Chọn folder: build/web

# Deploy
firebase deploy
```

---

### 4️⃣ **GitHub Pages** (Miễn phí)

```bash
# Copy build/web to docs/
cp -r build/web docs/

# Push to GitHub
git add docs/
git commit -m "Deploy web app"
git push

# Vào GitHub repo Settings → Pages
# Source: main branch, /docs folder
```

---

### 5️⃣ **Cloudflare Pages** (Miễn phí)

1. Vào https://pages.cloudflare.com
2. Upload folder `build/web`
3. Deploy!

---

## 🧪 Test local trước khi deploy:

```bash
# Cài http-server
npm i -g http-server

# Chạy local
cd build/web
http-server -p 8080

# Mở browser: http://localhost:8080
```

---

## ⚙️ Cấu hình cho production:

### **1. Update web/index.html** (nếu cần)

Thêm meta tags cho SEO:

```html
<meta name="description" content="AI Translation with 3-agent pipeline">
<meta name="keywords" content="AI, Translation, Flutter">
<meta property="og:title" content="AI Translation Workflow">
<meta property="og:description" content="Professional translation with AI">
```

### **2. Update web/manifest.json**

```json
{
  "name": "AI Translation Workflow",
  "short_name": "AI Translate",
  "description": "AI-powered translation with 3-agent pipeline",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#2196F3"
}
```

### **3. CORS Configuration**

Nếu gặp CORS error khi call API, cần:
- Thêm CORS headers ở API server
- Hoặc dùng proxy
- Hoặc deploy backend riêng

---

## 📊 Build size optimization:

Current build đã được optimize:
- ✅ Tree-shaking icons (99.5% reduction)
- ✅ Minified JS
- ✅ Compressed assets

Để optimize thêm:

```bash
# Build với CanvasKit (better performance)
flutter build web --release --web-renderer canvaskit

# Build với HTML renderer (smaller size)
flutter build web --release --web-renderer html
```

---

## 🔒 Security Notes:

⚠️ **QUAN TRỌNG:**

1. **API Key**: Không hardcode API key trong web app
   - User phải tự nhập API key trong Settings
   - Hoặc dùng backend proxy để ẩn API key

2. **HTTPS**: Deploy trên HTTPS (tất cả platforms trên đều support)

3. **Environment**: Web app sẽ lưu settings trong browser localStorage

---

## 📱 PWA (Progressive Web App):

App đã support PWA! User có thể:
- Install app lên home screen
- Dùng offline (với service worker)
- Nhận notifications

---

## 🎯 Recommended: **Vercel**

Lý do:
- ✅ Miễn phí
- ✅ Auto HTTPS
- ✅ CDN global
- ✅ Deploy trong 1 phút
- ✅ Custom domain miễn phí

**Quick deploy:**
```bash
cd build/web
npx vercel --prod
```

---

## 📝 Post-deployment:

1. Test trên mobile browsers
2. Test PWA install
3. Check API connectivity
4. Monitor performance với Lighthouse
5. Share link! 🎉

---

**Build location**: `build/web/`  
**Ready to deploy!** 🚀
