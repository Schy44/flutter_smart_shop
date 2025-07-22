# 🛍️ Smart Shop – Mini E-commerce App (Flutter)

Welcome to **Smart Shop**, a lightweight yet powerful mini e-commerce app built using **Flutter**. This project demonstrates key mobile development concepts like state management, API integration, theme persistence, and routing — all wrapped in a clean, user-friendly interface.

> **✨ Bonus:** I used my own custom API from [Dermeze](https://dermeze.onrender.com/api/) 

---

## 🚀 Features
### 🔐 Authentication

* **Login/Register** screen with `TextFormField` + validation
* Stores login state using `SharedPreferences`
* Supports dummy login or real API auth
* **Splash Screen** with GIF animation that checks login status and redirects accordingly

### 🏠 Home Page

* Fetches & displays product list from `https://dermeze.onrender.com/api/products/`
* Includes product **name**, **price**, and **image**
* **Favorites** toggle via heart icon (saved with `Provider` + `SharedPreferences`)
* ⭐ Displays rating stars (from `rating.rate`)
* 🧐 Smart product suggestions based on same category 'https://dermeze.onrender.com/api/categories/' (extra feature!)
* 🔀 Pull-to-refresh with `RefreshIndicator`
* �� Sorting: price (low→high, high→low), rating

### 🛒 Cart Page

* Shows all added items with:
  * Quantity
  * Total price
  * Ratings
  * options for adding or removing quantity/products
* Dynamic cart **badge** in AppBar
* Managed using `Provider` for reactive state

### 🎨 Theme Switch
* Toggle between **Dark** & **Light** mode
* Uses `SharedPreferences` to remember your theme

### 📂 Drawer Navigation
* Clean drawer UI to navigate between:
  * Home
  * Cart
  * Profile
  * Favorites
  * Logout

### 🔓 Logout
* Clears login credentials from `SharedPreferences`
* Redirects back to login screen

## 🔗 API Endpoints

All data is served via my custom REST API:

* 🛒 Products: `https://dermeze.onrender.com/api/products/`
* 🤝 Categories: `https://dermeze.onrender.com/api/categories/`

## 📹 Optional Video Walkthrough

> *If you have a short video showing project flow, embed the link here (Drive).*
https://drive.google.com/file/d/1mXfYBI-CUl3Sm-sEzqyt9zQYJUg1RCv_/view
---


