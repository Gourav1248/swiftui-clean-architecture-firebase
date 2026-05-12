//
//  SignUpUseCase.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 11/05/26.
//

import Foundation

protocol SignUpUseCaseProtocol {
   func execute(_ request: SignUpRequestModel) async throws -> User
}

final class SignUpUseCase: SignUpUseCaseProtocol {

   private let repository: AuthRepositoryProtocol

   init(repository: AuthRepositoryProtocol) {
      self.repository = repository
   }

   func execute(_ request: SignUpRequestModel) async throws -> User {
      guard !request.email.isEmpty, !request.password.isEmpty else {
         throw AuthError.invalidCredentials
      }
      return try await repository.signUpRequest(request)
   }
}
