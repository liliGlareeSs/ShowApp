# Show App 🎬

Une application Flutter pour gérer vos films, séries et animés préférés, connectée à un backend Node.js.

![App Screenshot](screenshot.png) *(Remplacez par votre propre capture d'écran)*

## Fonctionnalités ✨

- 📱 Interface mobile intuitive
- 🎥 Gestion des films, séries et animés
- 📸 Upload d'images depuis la galerie ou l'appareil photo
- 🔄 Synchronisation en temps réel avec le backend
- 🔐 Système d'authentification sécurisé
- ♻️ Rafraîchissement automatique des données

## Technologies 🛠️

**Frontend (Flutter)**:
- Framework: Flutter 3.x
- État: Provider
- HTTP: Dio/Http
- Gestion d'images: Image Picker
- Stockage local: SharedPreferences

**Backend (Node.js)**:
- Framework: Express.js
- Base de données: SQLite
- Upload d'images: Multer
- Authentification: JWT

## Prérequis 📋

- Flutter SDK 3.0+
- Node.js 16+
- Emulateur Android/iOS ou appareil physique
- Backend Show App (voir le dépôt backend)

## Installation 🚀

1. **Cloner le dépôt**:
   ```bash
   git clone https://github.com/votre-utilisateur/show-app-flutter.git
   cd show-app-flutter
2. **Installer les dépendances**:

bash
Copy
flutter pub get

3. **Configurer l'API**:
Créer un fichier lib/config/api_config.dart:

dart
Copy
class ApiConfig {
  static const String baseUrl = "http://votre-ip:5000";
}
4. **Lancer l'application**:

bash
Copy
flutter run

## Structure du projet 📂
lib/
├── config/            # Configuration
├── models/            # Modèles de données
├── providers/         # Gestion d'état
├── screens/
    ├── login_page.dart
    ├── home_page.dart
    ├── profile_page.dart
    ├── add_show_page.dart       
                               # Écrans de l'application
├── services/          # Services API
├── widgets/           # Composants réutilisables
└── main.dart          # Point d'entrée


## Captures d'écran 📸

 .**Login Screen**	**Home Screen**	   **Add Show**
Login
![Login](../captures_myapp/login.png)


Home
![home-anime](../captures_myapp/anime.png)
![home-movies](../captures_myapp/movies.png)
![home-series](../captures_myapp/series.png)


Add
![add-show](../captures_myapp/addshow.png)



## Contact 📧

https://github.com/liliGlareeSs

email : najah.ghi.fst@uhp.ac.ma
 or nahahghizlane@gmail.com
