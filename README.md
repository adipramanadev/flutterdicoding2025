# SamA - Aplikasi Manajemen Sampah 🗂️♻️

**SamA** (Sampah Management) adalah aplikasi mobile berbasis Flutter untuk mengelola sistem penyetoran sampah dan penarikan uang. Aplikasi ini memungkinkan pengguna untuk menyetor berbagai jenis sampah, mendapatkan pendapatan berdasarkan berat dan jenis sampah, serta melakukan penarikan saldo yang telah terkumpul.

## 📱 Fitur Utama

### 🔐 **Sistem Login Statis**
- Login dengan kredensial demo (Username: `admin`, Password: `password123`)
- Validasi form dengan feedback real-time
- Loading state dengan smooth animations
- Auto-redirect ke dashboard setelah login berhasil

### 🏠 **Dashboard Interaktif**
- Tampilan saldo dan statistik sampah yang telah disetor
- Grid menu navigasi dengan 4 fitur utama
- Real-time update saldo dan informasi pengguna
- Design responsif untuk berbagai ukuran layar

### ♻️ **Sistem Setor Sampah**
- **6 Jenis Sampah** dengan harga berbeda per kg:
  - 🔵 Plastik: Rp 2.500/kg
  - 🟤 Kertas: Rp 1.500/kg
  - 🟢 Organik: Rp 500/kg
  - ⚫ Logam: Rp 5.000/kg
  - 🔷 Kaca: Rp 1.000/kg
  - 🟠 Lainnya: Rp 1.000/kg

- **Fitur Canggih:**
  - Real-time calculation preview
  - Form validation dengan error handling
  - Currency formatting otomatis
  - Success dialog dengan detail lengkap
  - Auto-update saldo dan statistik

### 💰 **Sistem Penarikan Uang**
- Validasi saldo minimum dan maksimum
- Real-time balance checking
- Simulasi proses transfer dengan loading state
- Notifikasi sukses/error yang informatif
- Currency formatting dengan separator

### 📊 **Riwayat & Statistik**
- History penyetoran sampah
- Informasi jenis sampah dan harga
- Tracking total pendapatan dan aktivitas

## 🛠️ Teknologi yang Digunakan

### **Frontend Framework**
- **Flutter** - Cross-platform mobile development
- **Dart** - Programming language

### **State Management**
- **StatefulWidget** - Local state management
- **setState()** - UI state updates

### **Navigation & Routing**
- **GetX** - Modern navigation management
- **MaterialPageRoute** - Standard Flutter navigation

### **UI/UX Components**
- **Material Design 3** - Modern UI components
- **Custom Widgets** - Reusable components
- **Responsive Design** - MediaQuery implementation
- **Animation** - Loading states & transitions

### **Data Handling**
- **Static Data** - Demo purposes dengan data simulasi
- **Form Validation** - Real-time input validation
- **Currency Formatting** - Custom number formatting

## 🚀 Instalasi & Menjalankan Aplikasi

### **Prerequisites**
- Flutter SDK (3.9.2+)
- Dart SDK
- Android Studio / VS Code
- Android Emulator / Physical Device

### **Clone Repository**
```bash
git clone https://github.com/adipramanadev/flutterdicoding2025.git
cd flutterdicoding2025
```

### **Install Dependencies**
```bash
flutter pub get
```

### **Run Application**
```bash
# Debug mode
flutter run

# Release mode  
flutter run --release

# Specific device
flutter run -d <device_id>
```

### **Build APK**
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

## 📂 Struktur Proyek

```
lib/
├── main.dart                    # Entry point aplikasi
└── views/                       # UI Screens
    ├── login.dart              # Halaman login dengan autentikasi
    ├── homepage.dart           # Dashboard utama dengan menu
    ├── setor_sampah.dart       # Form penyetoran sampah
    ├── withdraw_page.dart      # Form penarikan uang
    ├── history.dart            # Riwayat transaksi
    └── jenissampah.dart        # Informasi jenis sampah

img/                            # Asset gambar
├── logo.png                    # Logo aplikasi

android/                        # Platform Android
ios/                           # Platform iOS  
web/                           # Platform Web
```

## 🎯 User Flow

```
1. Login Screen
   ├── Input credentials (admin/password123)
   └── Validate & redirect to Dashboard
   
2. Dashboard
   ├── View balance & statistics
   ├── Navigate to Setor Sampah
   ├── Navigate to Penarikan Uang  
   ├── Navigate to Riwayat
   └── Navigate to Jenis Sampah
   
3. Setor Sampah
   ├── Select trash type
   ├── Input weight (min 0.1kg)
   ├── Preview calculation
   ├── Submit form
   └── View success dialog
   
4. Penarikan Uang
   ├── View current balance
   ├── Input withdrawal amount
   ├── Validate balance sufficiency
   ├── Process withdrawal
   └── View result notification
```

## 💡 Demo Credentials

| Field | Value |
|-------|-------|
| **Username** | `admin` |
| **Password** | `password123` |
| **Initial Balance** | Rp 500.000 |
| **Total Deposits** | 15 transactions |

## 🎨 Screenshots

> Aplikasi ini menampilkan:
> - Login screen dengan form validation
> - Dashboard dengan balance & menu grid
> - Form setor sampah dengan calculation preview
> - Withdrawal page dengan balance checking
> - Success/error dialogs dengan detail informasi

## 🔧 Fitur Teknis

### **Responsive Design**
- MediaQuery untuk ukuran layar dinamis
- Scalable icons dan fonts
- Adaptive layouts untuk tablet & mobile

### **Error Handling**
- Comprehensive null safety checks
- Form validation dengan custom messages  
- Network error simulation
- Graceful fallbacks untuk edge cases

### **Performance Optimizations**
- Efficient state management
- Proper widget lifecycle management
- Memory leak prevention dengan dispose()
- Optimized rebuild strategies

### **Code Quality**
- Dart lint rules compliance
- Modern Flutter best practices
- Clean code architecture
- Comprehensive commenting

## 🤝 Kontribusi

Contributions, issues, dan feature requests sangat diterima!

1. Fork repository ini
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

Project ini dibuat untuk keperluan pembelajaran Flutter development.

## 👨‍💻 Developer

**Adipramana Dev**
- GitHub: [@adipramanadev](https://github.com/adipramanadev)


---

**⚡ Built with Flutter & Love** 💚

** Herry Prasetyo @2025**
