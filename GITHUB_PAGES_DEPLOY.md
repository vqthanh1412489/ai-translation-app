# 🚀 Deploy to GitHub Pages - Step by Step

## ✅ Đã hoàn thành:

- ✅ Git repository đã được khởi tạo
- ✅ Build web app đã sẵn sàng trong `docs/`
- ✅ Code đã được commit

## 📝 Các bước tiếp theo:

### **Bước 1: Tạo GitHub Repository**

1. Vào https://github.com/new
2. Tạo repository mới:
   - **Repository name**: `ai-translation-app` (hoặc tên bạn muốn)
   - **Visibility**: Public (để dùng GitHub Pages miễn phí)
   - **KHÔNG** check "Initialize with README"
3. Click **"Create repository"**

---

### **Bước 2: Push code lên GitHub**

Copy các lệnh từ GitHub (hoặc dùng lệnh dưới):

```bash
# Thêm remote (thay YOUR_USERNAME và YOUR_REPO)
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git

# Đổi tên branch thành main
git branch -M main

# Push code
git push -u origin main
```

**Ví dụ:**
```bash
git remote add origin https://github.com/quocthanhvu/ai-translation-app.git
git branch -M main
git push -u origin main
```

---

### **Bước 3: Enable GitHub Pages**

1. Vào repository trên GitHub
2. Click **Settings** (tab trên cùng)
3. Scroll xuống phần **"Pages"** (menu bên trái)
4. Trong **"Source"**:
   - Branch: chọn `main`
   - Folder: chọn `/docs`
5. Click **"Save"**

GitHub sẽ build và deploy app!

---

### **Bước 4: Đợi deploy (1-2 phút)**

GitHub Pages sẽ build app. Bạn sẽ thấy:
- ✅ Green checkmark khi deploy thành công
- 🌐 URL của app: `https://YOUR_USERNAME.github.io/YOUR_REPO/`

**Ví dụ:**
```
https://quocthanhvu.github.io/ai-translation-app/
```

---

## 🎯 Update app sau này:

Khi có thay đổi code:

```bash
# 1. Build lại web với đúng base-href
flutter build web --release --base-href /ai-translation-app/

# 2. Copy sang docs/
rm -rf docs/*
cp -r build/web/* docs/

# 3. Commit và push
git add .
git commit -m "Update app"
git push
```

GitHub Pages sẽ tự động deploy phiên bản mới!

---

## 🔧 Troubleshooting:

### **Lỗi: "Page not found"**
- Đợi thêm 2-3 phút
- Check Settings → Pages xem đã enable chưa
- Đảm bảo folder là `/docs` không phải `/root`

### **Lỗi: "404 - flutter_bootstrap.js not found"**
✅ **ĐÃ FIX**: Build với đúng base-href:
```bash
flutter build web --release --base-href /ai-translation-app/
```

Check `docs/index.html` - đảm bảo base href đúng:
```html
<base href="/ai-translation-app/" />
```

### **Lỗi: "404 when refresh page"**
Thêm file `docs/404.html`:
```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <script>
    sessionStorage.redirect = location.href;
  </script>
  <meta http-equiv="refresh" content="0;URL='/ai-translation-app'">
</head>
</html>
```

### **Lỗi: Assets không load**
Check `web/index.html` - đảm bảo base href đúng:
```html
<base href="/ai-translation-app/">
```

### **Warning: apple-mobile-web-app-capable deprecated**
✅ **ĐÃ FIX**: Thêm meta tag mới trong `web/index.html`:
```html
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
```

---

## 🎨 Custom Domain (Optional):

Nếu có domain riêng:

1. Settings → Pages → Custom domain
2. Nhập domain của bạn (ví dụ: `translate.yourdomain.com`)
3. Thêm CNAME record ở DNS provider:
   ```
   CNAME translate YOUR_USERNAME.github.io
   ```

---

## 📊 Monitoring:

- **GitHub Actions**: Xem build status
- **Settings → Pages**: Xem deployment history
- **Insights → Traffic**: Xem visitor stats

---

## 🎉 Done!

App của bạn sẽ live tại:
```
https://YOUR_USERNAME.github.io/YOUR_REPO/
```

Share link này với mọi người! 🚀

---

## 📝 Notes:

- ✅ HTTPS tự động (miễn phí)
- ✅ CDN global (nhanh)
- ✅ Unlimited bandwidth
- ✅ Auto deploy khi push
- ⚠️ Chỉ static files (không có backend)
- ⚠️ User phải tự nhập API key

---

**Current status**: Ready to push to GitHub! 🎯
