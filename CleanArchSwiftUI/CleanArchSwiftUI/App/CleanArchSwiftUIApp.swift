//
//  CleanArchSwiftUIApp.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 04/05/26.
//

import SwiftUI
import Firebase

@main
struct CleanArchSwiftUIApp: App {

   init() {
      FirebaseApp.configure()
   }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
