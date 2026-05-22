//
//  CategoryRepositoryProtocol.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 06/05/26.
//

import Foundation

protocol CategoryRepositoryProtocol {
   func fetchAllCategoriesRequest() async throws -> [Category]
}
