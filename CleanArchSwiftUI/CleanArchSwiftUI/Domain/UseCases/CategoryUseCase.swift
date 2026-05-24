//
//  CategoryUseCase.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 24/05/26.
//

import Foundation

final class CategoryUseCase {
   private let categoryRepository: CategoryRepositoryProtocol

   init(categoryRepository: CategoryRepositoryProtocol) {
      self.categoryRepository = categoryRepository
   }

   func fetchAllCategoriesRequest() async throws -> [Category] {
      return try await categoryRepository.fetchAllCategoriesRequest()
   }
}
