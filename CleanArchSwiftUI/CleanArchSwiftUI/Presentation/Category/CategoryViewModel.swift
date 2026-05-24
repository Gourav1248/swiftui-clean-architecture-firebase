//
//  CategoryViewModel.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 18/05/26.
//

import Foundation

@MainActor
final class CategoryViewModel: ObservableObject {

   @Published var errorMessage: String? = nil
   @Published var categories:[Category] = []

   private let useCase: CategoryUseCase


   init(useCase: CategoryUseCase = CategoryUseCase(categoryRepository: CategoryRepository())) {
      self.useCase = useCase
   }

   func loadCategories() async {
      do {
        categories = try await useCase.fetchAllCategoriesRequest()
      } catch {
         errorMessage = error.localizedDescription
      }
   }
}
