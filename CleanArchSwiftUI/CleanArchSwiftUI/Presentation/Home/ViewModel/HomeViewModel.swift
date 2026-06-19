//
//  HomeViewModel.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 15/05/26.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {

   // @Published means: "when this changes, refresh the UI"
   @Published var stores: [Store] = []
   @Published var searchText: String = ""
   @Published var errorMessage: String? = nil
   @Published var isLoading: Bool? = false

   private let storeUseCase: StoresUseCase

   init(storeUseCase: StoresUseCase = StoresUseCase(repository: StoreRepository())) {
      self.storeUseCase = storeUseCase
   }

   // Filtered stores based on search input
   var filteredStores: [Store] {
      if searchText.isEmpty {
         return stores
      }
      return stores.filter {
         $0.name.lowercased().contains(searchText.lowercased())
      }
   }

   func fetchAllStores() async {
      print("HomeViewModel fetchAllStores")
      isLoading = true
      do {
         stores = try await storeUseCase.fetchAllStoresRequest()
      } catch {
         errorMessage = error.localizedDescription
      }

      isLoading = false
   }

   //For pull to refresh
   func refreshStoreList() async {
      await fetchAllStores()
   }
}
