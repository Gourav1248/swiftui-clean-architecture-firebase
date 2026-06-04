//
//  StoreMapViewModel.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 25/05/26.
//

import Foundation

import Foundation
import MapKit
import Combine

@MainActor
final class StoreMapViewModel: ObservableObject {

   // MARK: Published state
   @Published var annotations: [StoreAnnotation] = []

   @Published var isLoading = false
   @Published var errorMessage: String?
   @Published private(set) var calculatedRegion: MKCoordinateRegion?

   // MARK: Dependencies (injected — reuse existing UseCase)
   private let storesUseCase: StoresUseCase

   init(storesUseCase: StoresUseCase = StoresUseCase(repository: StoreRepository())) {

      self.storesUseCase = storesUseCase

      print("🔥 StoreMapViewModel Created \(ObjectIdentifier(self))")
   }

   // MARK: Intent
   func loadStores() async {
      isLoading = true
      errorMessage = nil
      do {
         let stores = try await storesUseCase.fetchAllStoresRequest()
         let allAnnotations = stores.map { StoreAnnotation(store: $0) }

         // ✅ Dono changes alag steps mein, async ke saath
       //  await MainActor.run {
            annotations = allAnnotations.filter { $0.isValidCoordinate }
         //}

         //await MainActor.run {
         calculatedRegion = fitRegion(to: annotations)
         //}

      } catch {
         await MainActor.run {
            errorMessage = error.localizedDescription
         }
      }
      await MainActor.run {
         isLoading = false
      }
   }

   // MARK: Private
   private func fitRegion(to annotations: [StoreAnnotation]) -> MKCoordinateRegion? {
      guard !annotations.isEmpty else { return nil }

      let lats = annotations.map(\.coordinate.latitude)
      let lons = annotations.map(\.coordinate.longitude)

      let center = CLLocationCoordinate2D(
         latitude: (lats.min()! + lats.max()!) / 2,
         longitude: (lons.min()! + lons.max()!) / 2
      )
      let span = MKCoordinateSpan(
         latitudeDelta: min((lats.max()! - lats.min()!) * 1.4 + 0.5, 60),
         longitudeDelta: min((lons.max()! - lons.min()!) * 1.4 + 0.5, 60)
      )
      return MKCoordinateRegion(center: center, span: span)
   }

   deinit {
      print("💀 StoreMapViewModel Destroyed \(ObjectIdentifier(self))")
   }
}
