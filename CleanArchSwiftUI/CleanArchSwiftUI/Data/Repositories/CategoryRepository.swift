//
//  CategoryRepository.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 18/05/26.
//

import Foundation

// Data/Repositories/CategoryRepository.swift

import Foundation
import Combine
import FirebaseFirestore

final class CategoryRepository: CategoryRepositoryProtocol {

   private let db = Firestore.firestore()

   func fetchAllCategoriesRequest() async throws -> [Category] {
      let obCategory = try await db.collection("categories")
                       .getDocuments()


      return obCategory.documents.compactMap { document in
         do {
            // Step 1: Document data lo + documentID inject karo
            var data = document.data()
            data["id"] = document.documentID
            // Step 2: Timestamp → Date convert karo manually sirf yahan
            if let timestamp = data["createdAt"] as? Timestamp {
               data["createdAt"] = timestamp.dateValue().timeIntervalSince1970
            }

            // Step 3: JSONSerialization → Data → Decode
            let jsonData = try JSONSerialization.data(withJSONObject: data)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            return try decoder.decode(Category.self, from: jsonData)

         } catch {
            print("Decode error: \(error)")
            return nil
         }
      }
   }
}
