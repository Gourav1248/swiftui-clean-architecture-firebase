//
//  SignUpViewModel.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 10/05/26.
//

import Foundation
import SwiftUI

// MARK: - Gender Enum
// Location: Domain/Entities/Gender.swift (ya SignupViewModel ke saath rakh sakte ho)

enum Gender: String, CaseIterable {
   case male   = "male"
   case female = "female"
   case other  = "other"

   var displayName: String {
      switch self {
         case .male:   return "Male"
         case .female: return "Female"
         case .other:  return "Other"
      }
   }
}

// MARK: - SignUpViewModel
// Location: Presentation/Auth/ViewModels/SignupViewModel.swift

@MainActor
final class SignUpViewModel: ObservableObject {

   // MARK: - Inputs
   @Published var firstName:       String = ""
   @Published var lastName:        String = ""
   @Published var email:           String = ""
   @Published var phone:           String = ""
   @Published var address:         String = ""
   @Published var city:            String = ""
   @Published var password:        String = ""
   @Published var confirmPassword: String = ""
   @Published var selectedGender:  Gender = .male
   @Published var strValidationalError: String? = nil
   @Published var alertMessage: (id: UUID, message: String)? = nil

   // MARK: - State
   @Published var isLoading:       Bool  = false
   @Published var signupSucceeded: Bool  = false
   @Published var generalError:    String? = nil
   @Published var currentUser:     User?   = nil

   // MARK: - Dependencies
   private let signUpUseCase: SignUpUseCaseProtocol

   init(signUpUseCase: SignUpUseCaseProtocol = SignUpUseCase(repository: FirebaseAuthRepository())) {
      self.signUpUseCase = signUpUseCase
   }

   // MARK: - Computed

   var isFormValid: Bool {
      !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
      !lastName.trimmingCharacters(in: .whitespaces).isEmpty &&
      !email.trimmingCharacters(in: .whitespaces).isEmpty &&
      !phone.trimmingCharacters(in: .whitespaces).isEmpty &&
      !address.trimmingCharacters(in: .whitespaces).isEmpty &&
      !city.trimmingCharacters(in: .whitespaces).isEmpty &&
      password.count >= 6 &&
      confirmPassword == password
   }

   // MARK: - Signup

   func signup() async {

      let strMsg = validateFields()
      if strMsg.count > 0 {
         generalError = strMsg
      } else {
         isLoading = true
         generalError = nil
         signupSucceeded = false

         let request = SignUpRequestModel(firstName: firstName, lastName: lastName, email: email, phone: phone, password: password, address: address, city: city, gender: selectedGender.displayName, createdAt: Date())


         do {
            let user = try await signUpUseCase.execute(request)
            currentUser     = user
            signupSucceeded = true
         } catch AuthError.emailAlreadyInUse {
            generalError = "This email is already registered. Please sign in."
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
   func validateFields() -> String {
      let trimmedPhone = phone.trimmingCharacters(in: .whitespaces)
      let trimmedEmail = email.trimmingCharacters(in: .whitespaces)

      // First Name
      if firstName.trimmingCharacters(in: .whitespaces).isEmpty {
         strValidationalError = "First name is required"
      } else if lastName.trimmingCharacters(in: .whitespaces).isEmpty {
         strValidationalError = "Last name is required"
      } else if trimmedEmail.isEmpty {
         strValidationalError = "Email is required"
      } else if !isValidEmail(trimmedEmail) {
         strValidationalError = "Enter a valid email address"
      } else if trimmedPhone.isEmpty {
         strValidationalError = "Phone number is required"
      } else if trimmedPhone.count < 10 {
         strValidationalError = "Enter a valid 10-digit phone number"
      } else if address.trimmingCharacters(in: .whitespaces).isEmpty {
         strValidationalError = "Address is required"
      } else if city.trimmingCharacters(in: .whitespaces).isEmpty {
         strValidationalError = "City is required"
      } else if password.isEmpty {
         strValidationalError = "Password is required"
      } else if password.count < 6 {
         strValidationalError = "Password must be at least 6 characters"
      } else if confirmPassword.isEmpty {
         strValidationalError = "Please confirm your password"
      } else if confirmPassword != password {
         strValidationalError = "Passwords do not match"
      }

      return strValidationalError ?? ""
   }

   private func isValidEmail(_ email: String) -> Bool {
      let regex = #"^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
      return email.range(of: regex, options: .regularExpression) != nil
   }
}
