# 🌐 AI Translation Workflow

**Professional AI-powered translation with 3-agent pipeline**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Web](https://img.shields.io/badge/Platform-Web-orange.svg)](https://flutter.dev/web)

[🚀 **Live Demo**](https://vqthanh1412489.github.io/ai-translation-app/) | [📖 Documentation](DEPLOY_WEB.md) | [🐛 Report Bug](https://github.com/vqthanh1412489/ai-translation-app/issues)

---

## ✨ Features

### **🤖 3-Agent Translation Pipeline**
- **Agent 1 - Translator**: Accurate translation preserving meaning and structure
- **Agent 2 - Stylist**: Tone and style refinement
- **Agent 3 - QA**: Quality assurance with issue detection and scoring

### **🎯 Key Capabilities**
- ✅ Real-time progress tracking with visual indicators
- ✅ Quality scoring (0-100) with detailed QA reports
- ✅ Job history with full audit trail
- ✅ Copy/export final translations
- ✅ Customizable agent configurations
- ✅ Glossary and format rules support
- ✅ Error logging and debugging tools

### **⚙️ Highly Configurable**
- API endpoint and key management
- Target language and tone profile
- Temperature and token limits per agent
- Custom system prompts and templates
- Format rules and glossary

---

## 🚀 Quick Start

### **Web App (Recommended)**

Visit the live demo: [https://vqthanh1412489.github.io/ai-translation-app/](https://vqthanh1412489.github.io/ai-translation-app/)

1. Click **Settings** (⚙️)
2. Enter your **API Key** and **Base URL**
3. Configure translation preferences
4. Go back to **Home**
5. Paste your text and click **"Chạy"**

### **Local Development**

```bash
# Clone repository
git clone https://github.com/vqthanh1412489/ai-translation-app.git
cd ai-translation-app

# Install dependencies
flutter pub get

# Run on web
flutter run -d chrome

# Or run on macOS
flutter run -d macos
```

---

## 📖 How It Works

### **Translation Pipeline**

```
Input Text
    ↓
┌─────────────────────┐
│  Agent 1: Translator │ → Accurate translation
└─────────────────────┘
    ↓
┌─────────────────────┐
│  Agent 2: Stylist   │ → Style refinement
└─────────────────────┘
    ↓
┌─────────────────────┐
│  Agent 3: QA        │ → Quality check + final version
└─────────────────────┘
    ↓
Final Translation + QA Report
```

### **Quality Assurance**

Each translation is scored (0-100) based on:
- ✅ Meaning accuracy
- ✅ Glossary compliance
- ✅ Format preservation
- ✅ Grammar and fluency
- ✅ Tone consistency

Issues are categorized by:
- **Severity**: low/medium/high
- **Type**: missing/mistranslation/number/glossary/format/grammar

---

## 🛠️ Technology Stack

- **Framework**: Flutter 3.0+
- **State Management**: GetX
- **HTTP Client**: Dio
- **Local Storage**: Hive
- **Architecture**: Clean Architecture with Repository Pattern
- **API**: OpenAI-compatible endpoints

---

## 📱 Platforms

- ✅ **Web** (Chrome, Safari, Firefox, Edge)
- ✅ **macOS** (Intel & Apple Silicon)
- ✅ **iOS** (coming soon)
- ✅ **Android** (coming soon)

---

## 🔐 Security & Privacy

- 🔒 **API keys stored locally** in browser localStorage
- 🔒 **No backend** - direct API calls from client
- 🔒 **HTTPS only** when deployed
- ⚠️ **User responsibility**: Keep your API keys secure

---

## 📊 Screenshots

### Home Screen
![Home](screenshots/home.png)

### Settings
![Settings](screenshots/settings.png)

### QA Report
![QA](screenshots/qa.png)

---

## 🎯 Roadmap

- [ ] Mobile app (iOS & Android)
- [ ] Batch translation
- [ ] File import/export
- [ ] Translation memory
- [ ] Team collaboration
- [ ] API rate limiting
- [ ] Offline mode

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Built with [Flutter](https://flutter.dev)
- State management by [GetX](https://pub.dev/packages/get)
- Inspired by professional translation workflows

---

## 📞 Contact

- **Issues**: [GitHub Issues](../../issues)
- **Discussions**: [GitHub Discussions](../../discussions)

---

**Made with ❤️ using Flutter**
