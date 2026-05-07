//
//  AppError.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 07/05/26.
//

import Foundation

enum AppError: LocalizedError {
   case userNotFound
   case invalidCredentials
   case networkError
   case unknown(String)

   var errorDescription: String? {
      switch self {
         case .userNotFound:
            return "User not found. Please sign up first."
         case .invalidCredentials:
            return "Invalid email or password."
         case .networkError:
            return "Network error. Please try again."
         case .unknown(let message):
            return message
      }
   }
}
