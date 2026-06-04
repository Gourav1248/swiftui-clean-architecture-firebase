//
//  MockStoreRepository.swift
//  CleanArchSwiftUITests
//
//  Created by Gourav Joshi on 25/05/26.
//

import Foundation
@testable import CleanArchSwiftUI

final class MockStoreRepository: StoreRepositoryProtocol {

   var shouldThrowError = false

   var storesToReturn: [Store] = []

   func fetchAllStoresRequest() async throws -> [Store] {

      if shouldThrowError {
         throw NSError(
            domain: "UnitTest",
            code: 500,
            userInfo: [
               NSLocalizedDescriptionKey: "Mock Error"
            ]
         )
      }

      return storesToReturn
   }
}
