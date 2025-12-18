# Flutter E-Commerce App (Clean Architecture)

## 📌 Project Overview

This project is a simple E-Commerce mobile application built using **Flutter** and structured according to **Clean Architecture principles**.  
It demonstrates proper separation of concerns, CRUD operations, and Test-Driven Development (TDD) readiness.

The application allows users to:
- Create products
- View product details
- Update existing products
- Delete products

---

## 🧱 Architecture Overview

The project follows **Clean Architecture**, divided into three main layers:

### 1. Domain Layer
Contains the core business logic of the application.
- **Entities**: Business objects (e.g., Product)
- **Use Cases**: Application-specific business rules
- **Repositories (abstract)**: Contracts for data access

### 2. Data Layer
Responsible for data handling and repository implementation.
- In-memory data storage (can be replaced with API or database)

### 3. Presentation Layer
Contains the UI built with Flutter widgets.
- Screens
- Navigation
- User interactions

---

## 📁 Folder Structure



lib/
├── features/
│ └── product/
│ ├── domain/
│ │ ├── entities/
│ │ ├── repositories/
│ │ └── usecases/
│ ├── data/
│ │ └── repositories/
│ └── presentation/
│ └── screens/
├── main.dart


---

## 🧩 Product Entity

The `Product` entity contains the following properties:
- `id`
- `name`
- `description`
- `price`
- `imageUrl`

---

## 🔄 Use Cases (CRUD)

The application supports the following use cases:
- **InsertProduct** – Add a new product
- **UpdateProduct** – Update an existing product
- **DeleteProduct** – Remove a product
- **GetProduct** – Retrieve product details

Each use case has a single responsibility and interacts only with the repository abstraction.

---

## 🗄 Repository Pattern

- `ProductRepository` defines the contract for data operations.
- `ProductRepositoryImpl` provides an in-memory implementation.
- This allows easy replacement with REST API, Firebase, or local database.

---

## 🧪 Test-Driven Development (TDD)

The project is designed to support TDD:
- Business logic is isolated and testable
- Use cases can be unit tested independently
- Repositories can be mocked in tests

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK
- Dart







