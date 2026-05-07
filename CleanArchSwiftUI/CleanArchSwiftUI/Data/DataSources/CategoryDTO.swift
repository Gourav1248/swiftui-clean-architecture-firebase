//
//  CategoryDTO.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 06/05/26.
//
// Data/DataSources/CategoryDTO.swift

import Foundation
import FirebaseFirestore

struct CategoryDTO {

   var categoryId: String
   var name: String
   var slug: String
   var imageUrl: String
   var isActive: Bool

   // MARK: - Firestore [String: Any] → DTO
   static func fromFirestore(id: String, data: [String: Any]) -> CategoryDTO {
      CategoryDTO(
         categoryId : id,
         name       : data["name"]     as? String ?? "",
         slug       : data["slug"]     as? String ?? "",
         imageUrl   : data["imageUrl"] as? String ?? "",
         isActive   : data["isActive"] as? Bool   ?? true
      )
   }

   // MARK: - DTO → Firestore Dictionary
   var dictionary: [String: Any] {
      return [
         "categoryId" : categoryId,
         "name"       : name,
         "slug"       : slug,
         "imageUrl"   : imageUrl,
         "isActive"   : isActive
      ]
   }

   // MARK: - DTO → Domain Entity
   func toDomain() -> Category {
      Category(
         categoryId : categoryId,
         name       : name,
         slug       : slug,
         imageUrl   : imageUrl,
         isActive   : isActive
      )
   }

   // MARK: - Domain → DTO
   static func fromDomain(_ category: Category) -> CategoryDTO {
      CategoryDTO(
         categoryId : category.categoryId,
         name       : category.name,
         slug       : category.slug,
         imageUrl   : category.imageUrl,
         isActive   : category.isActive
      )
   }
}
