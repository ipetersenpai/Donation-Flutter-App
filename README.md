# Donation Management System
![php](https://img.shields.io/badge/php-%fcc803.svg?style=for-the-badge&logo=php&logoColor=white)
![Laravel](https://img.shields.io/badge/laravel-%23FF2D20.svg?style=for-the-badge&logo=laravel&logoColor=white)
[![mysql](https://img.shields.io/badge/mysql-2d97d2?style=for-the-badge&logo=mysql&logoColor=orange)](https://www.mysql.com/)

## Installation Guide for Donation Management System

### Clone the Repository

1. Open your terminal or command prompt.
2. Navigate to the directory where you want to store your Laravel project.
3. Clone the repository using the following command:

   ```bash
   git clone https://github.com/ipetersenpai/Donation-Management-System.git
   cd Donation-Management-System
   ```

### Prerequisites

Before you begin, ensure you have met the following requirements:

- [PHP](https://www.php.net/manual/en/install.php) (version 8.0 or higher)
- [Composer](https://getcomposer.org/download/)
- [MySQL](https://www.mysql.com/downloads/) (or any compatible database)
- A web server like [XAMPP](https://www.apachefriends.org/index.html) or [Laragon](https://laragon.org/) (or you can use Laravel's built-in server)

For detailed instructions on installing and configuring XAMPP, visit the [XAMPP Documentation](https://www.apachefriends.org/docs/).

### Setup Instructions

#### 1. Install Composer Dependencies

Run the following command to install all the required dependencies specified in the `composer.json` file:

```bash
composer install
```

#### 2. Create a Copy of the Environment File

Laravel requires an `.env` file for configuration. Make a copy of the `.env.example` file and rename it to `.env`:

```bash
cp .env.example .env
```

#### 3. Generate Application Key

Run the following command to generate a unique application key for your Laravel application:

```bash
php artisan key:generate
```

#### 4. Configure Your Environment Variables

Open the `.env` file in a text editor and configure your environment variables, including your database connection settings and email settings.

For example, update the following lines:

```plaintext
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=your_database_name
DB_USERNAME=your_username
DB_PASSWORD=your_password

MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=465
MAIL_USERNAME=your_email@gmail.com
MAIL_PASSWORD=your_email_app_password
MAIL_ENCRYPTION=ssl
MAIL_FROM_ADDRESS="your_email@gmail.com"
MAIL_FROM_NAME="Donation System"
```

### 5. Run Database Migrations

Create a database (for example, `donation_db`) using phpMyAdmin or your preferred MySQL client.

Then, run the database migrations to create the necessary tables:

```bash
php artisan migrate
```

### 6. Serve the Application on a Specific IP Address

To serve your Laravel application on a specific IP address (e.g., `192.168.1.100`), run the following command:

```bash
php artisan serve --host=192.168.1.100 --port=8000
```

### 7. Access the Application

Open your web browser and navigate to:

```
http://192.168.1.100:8000
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

