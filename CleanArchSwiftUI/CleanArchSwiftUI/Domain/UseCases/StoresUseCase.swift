//
//  StoresUseCase.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 15/05/26.
//

import Foundation

final class StoresUseCase {

   private let storeRepository: StoreRepositoryProtocol

   init(repository: StoreRepositoryProtocol) {
      self.storeRepository = repository
   }

   func fetchAllStoresRequest() async throws -> [Store] {
      return try await storeRepository.fetchAllStoresRequest()
   }
}
