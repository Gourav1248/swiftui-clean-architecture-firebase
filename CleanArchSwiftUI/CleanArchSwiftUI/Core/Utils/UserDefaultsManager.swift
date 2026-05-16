//
//  UserDefaultsManager.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 16/05/26.
//

import Foundation

// UserDefaultsManager.swift
enum UserDefaultsKeys {
   static let isLoggedIn = "isLoggedIn"
   static let userId     = "userId"
   static let userEmail  = "userEmail"
}

class UserDefaultsManager {
   static let shared = UserDefaultsManager()
   private init() {}

   var isLoggedIn: Bool {
      get { UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLoggedIn) }
      set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.isLoggedIn) }
   }

   var userId: String? {
      get { UserDefaults.standard.string(forKey: UserDefaultsKeys.userId) }
      set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.userId) }
   }

   var userEmail: String? {
      get { UserDefaults.standard.string(forKey: UserDefaultsKeys.userEmail) }
      set { UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.userEmail) }
   }

   func clearAll() {
      UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLoggedIn)
      UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userId)
      UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userEmail)
   }
}
