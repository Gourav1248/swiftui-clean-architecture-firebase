//
//  UserRepositoryProtocol.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 06/05/26.
//

import Foundation

protocol UserRepositoryProtocol {
   func fetchUserRequest(uid: String) async throws -> User
   func updateUserRequest(_ user: User) async throws
   func uploadProfilePhotoRequest(uid: String, imageData: Data) async throws -> String
}
