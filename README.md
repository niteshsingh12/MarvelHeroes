# MarvelHeroes
Small app which lets user fetch marvel heroes and recruit them in their squad.


Use Case:

Characters (Heroes) List View (Collection View) with images and title.
Squad List View (When character is added to the squad)
When character is clicked, detail page is displayed with character details (title, description, image, recruit button)
Recruit Button - Clicking on button will add character to the squad, which user can remove by unclicking the button.

Tech Stack:

Language: Swift
Platform: iOS 15
UI: SwiftUI and UIKit (Project has both settings, just visit ContentView.swift and change the view type)
Networking: Combine + URLSession
Database: Core Data (To save squad recruits)
UI Design Pattern: Model View View-Model - Coordinator (MVVM-C) with Dependency Factory (For UIKit)
UI Binding: Combine
Unit Tests (for data driven components)
Depedency Injection with Factories

Notes:

UI is developed in both SwiftUI & UIKit due to insufficient knowledge on SwiftUI (still in learning though progressive phase).
