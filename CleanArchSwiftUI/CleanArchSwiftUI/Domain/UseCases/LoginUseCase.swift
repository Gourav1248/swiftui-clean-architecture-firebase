//
//  LoginUseCase.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 09/05/26.
//


import Foundation

// Depends on: LoginUseCaseProtocol, AuthRepositoryProtocol, AuthError (all Domain)
// Does NOT know about: APIClient, URLSession, Keychain — Data layer ka kaam hai

protocol LoginUseCaseProtocol {
   func execute(email: String, password: String) async throws -> User
}


final class LoginUseCase: LoginUseCaseProtocol {

   // MARK: - Dependencies
   private let repository: AuthRepositoryProtocol

   // MARK: - Init
   init(repository: AuthRepositoryProtocol) {
      self.repository = repository
   }

   // MARK: - Execute
   func execute(email: String, password: String) async throws -> User {

      // Domain rule: network hit karne se pehle empty check
      let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
      guard !trimmedEmail.isEmpty, !password.isEmpty else {
         throw AuthError.invalidCredentials
      }

      // Repository ko delegate karo — actual API call wahan hogi
     return try await repository.signInRequest(email: trimmedEmail, password: password)
   }
}
