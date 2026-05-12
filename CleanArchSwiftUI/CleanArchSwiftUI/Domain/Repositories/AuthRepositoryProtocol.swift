//
//  AuthRepositoryProtocol.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 06/05/26.
//
// Domain/Repositories/AuthRepositoryProtocol.swift

import Foundation

protocol AuthRepositoryProtocol {
   func signUpRequest(_ request: SignUpRequestModel) async throws -> User
   func signInRequest(email: String, password: String) async throws -> User
   func forgotPasswordRequest(email: String) async throws
   func changePasswordRequest(currentPassword: String, newPassword: String) async throws
   func logoutRequest() throws
   func getCurrentUserRequest() -> User?
}
