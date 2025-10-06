# 🍱 Tabetect

**Tabetect** adalah aplikasi **food recognizer berbasis Flutter** yang dapat mengenali jenis makanan dari gambar menggunakan **model Machine Learning (TensorFlow Lite)**. Nama _Tabetect_ berasal dari gabungan kata Jepang _“Taberu” (食べる, makan)_ dan _“Detect”_, mencerminkan tujuan aplikasi untuk membantu pengguna mendeteksi makanan dengan cepat dan cerdas.

## ✨ Fitur Utama

1. **📷 Pengambilan Gambar**

   - Menggunakan `image_picker` untuk mengambil gambar dari kamera atau galeri.
   - Gambar ditampilkan di aplikasi dan dapat **dipotong (crop)** menggunakan `image_cropper`.

2. **🤖 Identifikasi Makanan (Machine Learning)**

   - Menggunakan model **TensorFlow Lite Food Classifier** untuk mengenali jenis makanan.
   - Proses inferensi dijalankan di **background thread** menggunakan **Isolate** agar UI tetap responsif.

3. **🍜 Halaman Prediksi**
   - Menampilkan **nama makanan**, **confidence score**, dan **gambar hasil pengambilan**.
   - Menarik data tambahan dari **MealDB API** seperti bahan dan cara pembuatan makanan.

## ⚙️ Teknologi yang Digunakan

| Kategori         | Teknologi / Library                      |
| ---------------- | ---------------------------------------- |
| Framework        | Flutter (Dart)                           |
| Machine Learning | TensorFlow Lite                          |
| Image Handling   | `image_picker`, `image_cropper`, `image` |
| API Integration  | themealdb API                            |
| Threading        | Dart Isolate                             |
| State Management | Provider                                 |
| UI Framework     | Material Design 3                        |
