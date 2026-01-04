import '../models/coffe_shop.dart';

const List<Map<String, dynamic>> coffeShopRaw = [

  {
    "id": "plg_equatore_rooftop",
    "name": "Equatore Rooftop Cafe",
    "description":
        "Rooftop cafe di tengah kota, cocok buat nongkrong sambil lihat view Palembang dari ketinggian.",
    "address":
        "Barong Hotel Lantai 5, Komplek Mall Palembang Square, Jl. Pom IX, Ilir Barat I, Palembang",
    "city": "Palembang",
    "mapQuery": "Equatore Rooftop Cafe Barong Hotel Palembang",
    "photos": [
      "assets/images/coffeeshops/equatore_1.jpg",
      "assets/images/coffeeshops/equatore_2.jpg",
      "assets/images/coffeeshops/equatore_menu.jpg",
    ],
    "hours": {
      "mon": null,
      "tue": {"open": "15:00", "close": "22:00"},
      "wed": {"open": "15:00", "close": "22:00"},
      "thu": {"open": "15:00", "close": "22:00"},
      "fri": {"open": "15:00", "close": "22:00"},
      "sat": {"open": "15:00", "close": "22:00"},
      "sun": {"open": "15:00", "close": "22:00"},
      "note": "Jam berdasarkan referensi; bisa berubah saat event/libur."
    },
    "menuPriceRange": {"min": 20000, "max": 95000, "currency": "IDR"},
    "menuHighlights": [
      {"name": "Kopi (espresso-based)", "priceFrom": 25000},
      {"name": "Milkshake", "priceFrom": 30000},
      {"name": "Calamari / Chicken Wings", "priceFrom": 45000},
      {"name": "French Fries", "priceFrom": 25000},
    ],
    "facilities": [
      "rooftop",
      "city_view",
      "photo_spots",
      "indoor_seating",
      "outdoor_seating"
    ],
    "facilityNote": "Sebagian fasilitas adalah seed (contoh).",
    "rating": {"value": 4.6, "count": 128, "source": "seed"},
    "reviews": [
      {
        "user": "Nadia",
        "rating": 5,
        "date": "2025-11-18",
        "comment": "View rooftop-nya juara. Angin sore + kopi, auto waras.",
        "isSeed": true
      },
      {
        "user": "Raka",
        "rating": 4,
        "date": "2025-10-02",
        "comment": "Enak buat nongkrong. Kalau rame, pilih jam agak awal.",
        "isSeed": true
      },
      {
        "user": "Sinta",
        "rating": 5,
        "date": "2025-09-21",
        "comment": "Snack-nya ok, tempatnya cakep buat foto.",
        "isSeed": true,
      },
    ],
    "source": {"title": "detikSumbagsel (04 Jan 2024)", "type": "article"},
    "isPalembangOnly": true,
  },

  {
    "id": "plg_basengla_cafe",
    "name": "Basengla Cafe",
    "description":
        "Tempat nongkrong dengan andalan es kopi susu dan menu makanan yang cukup variatif.",
    "address": "Jl. Wijaya Kusuma No.11, Ilir Barat I, Palembang",
    "city": "Palembang",
    "mapQuery": "Basengla Cafe Jl Wijaya Kusuma Palembang",
    "photos": [
      "assets/images/coffeeshops/basengla_1.jpg",
      "assets/images/coffeeshops/basengla_2.jpg",
      "assets/images/coffeeshops/basengla_menu.jpg",
    ],
    "hours": {
      "mon": {"open": "15:00", "close": "22:00"},
      "tue": {"open": "15:00", "close": "22:00"},
      "wed": {"open": "15:00", "close": "22:00"},
      "thu": {"open": "15:00", "close": "22:00"},
      "fri": {"open": "15:00", "close": "22:00"},
      "sat": {"open": "11:00", "close": "00:00"},
      "sun": {"open": "15:00", "close": "22:00"},
      "note": "Sabtu tutup tengah malam."
    },
    "menuPriceRange": {"min": 25000, "max": 90000, "currency": "IDR"},
    "menuHighlights": [
      {"name": "Es Kopi Susu", "priceFrom": 25000},
      {"name": "Nasi Goreng", "priceFrom": 35000},
      {"name": "Mie Goreng", "priceFrom": 35000},
      {"name": "Non-coffee (tea)", "priceFrom": 25000},
    ],
    "facilities": ["indoor_seating"],
    "facilityNote": "Fasilitas detail belum diverifikasi (seed minimal).",
    "rating": {"value": 4.5, "count": 96, "source": "seed"},
    "reviews": [
      {
        "user": "Ilham",
        "rating": 5,
        "date": "2025-10-14",
        "comment": "Es kopi susunya legit. Sabtu enak buat nongkrong lama.",
        "isSeed": true
      },
      {
        "user": "Dina",
        "rating": 4,
        "date": "2025-08-30",
        "comment": "Makanannya oke, suasana santai.",
        "isSeed": true
      },
      {
        "user": "Fahri",
        "rating": 4,
        "date": "2025-07-03",
        "comment": "Tempatnya nyaman, cuma parkir kadang rame.",
        "isSeed": true
      },
    ],
    "source": {"title": "detikSumbagsel (04 Jan 2024)", "type": "article"},
    "isPalembangOnly": true,
  },

  {
    "id": "plg_enamdua",
    "name": "ENAMDUA Coffee and Eatery",
    "description":
        "Konsep minimalis semi-industrial, cocok buat nugas atau hangout santai.",
    "address": "Jl. Hang Tuah No.8, Talang Semut, Bukit Kecil, Palembang",
    "city": "Palembang",
    "mapQuery": "ENAMDUA Coffee and Eatery Jl Hang Tuah Palembang",
    "photos": [
      "assets/images/coffeeshops/enamdua_1.jpg",
      "assets/images/coffeeshops/enamdua_2.jpg",
      "assets/images/coffeeshops/enamdua_menu.jpg",
    ],
    "hours": {
      "mon": {"open": "12:00", "close": "23:00"},
      "tue": {"open": "12:00", "close": "23:00"},
      "wed": {"open": "12:00", "close": "23:00"},
      "thu": {"open": "12:00", "close": "23:00"},
      "fri": {"open": "12:00", "close": "23:00"},
      "sat": {"open": "12:00", "close": "23:00"},
      "sun": {"open": "12:00", "close": "23:00"},
    },
    "menuPriceRange": {"min": 20000, "max": 90000, "currency": "IDR"},
    "menuHighlights": [
      {"name": "Es Kopi Susu", "priceFrom": 20000},
      {"name": "Spaghetti", "priceFrom": 40000},
      {"name": "Siomay", "priceFrom": 30000},
      {"name": "Nasi Ayam Teriyaki", "priceFrom": 45000},
    ],
    "facilities": ["indoor_seating", "work_friendly"],
    "facilityNote": "Work-friendly adalah seed (contoh) untuk UI.",
    "rating": {"value": 4.7, "count": 210, "source": "seed"},
    "reviews": [
      {
        "user": "Rizky",
        "rating": 5,
        "date": "2025-12-01",
        "comment": "Vibe-nya enak buat kerja, kopi susunya aman.",
        "isSeed": true
      },
      {
        "user": "Tami",
        "rating": 5,
        "date": "2025-11-03",
        "comment": "Interiornya clean, fotogenik tanpa maksa.",
        "isSeed": true
      },
      {
        "user": "Bimo",
        "rating": 4,
        "date": "2025-09-12",
        "comment": "Spaghetti-nya mantap, pas jam rame agak wait.",
        "isSeed": true
      },
    ],
    "source": {"title": "detikSumbagsel (04 Jan 2024)", "type": "article"},
    "isPalembangOnly": true,
  },

  {
    "id": "plg_fow_coffee",
    "name": "FOW Coffee",
    "description":
        "Coffee shop populer dengan bangunan minimalis; pilihan kopi & makanan cukup lengkap.",
    "address": "Jl. Ki Ranggo Wirosantiko No.30, Ilir Barat II, Palembang",
    "city": "Palembang",
    "mapQuery": "FOW Coffee Jl Ki Ranggo Wirosantiko Palembang",
    "photos": [
      "assets/images/coffeeshops/fow_1.jpg",
      "assets/images/coffeeshops/fow_2.jpg",
      "assets/images/coffeeshops/fow_menu.jpg",
    ],
    "hours": {
      "mon": {"open": "10:00", "close": "23:00"},
      "tue": {"open": "10:00", "close": "23:00"},
      "wed": {"open": "10:00", "close": "23:00"},
      "thu": {"open": "10:00", "close": "23:00"},
      "fri": {"open": "10:00", "close": "23:00"},
      "sat": {"open": "10:00", "close": "23:00"},
      "sun": {"open": "10:00", "close": "23:00"},
    },
    "menuPriceRange": {"min": 25000, "max": 95000, "currency": "IDR"},
    "menuHighlights": [
      {"name": "Es Kopi Susu", "priceFrom": 25000},
      {"name": "Lemon Tea / Milkshake", "priceFrom": 25000},
      {"name": "Kentang Goreng", "priceFrom": 30000},
      {"name": "Tahu Salted Egg", "priceFrom": 35000},
      {"name": "Donburi", "priceFrom": 45000},
    ],
    "facilities": ["indoor_seating", "photo_spots"],
    "facilityNote": "Beberapa tag fasilitas adalah seed (contoh).",
    "rating": {"value": 4.6, "count": 305, "source": "seed"},
    "reviews": [
      {
        "user": "Ayu",
        "rating": 5,
        "date": "2025-11-22",
        "comment": "Tempatnya minimalis, makanan juga enak (tahu salted egg!).",
        "isSeed": true
      },
      {
        "user": "Daffa",
        "rating": 4,
        "date": "2025-10-08",
        "comment": "Menu minuman banyak. Cocok buat nongkrong malam.",
        "isSeed": true
      },
      {
        "user": "Reno",
        "rating": 5,
        "date": "2025-08-19",
        "comment": "Kopi susunya favorit. Datang lebih awal biar dapet spot.",
        "isSeed": true
      },
    ],
    "source": {"title": "detikSumbagsel (04 Jan 2024)", "type": "article"},
    "isPalembangOnly": true,
  },

  {
    "id": "plg_dekultur_coffee",
    "name": "DeKultur Coffee",
    "description":
        "Nuansa minimalis-industrial, ramai saat akhir pekan; pilihan kopi dan non-kopi beragam.",
    "address": "Jl. Gub H Bastari No.8, Seberang Ulu I, Palembang",
    "city": "Palembang",
    "mapQuery": "DeKultur Coffee Jl Gub H Bastari Palembang",
    "photos": [
      "assets/images/coffeeshops/dekultur_1.jpg",
      "assets/images/coffeeshops/dekultur_2.jpg",
      "assets/images/coffeeshops/dekultur_menu.jpg",
    ],
    "hours": {
      "mon": {"open": "08:00", "close": "22:00"},
      "tue": {"open": "08:00", "close": "22:00"},
      "wed": {"open": "08:00", "close": "22:00"},
      "thu": {"open": "08:00", "close": "22:00"},
      "fri": {"open": "08:00", "close": "22:00"},
      "sat": {"open": "08:00", "close": "22:00"},
      "sun": {"open": "08:00", "close": "22:00"},
    },
    "menuPriceRange": {"min": 22000, "max": 90000, "currency": "IDR"},
    "menuHighlights": [
      {"name": "Es Kopi Susu", "priceFrom": 22000},
      {"name": "Matcha", "priceFrom": 28000},
      {"name": "Chocolate Hazelnut", "priceFrom": 30000},
      {"name": "Lychee Tea", "priceFrom": 28000},
    ],
    "facilities": ["indoor_seating", "photo_spots"],
    "facilityNote": "Sebagian fasilitas seed (contoh).",
    "rating": {"value": 4.5, "count": 143, "source": "seed"},
    "reviews": [
      {
        "user": "Yoga",
        "rating": 5,
        "date": "2025-10-26",
        "comment": "Non-kopinya variatif, lychee tea-nya seger.",
        "isSeed": true
      },
      {
        "user": "Mira",
        "rating": 4,
        "date": "2025-08-11",
        "comment": "Weekend rame, tapi vibe-nya dapet.",
        "isSeed": true
      },
      {
        "user": "Fani",
        "rating": 5,
        "date": "2025-07-29",
        "comment": "Matcha-nya enak. Tempatnya estetik.",
        "isSeed": true
      },
    ],
    "source": {"title": "detikSumbagsel (04 Jan 2024)", "type": "article"},
    "isPalembangOnly": true,
  },

  {
    "id": "plg_tobys_estate",
    "name": "Toby's Estate",
    "description":
        "Coffee shop nyaman dengan pilihan minuman dan makanan yang beragam (pasta sampai donburi).",
    "address": "Jl. Letkol Iskandar No.18, Bukit Kecil, Palembang",
    "city": "Palembang",
    "mapQuery": "Toby's Estate Jl Letkol Iskandar Palembang",
    "photos": [
      "assets/images/coffeeshops/tobys_1.jpg",
      "assets/images/coffeeshops/tobys_2.jpg",
      "assets/images/coffeeshops/tobys_menu.jpg",
    ],
    "hours": {
      "mon": {"open": "09:00", "close": "22:00"},
      "tue": {"open": "09:00", "close": "22:00"},
      "wed": {"open": "09:00", "close": "22:00"},
      "thu": {"open": "09:00", "close": "22:00"},
      "fri": {"open": "09:00", "close": "22:00"},
      "sat": {"open": "09:00", "close": "22:00"},
      "sun": {"open": "09:00", "close": "22:00"},
    },
    "menuPriceRange": {"min": 30000, "max": 120000, "currency": "IDR"},
    "menuHighlights": [
      {"name": "Cappuccino", "priceFrom": 35000},
      {"name": "Mocha", "priceFrom": 40000},
      {"name": "Matcha / Chocolate", "priceFrom": 40000},
      {"name": "Pasta / Spaghetti", "priceFrom": 55000},
      {"name": "Nasi Goreng / Donburi", "priceFrom": 50000},
    ],
    "facilities": ["indoor_seating", "comfortable_space"],
    "facilityNote": "Tag kenyamanan seed (contoh) untuk UI.",
    "rating": {"value": 4.6, "count": 190, "source": "seed"},
    "reviews": [
      {
        "user": "Kevin",
        "rating": 5,
        "date": "2025-12-10",
        "comment": "Tempatnya nyaman, cocok buat ngobrol lama. Minumannya rapi.",
        "isSeed": true
      },
      {
        "user": "Maya",
        "rating": 4,
        "date": "2025-10-19",
        "comment": "Makanannya banyak pilihan. Matcha-nya enak.",
        "isSeed": true
      },
      {
        "user": "Reno",
        "rating": 5,
        "date": "2025-09-03",
        "comment": "Kalau mau tempat yang ‘lebih proper’, ini aman.",
        "isSeed": true
      },
    ],
    "source": {"title": "detikSumbagsel (04 Jan 2024)", "type": "article"},
    "isPalembangOnly": true,
  },
];

final List<CoffeShop> coffeShops =
    coffeShopRaw.map((e) => CoffeShop.fromMap(e)).toList();