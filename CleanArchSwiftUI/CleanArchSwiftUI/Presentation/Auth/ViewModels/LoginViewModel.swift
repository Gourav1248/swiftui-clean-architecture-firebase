//
//  LoginViewModel.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 08/05/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class LoginViewModel: ObservableObject {

   // MARK: - Input (bound to View)
   @Published var email: String = ""
   @Published var password: String = ""

   // MARK: - Output (observed by View)
   @Published var isLoading: Bool = false
   @Published var loginSucceeded: Bool = false
   @Published var generalError: String? = nil
   @Published var strValidationalError: String? = nil
   @Published var alertMessage: (id: UUID, message: String)? = nil

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
      generalError = nil
      let strValidationError = validateFields()

      if strValidationError?.count ?? 0 > 0 {
         alertMessage = (id: UUID(), message: strValidationError ?? "")
         generalError = strValidationError  // ✅ directly alert mein jaayega
      } else {
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
   }

   // MARK: - Validation

   @discardableResult
   private func validateFields() -> String? {
      let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
      if trimmedEmail.isEmpty {
         strValidationalError = "Email is required"
      } else if !isValidEmail(trimmedEmail) {
         strValidationalError = "Enter a valid email address"
      } else if password.isEmpty {
         strValidationalError = "Password is required"
      } else if password.count < 6 {
         strValidationalError = "Password must be at least 6 characters"
      }

      return strValidationalError
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
   case emailAlreadyInUse
   case unknown
}
