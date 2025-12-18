# 🛒 Flutter E-commerce Product Management Demo

A simple Flutter app that demonstrates:

* **Clean Architecture (DDD):** Clear separation into Domain, Data, and Presentation layers.
* Named route navigation
* Passing data between screens
* Add/Edit product form with validation
* **Local Image Assets:** Displays product images loaded directly from the `assets/images` folder.
* Custom page transition animations

---

## 🚀 Features

* View product list using `ViewAllProductsUsecase`
* Add new product using `CreateProductUsecase`
* Edit existing product using `UpdateProductUsecase`
* Delete product using `DeleteProductUsecase`
* Smooth slide transition animation

---

## 📸 Screenshots

![photo_2025-12-04_21-58-07](https://github.com/user-attachments/assets/632aaac2-2d5e-412e-9c92-ad9b57c768af)

![photo_2025-12-04_21-57-56](https://github.com/user-attachments/assets/d5de6f0b-0d63-420c-a4cd-292a6f9b656d)

---

## ▶️ How to Run

### Setup Assets

1.  Create the folder: **`assets/images/`** in the project root.
2.  Place your image files (e.g., `gaming_laptop.jpg`) inside this folder.
3.  Ensure the folder is registered in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
