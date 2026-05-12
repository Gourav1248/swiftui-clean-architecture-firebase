//
//  FirebaseAuthRepository.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 07/05/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FirebaseAuthRepository: AuthRepositoryProtocol {



   private let db = Firestore.firestore()
   private let auth = Auth.auth()


   func signUpRequest(_ request: SignUpRequestModel) async throws -> User {

      // Step 1: Firebase Auth me user create karo
      let authResult = try await auth.createUser(withEmail: request.email, password: request.password)
      let uid = authResult.user.uid

      //Step 2: Domain user me uid set karo
      let newUser = User(
         uid             : uid,
         firstName       : request.firstName,
         lastName        : request.lastName,
         email           : request.email,
         phone           : request.phone,
         address         : request.address,
         city            : request.city,
         gender          : request.gender,
         isActive        : true,
         createdAt       : request.createdAt
      )

      // Step 3: Firestore me user document save karo
      let dto = UserDTO.fromDomain(newUser)
      try await db.collection("users")
         .document(uid)
         .setData(dto.dictionary)

      return newUser

   }

   func signInRequest(email: String, password: String) async throws -> User {
      let authResult = try await auth.signIn(withEmail: email, password: password)
      let uid = authResult.user.uid

      let obUser = try await db.collection("users")
         .document(uid).getDocument()

      guard let obUserData = obUser.data() else {
         throw AppError.userNotFound
      }

      let userDTO = UserDTO.fromFirestore(uid: uid, data: obUserData)
      return userDTO.toDomain()
   }

   func forgotPasswordRequest(email: String) async throws {
      try await auth.sendPasswordReset(withEmail: email)
   }

   // MARK: - Change Password
   func changePasswordRequest(currentPassword: String,
                              newPassword: String) async throws {

      guard let currentUser = auth.currentUser,
            let email = currentUser.email else {
         throw AppError.userNotFound
      }

      // Re-authenticate first — Firebase requires this for sensitive ops
      let credential = EmailAuthProvider.credential(withEmail: email,
                                                    password: currentPassword)
      try await currentUser.reauthenticate(with: credential)

      // Then update password
      try await currentUser.updatePassword(to: newPassword)
   }

   // MARK: - Logout
   func logoutRequest() throws {
      try auth.signOut()
   }

   // MARK: - Get Current User
   func getCurrentUserRequest() -> User? {
      guard let firebaseUser = auth.currentUser else { return nil }

      return User(
         uid             : firebaseUser.uid,
         firstName       : "",
         lastName        : "",
         email           : firebaseUser.email ?? "",
         phone           : "",
         address         : "",
         city            : "",
         gender          : "",
         isActive        : true,
         createdAt       : Date()
      )
   }


}
