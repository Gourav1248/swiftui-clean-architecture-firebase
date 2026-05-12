//
//  AppRouter.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 11/05/26.
//

import SwiftUI

enum AppRoute: Hashable {
   case login
   case signup
  // case home
}

@MainActor
final class AppRouter: ObservableObject {

   @Published var path = NavigationPath()
   @Published var isAuthenticated: Bool = false

   // MARK: - Push
   func push(_ route: AppRoute) {
      path.append(route)
   }

   // MARK: - Pop
   func pop() {
      path.removeLast()
   }

   // MARK: - Pop to Root
   func popToRoot() {
      path.removeLast(path.count)
   }

   // MARK: - Login Success
   func handleLoginSuccess() {
      popToRoot()
      isAuthenticated = true
   }
}

