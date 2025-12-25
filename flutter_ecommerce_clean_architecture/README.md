
# 🛒 Flutter E-commerce Navigation Demo

A simple Flutter app that demonstrates:

* Named route navigation
* Passing data between screens
* Add/Edit product form
* Product detail page
* Custom page transition animations

---

## 🏛️ Architecture

This project follows the **Clean Architecture** pattern to separate concerns and create a maintainable and scalable application. The architecture is divided into three main layers:

*   **Domain Layer**: This is the core of the application. It contains the business logic and entities. It is independent of any other layer.
*   **Data Layer**: This layer is responsible for retrieving data from one or more sources (like a REST API or a local database). It implements the repositories defined in the domain layer.
*   **Presentation Layer**: This is the UI layer of the application. It contains the widgets and the state management logic. It depends on the domain layer to get the data to display.

### Data Flow

The data flows from the Data Layer to the Presentation Layer through the Domain Layer.

1.  The **Presentation Layer** (UI) requests data from a **UseCase** in the Domain Layer.
2.  The **UseCase** gets the data from a **Repository** in the Domain Layer.
3.  The **Data Layer** has an implementation of the **Repository** that gets the data from a remote or local **DataSource**.
4.  The data is returned to the **Presentation Layer** and displayed on the screen.

---

## 🚀 Features

* View product list
* Add new product
* Edit existing product
* Delete product
* Navigate to details screen
* Smooth slide transition animation



---

## ▶️ How to Run

Make sure Flutter is installed:

```sh
flutter pub get
flutter run
```

---

## 📸 Screens Included

![Image](https://github.com/user-attachments/assets/c291f64d-c083-4377-ade3-a12bbbe85409)
![Image](https://github.com/user-attachments/assets/1440e615-c835-4c15-94dc-9c3db2b6bc14)

---

## 📜 License

This project is for learning and demo purposes.

---

If you want, I can also generate a **more advanced README with badges, images, setup steps, or GIF previews**.
