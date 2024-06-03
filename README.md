# FreshFridge

FreshFridge is a home food tracking application designed to help you manage your food inventory, reduce waste, and ensure food safety. The application supports multiple user accounts, allowing each user to maintain their own "Fresh Fridge" list and receive notifications for food items nearing their expiration dates.

## Features

- **Track Fresh and Frozen Foods**: Maintain a list of fresh produce, meats, seafood, and cooked foods, as well as frozen items.
- **Expiration Notifications**: Receive alerts when items are nearing their use-by, warning, and expiration dates.
- **Multi-User Support**: Each user can have their own list of food items.
- **Multiple Notification Methods**: Users can add multiple phone numbers and email addresses to receive notifications.

## Getting Started

### Prerequisites

- **Go**: Ensure you have Go installed. You can download it from [golang.org](https://golang.org/).
- **PostgreSQL**: Ensure you have PostgreSQL installed. You can download it from [postgresql.org](https://www.postgresql.org/).

### Installation

1. **Clone the repository**:
    ```sh
    git clone https://github.com/jgndev/freshfridge.git
    cd freshfridge
    ```

2. **Set up the database**:
    ```sh
    createdb freshfridge
    psql freshfridge < schema.sql
    ```

3. **Configure environment variables**:
   Create a `.env` file in the root directory with the following contents:
    ```env
    DB_HOST=localhost
    DB_PORT=5432
    DB_USER=yourusername
    DB_PASSWORD=yourpassword
    DB_NAME=freshfridge
    ```

4. **Run the application**:
    ```sh
    go run main.go
    ```

### Usage

1. **Log in**:
   Open your web browser and go to `http://localhost:8080`. Use the default credentials:
    - **Username**: `freshfridge`
    - **Password**: `admin`

2. **Add food items**:
   Add fresh or frozen food items to your list, and set their categories. The application will automatically calculate their expiration dates based on the category settings.

3. **Receive notifications**:
   Add phone numbers and email addresses to your account to receive notifications about food items nearing their expiration dates.

## Contributing

We welcome contributions to FreshFridge! To contribute, follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add new feature'`).
5. Push to the branch (`git push origin feature-branch`).
6. Create a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

- [bcrypt](https://github.com/pyca/bcrypt) for password hashing.
- [uuid-ossp](https://www.postgresql.org/docs/current/uuid-ossp.html) extension for PostgreSQL UUID generation.

---

Developed by Jeremy Novak (jgndev).
