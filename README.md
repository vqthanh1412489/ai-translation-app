# AI Translation Workflow

Flutter app dịch thuật sử dụng 3 AI agents (Translator → Stylist → QA) với GetX architecture.

## 🎯 Mục tiêu

App cho phép:
- Dán/nhập văn bản cần dịch
- Chạy pipeline 3 bước AI để dịch
- Xem output từng bước + QA report
- Lưu history theo "Job"
- Export/copy bản final

## 🏗️ Kiến trúc

- **State Management**: GetX
- **HTTP Client**: Dio với timeout + retry
- **Local Storage**: Hive
- **API**: OpenAI-compatible endpoints
- **JSON Parsing**: Strict với auto-retry

## 📁 Cấu trúc thư mục

```
lib/
  main.dart
  app/
    routes/          # GetX routes
    theme/           # App theme
    core/            # Constants, utils, logger
    data/
      models/        # Data models
      providers/     # HTTP & Storage providers
      repositories/  # Business logic
  modules/
    home/            # Main screen với pipeline
    settings/        # Cấu hình API & agents
    history/         # Danh sách jobs
    job_detail/      # Chi tiết job
```

## 🚀 Cài đặt

1. Clone project:
```bash
cd ai_translate_workflow
```

2. Cài dependencies:
```bash
flutter pub get
```

3. Chạy app:
```bash
flutter run
```

## ⚙️ Cấu hình

### 1. Settings (API Configuration)

Vào Settings và cấu hình:

- **Base URL**: Endpoint OpenAI-compatible (ví dụ: `https://api.openai.com/v1/chat/completions`)
- **API Key**: API key của bạn
- **Target Language**: Ngôn ngữ đích (mặc định: Vietnamese)
- **Tone Profile**: Văn phong mong muốn
- **Format Rules**: Các quy tắc format
- **Glossary**: Từ điển thuật ngữ (key-value pairs)

### 2. Agent Configurations

Mỗi agent có thể cấu hình:
- **Model**: Tên model (ví dụ: `gpt-4o-mini`)
- **Temperature**: 0.0 - 1.0
- **Max Tokens**: Số token tối đa
- **System Prompt**: Prompt hệ thống
- **User Prompt Template**: Template cho user prompt

## 📝 Workflow 3 Agents

### Agent 1: Translator
- Dịch văn bản từ source sang target language
- Giữ nguyên format, số, proper nouns
- Áp dụng glossary
- Output: `{translation, notes}`

### Agent 2: Stylist
- Chỉnh văn phong theo tone profile
- Không thay đổi nghĩa
- Enforce glossary
- Output: `{refined, changes}`

### Agent 3: QA
- Kiểm tra chất lượng dịch
- Phát hiện lỗi: missing content, số sai, glossary violations
- Fix issues và tạo final version
- Output: `{final, issues, score}`

## 🎨 Features

### ✅ Đã implement:

1. **3-Agent Pipeline**: Translator → Stylist → QA
2. **JSON Strict Parsing**: Auto-retry nếu JSON invalid
3. **Settings Management**: Lưu/load với Hive
4. **Job History**: Lưu và xem lại jobs
5. **Cancel Support**: Cancel job đang chạy
6. **Progress Tracking**: Hiển thị progress realtime
7. **Raw JSON View**: Xem raw response từ mỗi step
8. **QA Report**: Issues list với severity và score

### 📱 Screens:

- **Home**: Input, Run/Stop, Progress, 4 tabs (Step1/Step2/Final/QA)
- **Settings**: API config, Translation settings, Agent configs
- **History**: List jobs với status và score
- **Job Detail**: Chi tiết job với raw JSON

## 🔧 Technical Details

### JSON Strict Parsing + Retry

Pipeline mỗi step:
1. Call LLM → raw response
2. `jsonDecode(raw)` → Map
3. Nếu fail → retry 1 lần với Fix JSON prompt
4. Nếu vẫn fail → mark job error, show raw

**Fix JSON Prompt:**
```
You returned invalid JSON. Return ONLY valid JSON matching the schema exactly. Do not add any extra text.
Here is your previous output:
<<<OUTPUT>>>
```

### Error Handling

- Network errors: Auto-retry 1 lần
- JSON parse errors: Fix JSON prompt retry
- API errors: Hiển thị error message, không crash
- Cancel: Graceful cancellation với CancelToken

## 📊 Default Prompts

### Translator (Agent 1)
```
You are a professional translator.
Preserve meaning, numbers, proper nouns, and structure.
Follow glossary strictly.
Return JSON only, no extra text.
```

### Stylist (Agent 2)
```
You are an editor.
Improve fluency and match the given tone WITHOUT changing meaning.
Enforce glossary and preserve formatting.
Return JSON only.
```

### QA (Agent 3)
```
You are a QA linguist.
Detect meaning drift, missing content, numeric mistakes, glossary violations, and formatting issues.
Fix issues and return JSON only.
```

## 🧪 Testing

### Analyze code:
```bash
flutter analyze
```

### Run tests (khi có):
```bash
flutter test
```

### Test với API thực:
1. Cấu hình API key trong Settings
2. Nhập văn bản test
3. Nhấn "Chạy"
4. Kiểm tra output từng tab
5. Xem History và Job Detail

## 📚 Dependencies

- `get`: ^4.6.6 - State management & routing
- `dio`: ^5.4.0 - HTTP client
- `hive`: ^2.2.3 - Local storage
- `hive_flutter`: ^1.1.0 - Hive Flutter integration
- `path_provider`: ^2.1.1 - Path utilities
- `uuid`: ^4.3.3 - UUID generation
- `flutter_markdown`: ^0.6.18 - Markdown preview (optional)
- `share_plus`: ^7.2.1 - Share functionality (optional)
- `file_picker`: ^6.1.1 - File picker (optional)

## 🐛 Troubleshooting

### App không chạy được?
- Chạy `flutter clean` và `flutter pub get`
- Kiểm tra Flutter version: `flutter doctor`

### API không hoạt động?
- Kiểm tra Base URL và API Key trong Settings
- Kiểm tra network connection
- Xem raw JSON response để debug

### Hive errors?
- Xóa app data và chạy lại
- Kiểm tra permissions

## 📄 License

MIT License

## 👥 Contributors

Built with ❤️ using Flutter & GetX

---

**Version**: 1.0.0  
**Last Updated**: 2025-12-29
