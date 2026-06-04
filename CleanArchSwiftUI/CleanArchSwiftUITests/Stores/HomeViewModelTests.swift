//
//  HomeViewModelTests.swift
//  CleanArchSwiftUITests
//
//  Created by Gourav Joshi on 02/06/26.
//

import Foundation
import XCTest
@testable import CleanArchSwiftUI

@MainActor
final class HomeViewModelTests: XCTestCase {

   private var mockRepository: MockStoreRepository!
   private var useCase: StoresUseCase!
   private var sut: HomeViewModel!

   override func setUp() {
      super.setUp()

      mockRepository = MockStoreRepository()

      useCase = StoresUseCase(
         repository: mockRepository
      )

      sut = HomeViewModel(
         storeUseCase: useCase
      )
   }

   override func tearDown() {

      mockRepository = nil
      useCase = nil
      sut = nil

      super.tearDown()
   }

   func testInitialState() {

      XCTAssertTrue(sut.stores.isEmpty)
      XCTAssertEqual(sut.searchText, "")
      XCTAssertNil(sut.errorMessage)
   }

   func testFetchStoresSuccess() async {

      mockRepository.storesToReturn = [
         .pizzaStore,
         .burgerStore
      ]

      await sut.fetchAllStores()

      XCTAssertEqual(sut.stores.count, 2)
      XCTAssertNil(sut.errorMessage)
      XCTAssertEqual(sut.isLoading, false)
   }

   func testFetchStoresFailure() async {

      mockRepository.shouldThrowError = true

      await sut.fetchAllStores()

      XCTAssertNotNil(sut.errorMessage)
      XCTAssertEqual(sut.isLoading, false)
   }

   func testFilteredStoresWhenSearchTextEmpty() {

      sut.stores = [
         .pizzaStore,
         .burgerStore
      ]

      sut.searchText = ""

      XCTAssertEqual(
         sut.filteredStores.count,
         2
      )
   }

   func testFilteredStoresMatchingSearch() {

      sut.stores = [
         .pizzaStore,
         .burgerStore
      ]

      sut.searchText = "pizza"

      XCTAssertEqual(
         sut.filteredStores.count,
         1
      )

      XCTAssertEqual(
         sut.filteredStores.first?.name,
         "Pizza Hut"
      )
   }

   func testFilteredStoresNoMatch() {

      sut.stores = [
         .pizzaStore,
         .burgerStore
      ]

      sut.searchText = "xyz"

      XCTAssertTrue(
         sut.filteredStores.isEmpty
      )
   }

   func testRefreshStoreList() async {

      mockRepository.storesToReturn = [
         .pizzaStore,
         .burgerStore
      ]

      await sut.refreshStoreList()

      XCTAssertEqual(
         sut.stores.count,
         2
      )
   }
}
