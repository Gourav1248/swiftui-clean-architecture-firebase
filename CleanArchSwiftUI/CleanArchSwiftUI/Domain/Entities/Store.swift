//
//  Stores.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 06/05/26.
//
// Domain/Entities/Store.swift

import Foundation

struct Store: Codable, Identifiable {
   var id: String
   let storeId: String
   var name: String
   var description: String
   var category: String
   var categorySlug: String
   var isActive: Bool
   var contact: StoreContact
   var location: StoreLocation
   let createdAt: Date
   var rating: Double
}

struct StoreContact: Codable {
   var email: String
   var phone: String?
}

struct StoreLocation: Codable {
   var area: String
   var city: String
   var lat: Double
   var lng: Double
}
