//
//  StoreDTO.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 06/05/26.
//
// Data/DataSources/StoreDTO.swift

import Foundation
import FirebaseFirestore

struct StoreDTO {

   var id: String
   var name: String
   var description: String
   var category: String
   var categorySlug: String
   var isActive: Bool
   var contact: StoreContactDTO
   var location: StoreLocationDTO
   var createdAt: Date
   var rating: Double

   // MARK: - Firestore [String: Any] → DTO
   static func fromFirestore(id: String, data: [String: Any]) -> StoreDTO {

      // Timestamp → Date
      let createdAtDate: Date
      if let timestamp = data["createdAt"] as? Timestamp {
         createdAtDate = timestamp.dateValue()
      } else {
         createdAtDate = Date()
      }

      // Contact nested map parse
      let contactData = data["contact"] as? [String: Any] ?? [:]
      let contact = StoreContactDTO(
         email : contactData["email"] as? String ?? "",
         phone : contactData["phone"] as? String
      )

      // Location nested map parse
      let locationData = data["location"] as? [String: Any] ?? [:]
      let location = StoreLocationDTO(
         area : locationData["area"] as? String ?? "",
         city : locationData["city"] as? String ?? "",
         lat  : locationData["lat"]  as? Double ?? 0.0,
         long  : locationData["long"]  as? Double ?? 0.0
      )

      return StoreDTO(
         id      : id,
         name         : data["name"]         as? String ?? "",
         description  : data["description"]  as? String ?? "",
         category     : data["category"]     as? String ?? "",
         categorySlug : data["categorySlug"] as? String ?? "",
         isActive     : data["isActive"]     as? Bool   ?? true,
         contact      : contact,
         location     : location,
         createdAt    : createdAtDate,
         rating       : data["rating"]         as? Double ?? 0.1
      )
   }

   // MARK: - DTO → Firestore Dictionary
   var dictionary: [String: Any] {
      return [
         "id"      : id,
         "name"         : name,
         "description"  : description,
         "category"     : category,
         "categorySlug" : categorySlug,
         "isActive"     : isActive,
         "contact"      : [                        // ← nested map
            "email" : contact.email,
            "phone" : contact.phone ?? ""
                          ],
         "location"     : [                        // ← nested map
            "area" : location.area,
            "city" : location.city,
            "lat"  : location.lat,
            "lng"  : location.long
                          ],
         "createdAt"    : Timestamp(date: createdAt),
         "rating" : rating
      ]
   }

   // MARK: - DTO → Domain Entity
   func toDomain() -> Store {
      Store(
         id: id,
         name         : name,
         description  : description,
         category     : category,
         categorySlug : categorySlug,
         isActive     : isActive,
         contact      : contact.toDomain(),
         location     : location.toDomain(),
         createdAt    : createdAt,
         rating       : rating
      )
   }

   // MARK: - Domain → DTO
   static func fromDomain(_ store: Store) -> StoreDTO {
      StoreDTO(
         id      : store.id,
         name         : store.name,
         description  : store.description,
         category     : store.category,
         categorySlug : store.categorySlug,
         isActive     : store.isActive,
         contact      : StoreContactDTO.fromDomain(store.contact),
         location     : StoreLocationDTO.fromDomain(store.location),
         createdAt    : store.createdAt,
         rating       : store.rating
      )
   }
}

// MARK: - Nested DTOs

struct StoreContactDTO {
   var email: String
   var phone: String?

   func toDomain() -> StoreContact {
      StoreContact(email: email, phone: phone)
   }

   static func fromDomain(_ c: StoreContact) -> StoreContactDTO {
      StoreContactDTO(email: c.email, phone: c.phone)
   }
}

struct StoreLocationDTO {
   var area: String
   var city: String
   var lat: Double
   var long: Double

   func toDomain() -> StoreLocation {
      StoreLocation(area: area, city: city, lat: lat, long: long)
   }

   static func fromDomain(_ l: StoreLocation) -> StoreLocationDTO {
      StoreLocationDTO(area: l.area, city: l.city, lat: l.lat, long: l.long)
   }
}
