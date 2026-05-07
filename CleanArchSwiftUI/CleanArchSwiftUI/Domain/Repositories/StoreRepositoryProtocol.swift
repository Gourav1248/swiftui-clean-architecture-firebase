//
//  StoreRepositoryProtocol.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 06/05/26.
//

import Foundation

protocol StoreRepositoryProtocol {
   func fetchAllStoresRequest() async throws -> [Store]
   func fetchStoreRequest(storeId: String) async throws -> Store
   func fetchStoresByCategoryRequest(slug: String) async throws -> [Store]
}
