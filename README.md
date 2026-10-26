# 📦 Parcel Locker Delivery System

A robust transactional information system for automated parcel locker delivery (Paczkomat-style network), featuring safe concurrent compartment allocation, PostgreSQL ACID transactions, and an intuitive UI.

## 👥 Authors & Team
- **Nikita Kalashnikov** ([@nakkalashnikov](https://github.com/nakkalashnikov))
- **Serhii Bulo** ([@SerhiiBulo](https://github.com/SerhiiBulo))
- **Artem Tiutiun** ([@ArtemTiutiun](https://github.com/ArtemTiutiun))

## 🚀 Key Features
- **Parcel Lifecycle Management**: Pending $\to$ In Locker $\to$ Collected / Expired / Returned.
- **Smart Compartment Allocation**: Automatic fit checking (S, M, L) and row-level locking (`SELECT ... FOR UPDATE`) to prevent race conditions during peak courier deposits.
- **ACID Transactions**: Atomic deposits with guaranteed rollback on partial failure.
- **Analytics & Reporting**: Multi-table JOINs, window functions, and utilization views.

## 🛠 Tech Stack
- **Database**: PostgreSQL 16
- **Backend / API**: Python (FastAPI / SQLAlchemy)
- **Frontend**: Responsive UI (HTML5 / Tailwind CSS / JavaScript)
- **DevOps**: Docker & Docker Compose
