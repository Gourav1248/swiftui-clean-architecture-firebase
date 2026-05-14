//
//  LoaderManager.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 14/05/26.
//

import SwiftUI

@MainActor
final class LoaderManager: ObservableObject {

   // Ye true hoga tab loader dikhega
   @Published var isLoading: Bool = false

   // Optional message — "Please wait..." etc
   @Published var message: String = "Please wait..."

   // Show loader
   func show(message: String = "Please wait...") {
      self.message = message
      self.isLoading = true
   }

   // Hide loader
   func hide() {
      self.isLoading = false
   }
}

