//
//  UserDTO.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 06/05/26.
//

import Foundation

// Data/DataSources/UserDTO.swift

import FirebaseFirestore

struct UserDTO: Codable {

   var uid: String?
   var firstName: String
   var lastName: String
   var email: String
   var phone: String
   var address: String
   var city: String
   var gender: String
   var isActive: Bool
   var createdAt: Date

   // MARK: - Firestore document dictionary
   var dictionary: [String: Any] {
      return [
         "uid"             : uid ?? "",
         "firstName"       : firstName,
         "lastName"        : lastName,
         "email"           : email,
         "phone"           : phone,
         "address"         : address,
         "city"            : city,
         "gender"          : gender,
         "isActive"        : isActive,
         "createdAt"       : createdAt
      ]
   }

   // MARK: - DTO → Domain Entity
   func toDomain() -> User {
      User(
         uid          : uid ?? "",
         firstName    : firstName,
         lastName     : lastName,
         email        : email,
         phone        : phone,
         address      : address,
         city         : city,
         gender       : gender,
         isActive     : isActive,
         createdAt    : createdAt
      )
   }

   // MARK: - Domain Entity → DTO
   static func fromDomain(_ user: User) -> UserDTO {
      UserDTO(
         uid          : user.uid,
         firstName    : user.firstName,
         lastName     : user.lastName,
         email        : user.email,
         phone        : user.phone,
         address      : user.address,
         city         : user.city,
         gender       : user.gender,
         isActive     : user.isActive,
         createdAt    : user.createdAt
      )
   }
}
