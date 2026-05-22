//
//  Category.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 06/05/26.
//
// Domain/Entities/Category.swift

import Foundation


struct Category: Codable, Identifiable {
   let id: String
   var name: String
   var slug: String
   var imageUrl: String
   var isActive: Bool
}
