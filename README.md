# 🏪 Sellify - Complete Classified Ads System

[![PHP](https://img.shields.io/badge/PHP-66.2%25-777BB4?style=flat&logo=php&logoColor=white)](https://php.net)
[![Flutter](https://img.shields.io/badge/Flutter-25.8%25-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev)
[![CSS](https://img.shields.io/badge/CSS-5.9%25-1572B6?style=flat&logo=css3&logoColor=white)](https://www.w3.org/Style/CSS)
[![JavaScript](https://img.shields.io/badge/JavaScript-1.6%25-F7DF1E?style=flat&logo=javascript&logoColor=black)](https://javascript.com)
[![License](https://img.shields.io/badge/license-Open%20Source-green)](LICENSE)
[![Contributors Welcome](https://img.shields.io/badge/contributors-welcome-brightgreen.svg)](CONTRIBUTING.md)

A modern, full-stack classified ads platform built with PHP backend, Flutter mobile app, and responsive web interface. Perfect for creating marketplace applications like OLX, Craigslist, or local classified ads platforms.

## ✨ Features

### 🌐 Multi-Platform Support
- **Web Application** - Responsive PHP-based website
- **Admin Panel** - Complete administrative dashboard
- **Mobile App** - Cross-platform Flutter application
- **Database** - MySQL database with optimized structure

### 🚀 Core Functionality
- **User Management** - Registration, authentication, and profile management
- **Ad Posting** - Create, edit, and manage classified advertisements
- **Category System** - Organized ad categories and subcategories
- **Search & Filter** - Advanced search with location and category filters
- **Payment Integration** - Stripe payment gateway integration
- **Image Management** - Multiple image uploads for ads
- **Location Services** - GPS-based location features
- **Messaging System** - In-app communication between users
- **Admin Dashboard** - Complete backend management system

## 🏗️ Project Structure

```
Classsified_ads_system/
├── 📱 sellify flutter App code/     # Mobile application (Flutter/Dart)
├── 🌐 sellifyWeb/                   # Main web application (PHP)
├── 🛠️ sellify web admin code/       # Admin panel (PHP/JavaScript)
├── 🗄️ sellify database/             # Database structure and setup
└── 📋 .github/                      # GitHub workflows and templates
```

## 🛠️ Tech Stack

**Backend & Web:**
- PHP (Primary backend language)
- MySQL Database
- CSS3 & JavaScript (Frontend styling and interactions)
- Stripe Payment Integration

**Mobile Application:**
- Flutter/Dart framework
- Cross-platform iOS/Android support

**Development Tools:**
- CMake (Build configuration)
- GitHub Actions (CI/CD)

## 🚀 Quick Start

### Prerequisites
- PHP 7.4 or higher
- MySQL 5.7 or higher
- Flutter SDK 3.0+
- Composer (PHP package manager)
- Node.js (for asset compilation)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Mustaf-hub/Classsified_ads_system.git
   cd Classsified_ads_system
   ```

2. **Set up the database**
   ```bash
   # Import the database structure
   mysql -u your_username -p your_database < "sellify database/sellify.sql"
   ```

3. **Configure the web application**
   ```bash
   cd sellifyWeb
   composer install
   cp config/config.example.php config/config.php
   # Edit config.php with your database credentials
   ```

4. **Set up the admin panel**
   ```bash
   cd "sellify web admin code"
   # Configure database connection in config files
   ```

5. **Run the Flutter app**
   ```bash
   cd "sellify flutter App code"
   flutter pub get
   flutter run
   ```

## 🤝 Contributing

We welcome contributions from developers of all skill levels! Here's how you can help:

### 🎯 Areas Where We Need Help

- **🐛 Bug Fixes** - Help us identify and fix issues
- **✨ Feature Development** - Implement new features and improvements
- **📱 Mobile App Enhancement** - Improve the Flutter application
- **🎨 UI/UX Improvements** - Enhance user interface and experience
- **📚 Documentation** - Improve code documentation and guides
- **🧪 Testing** - Write tests and improve code coverage
- **🌐 Localization** - Add multi-language support
- **🔒 Security** - Security audits and improvements

### 🚀 Getting Started as a Contributor

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Make your changes** and test thoroughly
4. **Commit your changes** (`git commit -m 'Add amazing feature'`)
5. **Push to your branch** (`git push origin feature/amazing-feature`)
6. **Open a Pull Request**

### 📋 Development Guidelines

- Follow PSR-12 coding standards for PHP
- Use meaningful commit messages
- Add comments for complex logic
- Test your changes before submitting
- Update documentation when needed

## 📸 Screenshots

*Screenshots will be added soon - contributors welcome to help with this!*

## 🗺️ Roadmap

- [ ] **API Development** - RESTful API for third-party integrations
- [ ] **Real-time Chat** - WebSocket-based messaging system
- [ ] **Push Notifications** - Firebase integration for notifications
- [ ] **Social Media Integration** - Login with Facebook/Google
- [ ] **Advanced Analytics** - User behavior and ad performance analytics
- [ ] **Multi-currency Support** - Support for different currencies
- [ ] **Geolocation Features** - Map-based ad browsing
- [ ] **Mobile App Optimization** - Performance improvements

## 🐛 Bug Reports & Feature Requests

Found a bug or have a great idea? We'd love to hear from you!

- **Bug Reports:** [Create an issue](https://github.com/Mustaf-hub/Classsified_ads_system/issues/new?template=bug_report.md)
- **Feature Requests:** [Request a feature](https://github.com/Mustaf-hub/Classsified_ads_system/issues/new?template=feature_request.md)

## 💬 Community & Support

- **Discussions:** [GitHub Discussions](https://github.com/Mustaf-hub/Classsified_ads_system/discussions)
- **Issues:** [GitHub Issues](https://github.com/Mustaf-hub/Classsified_ads_system/issues)

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👨‍💻 Author

**Mustaf-hub** - [GitHub Profile](https://github.com/Mustaf-hub)

## ⭐ Show Your Support

If you find this project helpful, please give it a star! It helps others discover the project and shows appreciation for the work.

---

**Ready to contribute?** Check out our [Contributing Guide](CONTRIBUTING.md) and join our community of developers building the next generation of classified ads platforms! 🚀
