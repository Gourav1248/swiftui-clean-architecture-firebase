//
//  StoreRepository.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 15/05/26.
//

import FirebaseFirestore

final class StoreRepository: StoreRepositoryProtocol {
   private let db = Firestore.firestore()

   func fetchAllStoresRequest() async throws -> [Store] {
      let obStore = try await db.collection("stores")
                      .whereField("isActive", isEqualTo: true)
                      .order(by: "createdAt", descending: true)
                      .getDocuments()

      return obStore.documents.compactMap { document in
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
            return try decoder.decode(Store.self, from: jsonData)

         } catch {
            print("Decode error: \(error)")
            return nil
         }
      }
   }

}
