# nice_music

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
NiCe Music

NiCe Music adalah aplikasi pemutar musik streaming lokal berbasis Flutter. Aplikasi ini merutekan data dan aliran audio mentah secara langsung dari YouTube (tanpa API Key resmi) dan menyajikannya dalam antarmuka bernuansa Glassmorphism. Desain antarmuka memadukan skema warna gelap khas Spotify dengan interaksi dan pedoman tata letak iOS (Apple Human Interface Guidelines).

Proyek ini dibangun secara eksklusif sebagai prototipe edukasi dan portofolio pengembang. Fokus utama dari proyek ini adalah implementasi arsitektur aplikasi seluler, manajemen status (state management) yang efisien, dan integrasi layanan pemutaran latar belakang (background audio service) pada sistem operasi seluler.

Fitur Utama

Pencarian Cerdas: Mengambil metadata lagu dan artis langsung dari basis data YouTube.

Pemutaran Latar Belakang (Background Playback): Mempertahankan pemutaran audio saat aplikasi berada di latar belakang atau layar terkunci, terintegrasi dengan kontrol media bawaan sistem operasi.

Glassmorphism UI: Antarmuka premium dengan efek kaca buram (frosted glass), latar belakang mesh gradient gelap, dan tipografi tebal.

Ringan & Efisien: Dibangun dengan prinsip KISS (Keep It Simple, Stupid) dan YAGNI, meminimalisir overengineering pada struktur kode.

Tech Stack & Dependensi

Framework: Flutter

State Management: flutter_riverpod

Audio Engine: just_audio & audio_service

Data Extractor (InnerTube Wrapper): youtube_explode_dart

UI/UX: cupertino_icons, google_fonts (Inter)

Panduan Instalasi

Prasyarat

Pastikan lingkungan pengembangan Anda telah dilengkapi dengan Flutter SDK (versi stabil terbaru) dan emulator (Android/iOS) atau perangkat fisik yang dikonfigurasi untuk debugging.

Langkah Instalasi

Kloning repositori ini ke mesin lokal Anda:

git clone https://github.com/username-kamu/nice_music.git
cd nice_music


Unduh dan perbarui semua dependensi paket:

flutter pub get


Kompilasi dan jalankan aplikasi:

flutter run


Struktur Direktori

Proyek ini mempertahankan struktur direktori yang datar untuk kemudahan pemeliharaan:

lib/
 ┣ models/           # Skema data aplikasi (contoh: SongModel)
 ┣ providers/        # State Riverpod untuk manajemen status global
 ┣ services/         # Logika bisnis inti (YouTube API, AudioHandler)
 ┣ ui/           
 ┃  ┣ widgets/       # Komponen antarmuka yang dapat digunakan ulang (GlassContainer)
 ┃  ┣ screens/       # Halaman utama aplikasi (SearchScreen, NowPlayingScreen)
 ┃  ┗ theme.dart     # Definisi tema, warna, dan tipografi
 ┗ main.dart         # Entry point aplikasi dan inisialisasi ProviderScope

