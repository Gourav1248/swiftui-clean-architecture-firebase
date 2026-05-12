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


   // MARK: - Field Errors
   @Published var firstNameError:       String? = nil
   @Published var lastNameError:        String? = nil
   @Published var emailError:           String? = nil
   @Published var phoneError:           String? = nil
   @Published var addressError:         String? = nil
   @Published var cityError:            String? = nil
   @Published var passwordError:        String? = nil
   @Published var confirmPasswordError: String? = nil

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
      guard validateFields() else { return }

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

   // MARK: - Validation

   @discardableResult
   func validateFields() -> Bool {
      var valid = true

      // First Name
      if firstName.trimmingCharacters(in: .whitespaces).isEmpty {
         firstNameError = "First name is required"
         valid = false
      } else { firstNameError = nil }

      // Last Name
      if lastName.trimmingCharacters(in: .whitespaces).isEmpty {
         lastNameError = "Last name is required"
         valid = false
      } else { lastNameError = nil }

      // Email
      let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
      if trimmedEmail.isEmpty {
         emailError = "Email is required"
         valid = false
      } else if !isValidEmail(trimmedEmail) {
         emailError = "Enter a valid email address"
         valid = false
      } else { emailError = nil }

      // Phone
      let trimmedPhone = phone.trimmingCharacters(in: .whitespaces)
      if trimmedPhone.isEmpty {
         phoneError = "Phone number is required"
         valid = false
      } else if trimmedPhone.count < 10 {
         phoneError = "Enter a valid 10-digit phone number"
         valid = false
      } else { phoneError = nil }

      // Address
      if address.trimmingCharacters(in: .whitespaces).isEmpty {
         addressError = "Address is required"
         valid = false
      } else { addressError = nil }

      // City
      if city.trimmingCharacters(in: .whitespaces).isEmpty {
         cityError = "City is required"
         valid = false
      } else { cityError = nil }

      // Password
      if password.isEmpty {
         passwordError = "Password is required"
         valid = false
      } else if password.count < 6 {
         passwordError = "Password must be at least 6 characters"
         valid = false
      } else { passwordError = nil }

      // Confirm Password
      if confirmPassword.isEmpty {
         confirmPasswordError = "Please confirm your password"
         valid = false
      } else if confirmPassword != password {
         confirmPasswordError = "Passwords do not match"
         valid = false
      } else { confirmPasswordError = nil }

      return valid
   }

   private func isValidEmail(_ email: String) -> Bool {
      let regex = #"^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#
      return email.range(of: regex, options: .regularExpression) != nil
   }
}
