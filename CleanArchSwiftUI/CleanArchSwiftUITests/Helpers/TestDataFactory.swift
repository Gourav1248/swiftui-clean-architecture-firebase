//
//  TestDataFactory.swift
//  CleanArchSwiftUITests
//
//  Created by Gourav Joshi on 25/05/26.
//
//  UPDATED: Auth test data added — User factory + common test constants
//

import Foundation
@testable import CleanArchSwiftUI

struct TestDataFactory {

    // MARK: - Auth Constants
    static let validEmail     = "gourav@test.com"
    static let validPassword  = "Pass@1234"
    static let shortPassword  = "123"          // < 6 chars
    static let invalidEmail   = "not-an-email"
    static let wrongPassword  = "WrongPass99"

    // MARK: - User Factory
    static func makeUser(
        uid       : String = "mock_uid_001",
        email     : String = validEmail,
        firstName : String = "Gourav",
        lastName  : String = "Joshi"
    ) -> User {
        User(
            uid       : uid,
            firstName : firstName,
            lastName  : lastName,
            email     : email,
            phone     : "9999999999",
            address   : "Test Address",
            city      : "Indore",
            gender    : "Male",
            isActive  : true,
            createdAt : Date()
        )
    }

    // MARK: - Store Factory (existing)
    static func makeStore(id: String, name: String, isActive: Bool) -> Store {
        Store(
            id           : id,
            name         : name,
            description  : "Test Description",
            category     : "Food",
            categorySlug : "food",
            isActive     : isActive,
            contact      : StoreContact(email: "store@test.com", phone: "9999999999"),
            location     : StoreLocation(area: "Vijay Nagar", city: "Indore", lat: 22.75, long: 75.89),
            createdAt    : Date(),
            rating       : 4.5
        )
    }
}
