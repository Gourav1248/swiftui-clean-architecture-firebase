//
//  MockStoresUseCase.swift
//  CleanArchSwiftUITests
//
//  Created by Gourav Joshi on 25/05/26.
//

import Foundation
@testable import CleanArchSwiftUI

extension Store {

   static let pizzaStore = Store(
      id: "1",
      name: "Pizza Hut",
      description: "Pizza Store",
      category: "Food",
      categorySlug: "food",
      isActive: true,
      contact: StoreContact(
         email: "pizza@test.com",
         phone: "9999999999"
      ),
      location: StoreLocation(
         area: "Vijay Nagar",
         city: "Indore",
         lat: 22.7196,
         long: 75.8577
      ),
      createdAt: Date(),
      rating: 4.5
   )

   static let burgerStore = Store(
      id: "2",
      name: "Burger King",
      description: "Burger Store",
      category: "Food",
      categorySlug: "food",
      isActive: true,
      contact: StoreContact(
         email: "burger@test.com",
         phone: "8888888888"
      ),
      location: StoreLocation(
         area: "Palasia",
         city: "Indore",
         lat: 22.72,
         long: 75.86
      ),
      createdAt: Date(),
      rating: 4.2
   )
}
