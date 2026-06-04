//
//  StoresUseCaseTest.swift
//  CleanArchSwiftUITests
//
//  Created by Gourav Joshi on 25/05/26.
//

import Foundation
import XCTest
@testable import CleanArchSwiftUI

final class StoresUseCaseTests: XCTestCase {

   private var mockRepository: MockStoreRepository!
   private var sut: StoresUseCase!

   override func setUp() {
      super.setUp()

      mockRepository = MockStoreRepository()
      sut = StoresUseCase(
         repository: mockRepository
      )
   }

   override func tearDown() {
      mockRepository = nil
      sut = nil

      super.tearDown()
   }

   func testFetchAllStoresSuccess() async throws {

      mockRepository.storesToReturn = [
         .pizzaStore,
         .burgerStore
      ]

      let stores = try await sut.fetchAllStoresRequest()

      XCTAssertEqual(stores.count, 2)
   }

   func testFetchAllStoresFailure() async {

      mockRepository.shouldThrowError = true

      do {
         _ = try await sut.fetchAllStoresRequest()
         XCTFail("Expected error")
      } catch {
         XCTAssertEqual(
            error.localizedDescription,
            "Mock Error"
         )
      }
   }
}
