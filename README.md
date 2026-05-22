# swiftui-clean-architecture-firebase
**CleanArchSwiftUI 🚀**
A sample iOS application built while exploring Clean Architecture in SwiftUI with Firebase integration.
The main goal of this project is to understand how scalable architecture patterns can help in building modular, maintainable, and testable iOS applications.

**✨ Features**
SwiftUI based UI
Clean Architecture structure
MVVM Pattern
Coordinator / Router based navigation
Firebase Authentication
Repository Pattern
UseCases
Protocol-based abstraction
DTO & Entity separation
Loader & Alert management
NavigationStack routing


**🏗 Architecture Overview**
The project follows a layered Clean Architecture approach:
Presentation
    ↓
Domain
    ↓
Data
📱 Presentation Layer
Responsible for UI and presentation logic.
Contains:
Views
ViewModels
Coordinators / Routers
UI Components

Example:
Presentation/
    Home/
    Category/
    SideMenu/
    
**🧠 Domain Layer**
Contains the core business logic of the application.
Includes:
UseCases
Repository Protocols
Entities

Example:
Domain/
    UseCases/
    Repositories/
    Entities/

**💾 Data Layer**
Handles API/Firebase communication and data mapping.
Includes:
Repository Implementations
DTOs
DataSources
Example:
Data/
    Repositories/
    DataSources/

    
**🔄 Project Flow**
View
 ↓
ViewModel
 ↓
UseCase
 ↓
Repository
 ↓
Firebase / DataSource


**🧭 Navigation**
The project uses a Coordinator/Router based navigation approach with NavigationStack.
Responsibilities include:
Screen navigation
App flow handling
Authentication flow management

Example:
AppCoordinator
AppRouter

**🔥 Firebase**
Currently exploring Firebase integration for:
Authentication
User session handling
📂 Folder Structure
CleanArchSwiftUI
│
├── App
├── Core
├── Data
├── Domain
└── Presentation

**🛠 Technologies Used**
Swift
SwiftUI
Firebase
MVVM
Clean Architecture
NavigationStack

**🎯 Learning Goals**
This project was created while exploring:
Scalable iOS architecture
Separation of concerns
Modular project structure
Better navigation management
Reusable and testable code patterns


**🚧 Work in Progress**
This project is still under active learning and experimentation.
More improvements and features will be added gradually while exploring better architecture practices in iOS development.

**🤝 Feedback**
Open to suggestions, improvements, and feedback while continuing to learn and improve the architecture structure.
👨‍💻 Author
Gourav Joshi

LinkedIn: https://www.linkedin.com/in/gourav-joshi-68309b50/

GitHub: https://github.com/Gourav1248/swiftui-clean-architecture-firebase
