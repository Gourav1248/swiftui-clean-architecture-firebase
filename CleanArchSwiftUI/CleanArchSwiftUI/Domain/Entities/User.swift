//
//  User.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 06/05/26.
//

import Foundation

// Domain/Entities/User.swift

struct User {
   let uid: String
   var firstName: String
   var lastName: String
   var email: String
   var phone: String
   var address: String
   var city: String
   var gender: String
   var isActive: Bool
   let createdAt: Date

   // Computed property — full name
   var fullName: String {
      "\(firstName) \(lastName)"
   }
}
