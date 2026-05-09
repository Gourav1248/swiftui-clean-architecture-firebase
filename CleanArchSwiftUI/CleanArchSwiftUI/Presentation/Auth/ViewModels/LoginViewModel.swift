//
//  LoginViewModel.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

final class LoginViewModel: ObservableObject {

   // MARK: - Input (bound to View)
   @Published var email: String = ""
   @Published var password: String = ""

   // MARK: - Output (observed by View)
   @Published var isLoading: Bool = false
   @Published var loginSucceeded: Bool = false
   @Published var generalError: String? = nil

   // Field-level errors
   @Published var emailError: String? = nil
   @Published var passwordError: String? = nil

   // MARK: - Dependencies (injected)
   private let loginUseCase: LoginUseCaseProtocol

   // MARK: - Init
   init(loginUseCase: LoginUseCaseProtocol = LoginUseCase(repository: FirebaseAuthRepository())) {
      self.loginUseCase = loginUseCase
   }

   @Published var currentUser: User? = nil  // ✅ add this


   // MARK: - Computed

   var isFormValid: Bool {
      !email.trimmingCharacters(in: .whitespaces).isEmpty &&
      password.count >= 6
   }

   // MARK: - Actions

   func login() async {
      guard validateFields() else { return }

      isLoading = true
      generalError = nil
      loginSucceeded = false

      do {
        let user =  try await loginUseCase.execute(
            email: email.trimmingCharacters(in: .whitespaces),
            password: password
         )
         loginSucceeded = true
         currentUser = user
      } catch AuthError.invalidCredentials {
         generalError = "Incorrect email or password. Please try again."
      } catch AuthError.networkUnavailable {
         generalError = "No internet connection. Please check your network."
      } catch {
         generalError = "Something went wrong. Please try again."
      }

      isLoading = false
   }

   // MARK: - Validation

   @discardableResult
   private func validateFields() -> Bool {
      var valid = true

      // Email
      let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
      if trimmedEmail.isEmpty {
         emailError = "Email is required"
         valid = false
      } else if !isValidEmail(trimmedEmail) {
         emailError = "Enter a valid email address"
         valid = false
      } else {
         emailError = nil
      }

      // Password
      if password.isEmpty {
         passwordError = "Password is required"
         valid = false
      } else if password.count < 6 {
         passwordError = "Password must be at least 6 characters"
         valid = false
      } else {
         passwordError = nil
      }

      return valid
   }

   private func isValidEmail(_ email: String) -> Bool {
      let regex = #"^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
      return email.range(of: regex, options: .regularExpression) != nil
   }
}

// MARK: - Auth Errors (Domain/Entities or Domain/UseCases level)

enum AuthError: Error {
   case invalidCredentials
   case networkUnavailable
   case unknown
}
