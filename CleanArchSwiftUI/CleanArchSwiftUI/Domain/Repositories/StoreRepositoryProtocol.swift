//
//  StoreRepositoryProtocol.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 06/05/26.
//

import Foundation

protocol StoreRepositoryProtocol {
   func fetchAllStoresRequest() async throws -> [Store]
}
