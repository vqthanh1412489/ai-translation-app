# 🚀 Deploy Script Usage

## Quick Start

### Cách 1: Deploy với commit message mặc định
```bash
./deploy_web.sh
```

### Cách 2: Deploy với commit message tùy chỉnh
```bash
./deploy_web.sh "Add new feature XYZ"
```

## Script sẽ làm gì?

1. ✅ **Clean** - Xóa build cũ
2. ✅ **Get dependencies** - Cập nhật packages
3. ✅ **Build** - Build web app với base-href đúng
4. ✅ **Copy** - Copy build output sang `docs/`
5. ✅ **Deploy** - Commit và push lên GitHub

## Lưu ý

- ⏱️ Quá trình mất khoảng **30-60 giây**
- 🌐 App sẽ live sau **1-2 phút** tại: https://vqthanh1412489.github.io/ai-translation-app/
- 🔄 Nhớ **hard refresh** (Cmd+Shift+R) để thấy thay đổi
- 🔒 File `deploy_web.sh` đã được thêm vào `.gitignore` (private)

## Troubleshooting

### Lỗi: Permission denied
```bash
chmod +x deploy_web.sh
```

### Lỗi: Git conflicts
```bash
git pull --rebase
./deploy_web.sh
```

### Lỗi: Build failed
```bash
flutter clean
flutter pub get
./deploy_web.sh
```

## Manual Deploy (nếu cần)

```bash
# 1. Build
flutter build web --release --base-href /ai-translation-app/

# 2. Copy
rm -rf docs/*
cp -r build/web/* docs/

# 3. Deploy
git add docs/
git commit -m "build: Update web app"
git push
```
