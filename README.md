<div align="center">

# 🏥 AppJagaLansia

### Aplikasi Perawatan & Monitoring Lansia Berbasis Flutter

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

*Solusi Digital untuk Merawat dan Menjaga Orang Tua Tercinta* 💙

[Tentang](#-tentang) • [Fitur](#-fitur) • [Teknologi](#-teknologi) • [Instalasi](#-instalasi) • [Struktur](#-struktur-project) • [Screenshots](#-screenshots) • [Roadmap](#-roadmap) • [Kontribusi](#-kontribusi)

</div>

---

## 📖 Tentang

**AppJagaLansia** adalah aplikasi mobile yang dirancang khusus untuk membantu keluarga dan caregiver dalam merawat dan memantau kesehatan lansia. Dengan antarmuka yang user-friendly dan fitur-fitur komprehensif, aplikasi ini memudahkan perawatan harian dan monitoring kesehatan orang tua tercinta Anda.

### 🎯 Tujuan

- 🩺 Memudahkan monitoring kesehatan lansia secara real-time
- 📅 Mengelola jadwal perawatan dan pengobatan
- 👨‍⚕️ Menghubungkan keluarga dengan tenaga kesehatan profesional
- 📊 Menyediakan data dan laporan kesehatan yang komprehensif
- 💊 Reminder untuk jadwal minum obat dan kontrol kesehatan
- 📱 Akses mudah kapan saja dan dimana saja

---

## ✨ Fitur

### 🔐 Autentikasi & Keamanan
- **Login & Register** - Sistem keamanan dengan autentikasi pengguna
- **Multi-Role Access** - Akses terpisah untuk admin dan pengguna biasa
- **Welcome Screen** - Tampilan selamat datang yang menarik dan informatif
- **Secure Data** - Keamanan data pengguna terjamin

### 👥 User Management
- **Dashboard Pengguna** - Interface khusus untuk keluarga/caregiver
- **Dashboard Admin** - Panel management sistem yang lengkap
- **Profil Pengguna** - Kelola informasi pribadi dan preferensi
- **Multi-Lansia Support** - Monitor beberapa lansia dalam satu akun

### 🩺 Fitur Kesehatan *(Coming Soon)*
- **Health Monitoring** - Pantau vital signs (tekanan darah, gula darah, dll)
- **Medication Reminder** - Pengingat jadwal minum obat
- **Appointment Scheduling** - Jadwalkan konsultasi dengan dokter
- **Health Records** - Riwayat kesehatan digital
- **Emergency Contact** - Akses cepat untuk keadaan darurat

### 🎨 UI/UX
- **Material Design 3** (Material You) - Design system terbaru
- **Modern Color Scheme** - Primary color #00897B yang menenangkan
- **Responsive Design** - Adaptif untuk berbagai ukuran layar
- **Smooth Animations** - Animasi yang intuitif dan menyenangkan
- **Dark Mode Support** *(Coming Soon)*

---

## 🛠 Teknologi

<div align="center">

| Teknologi | Versi | Keterangan |
|-----------|-------|------------|
| Flutter | Latest | Framework utama untuk development |
| Dart | Latest | Programming language |
| Material 3 | ✅ | Design system |
| Android | ✅ | Platform target |

</div>

### 📦 Dependencies

Aplikasi ini dibangun dengan berbagai package Flutter terbaik: 

```yaml
dependencies:
  flutter: 
    sdk: flutter
  # Add your dependencies here
```

---

## 🚀 Instalasi

### Prasyarat

Pastikan Anda telah menginstall:
- ✅ [Flutter SDK](https://docs.flutter.dev/get-started/install) (versi 3.0 atau lebih baru)
- ✅ [Dart SDK](https://dart.dev/get-dart)
- ✅ Android Studio / VS Code dengan Flutter extension
- ✅ Git
- ✅ Emulator/Device untuk testing

### Langkah-langkah Instalasi

1. **Clone repository**
   ```bash
   git clone https://github.com/NickyAditya/AppJagaLansia.git
   cd AppJagaLansia
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Verifikasi instalasi Flutter**
   ```bash
   flutter doctor
   ```

4. **Jalankan aplikasi**
   ```bash
   # Development mode
   flutter run

   # Pilih device spesifik
   flutter run -d <device_id>
   ```

5. **Build untuk production**
   ```bash
   # Android APK
   flutter build apk --release

   # Android App Bundle (untuk Play Store)
   flutter build appbundle --release

   # iOS
   flutter build ios --release

   # Web
   flutter build web --release

   # Windows
   flutter build windows --release
   ```

---

## 📁 Struktur Project

```
AppJagaLansia/
├── android/                 # Konfigurasi Android
├── ios/                     # Konfigurasi iOS
├── lib/                     # Source code utama
│   ├── main.dart           # Entry point aplikasi
│   ├── screens/            # Halaman-halaman aplikasi
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── welcome_screen.dart
│   │   ├── admin_welcome_screen.dart
│   │   └── home_screen.dart
│   ├── models/             # Data models (coming soon)
│   ├── services/           # API & services (coming soon)
│   ├── widgets/            # Reusable widgets (coming soon)
│   └── utils/              # Utilities & helpers (coming soon)
├── assets/                 # Gambar, icon, dan resource
│   ├── images/
│   ├── icons/
│   └── fonts/
├── test/                   # Unit & widget tests
├── web/                    # Konfigurasi Web
├── windows/                # Konfigurasi Windows
├── linux/                  # Konfigurasi Linux
├── macos/                  # Konfigurasi macOS
├── pubspec.yaml            # Dependencies & metadata
└── README.md               # Dokumentasi project
```

---

## 📱 Screenshots

<div align="center">

### 🔐 Login & Register

<img src="Flutter Jaga Lansia/jagalansia_login.jpg" width="250" alt="Login Screen"/>
<img src="Flutter Jaga Lansia/jagalansia_register.jpg" width="250" alt="Register Screen"/>

### 👤 Dashboard User

<img src="Flutter Jaga Lansia/jagalansia_dashboard_user.jpg" width="250" alt="Dashboard User"/>
<img src="Flutter Jaga Lansia/jagalansia_dashboard_user_cuaca.jpg" width="250" alt="Dashboard User Cuaca"/>
<img src="Flutter Jaga Lansia/jagalansia_dashboard_user_pembelian.jpg" width="250" alt="Dashboard User Pembelian"/>
<img src="Flutter Jaga Lansia/jagalansia_dashboard_user_profil.jpg" width="250" alt="Dashboard User Profil"/>

### 🛠️ Dashboard Admin

<img src="Flutter Jaga Lansia/jagalansia_dashboard_admin.jpg" width="250" alt="Dashboard Admin"/>
<img src="Flutter Jaga Lansia/jagalansia_dashboard_admin_manage_obat.jpg" width="250" alt="Dashboard Admin Manage Obat"/>
<img src="Flutter Jaga Lansia/jagalansia_dashboard_admin_manage_transaksi.jpg" width="250" alt="Dashboard Admin Manage Transaksi"/>
<img src="Flutter Jaga Lansia/jagalansia_dashboard_admin_manage_user.jpg" width="250" alt="Dashboard Admin Manage User"/>

</div>

---

## 🎯 Roadmap

### ✅ Fase 1 - Foundation (Completed)
- [x] Setup project Flutter
- [x] Implementasi autentikasi (Login/Register)
- [x] Design UI/UX dengan Material 3
- [x] Multi-platform support (Android, iOS, Web, Desktop)
- [x] Welcome & admin screens

### 🚧 Fase 2 - Core Features (In Progress)
- [ ] Integrasi backend API/Firebase
- [ ] Database integration (SQLite/Hive/Cloud)
- [ ] User profile management
- [ ] Data lansia management

### 📋 Fase 3 - Health Features (Planned)
- [ ] Fitur monitoring kesehatan real-time
- [ ] Input dan tracking vital signs
- [ ] Medication reminder & scheduler
- [ ] Health records & history
- [ ] Emergency contact system

### 🚀 Fase 4 - Advanced Features (Future)
- [ ] Push notifications & reminders
- [ ] Chat dengan tenaga kesehatan
- [ ] Video call consultation
- [ ] Laporan kesehatan PDF export
- [ ] Integrasi dengan wearable devices
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Offline mode

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test
```

---

## 📄 License

Project ini dibuat untuk tujuan edukasi dan pengembangan aplikasi perawatan lansia. 

Distributed under the MIT License. See `LICENSE` for more information.

---

## 👨‍💻 Developer

<div align="center">

### Development Team

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/NickyAditya">
        <img src="https://github.com/NickyAditya.png" width="100px;" alt="Nicky Aditya"/><br />
        <sub><b>Nicky Aditya</b></sub>
      </a><br />
      <sub>Lead Developer</sub><br />
      <a href="https://github.com/NickyAditya">
        <img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white" alt="GitHub"/>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/RafiSyahrulfalah">
        <img src="https://github.com/RafiSyahrulfalah.png" width="100px;" alt="Rafi Syahrulfallah"/><br />
        <sub><b>Rafi Syahrulfallah</b></sub>
      </a><br />
      <sub>Developer</sub><br />
      <a href="https://github.com/RafiSyahrulfalah">
        <img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white" alt="GitHub"/>
      </a>
    </td>
  </tr>
</table>

</div>

---

## 📞 Kontak & Support

Jika Anda memiliki pertanyaan, saran, atau menemukan bug: 

- 🐛 [Report Bug](https://github.com/NickyAditya/AppJagaLansia/issues/new?labels=bug)
- 💡 [Request Feature](https://github.com/NickyAditya/AppJagaLansia/issues/new?labels=enhancement)
- 📧 [Contact Developer](https://github.com/NickyAditya)
- 💬 [Discussions](https://github.com/NickyAditya/AppJagaLansia/discussions)

---

## 🙏 Acknowledgments

- Flutter Team untuk framework yang luar biasa
- Material Design untuk design guidelines
- Semua contributors yang telah membantu project ini

---

<div align="center">

### 💙 Dibuat dengan ❤️ menggunakan Flutter

**AppJagaLansia** - *Merawat dengan Teknologi, Menjaga dengan Kasih Sayang*

⭐ **Jangan lupa berikan star jika project ini bermanfaat!** ⭐

![GitHub stars](https://img.shields.io/github/stars/NickyAditya/AppJagaLansia?style=social)
![GitHub forks](https://img.shields.io/github/forks/NickyAditya/AppJagaLansia?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/NickyAditya/AppJagaLansia?style=social)

---

</div>
