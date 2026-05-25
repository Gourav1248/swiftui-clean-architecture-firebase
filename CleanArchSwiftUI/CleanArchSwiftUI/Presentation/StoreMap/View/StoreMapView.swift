//
//  StoreMapView.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 25/05/26.
//

import SwiftUI

import SwiftUI
import MapKit

struct StoreMapView: View {

   @StateObject private var viewModel: StoreMapViewModel

   @State private var region = MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: 22.5678, longitude: 75.4321),
      span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
   )

   init(viewModel: StoreMapViewModel) {
      _viewModel = StateObject(wrappedValue: viewModel)
   }

   var body: some View {
      ZStack {
         MapView(
            region: viewModel.calculatedRegion ?? MKCoordinateRegion(
               center: CLLocationCoordinate2D(latitude: 22.5678, longitude: 75.4321),
               span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            ),
            annotations: viewModel.annotations
         )
          .ignoresSafeArea()

         // Loading overlay
         if viewModel.isLoading {
            ProgressView()
               .padding(12)
               .background(.ultraThinMaterial)
               .clipShape(RoundedRectangle(cornerRadius: 10))
         }

         // Error banner
         if let error = viewModel.errorMessage {
            VStack {
               Text(error)
                  .font(.caption)
                  .padding(10)
                  .background(Color.red.opacity(0.85))
                  .foregroundStyle(.white)
                  .clipShape(RoundedRectangle(cornerRadius: 8))
               Spacer()
            }
            .padding(.top, 12)
         }
      }
      .task { await viewModel.loadStores() }
      .navigationTitle("Stores")
      .navigationBarTitleDisplayMode(.inline)

      // Jab annotations load hon, calculatedRegion se local region update karo
      .onChange(of: viewModel.calculatedRegion?.center.latitude) { _ in
         if let newRegion = viewModel.calculatedRegion {
            region = newRegion
         }
      }
   }
}

// MARK: - Custom pin
private struct StorePinView: View {
   let title: String

   @State private var showCallout = false

   var body: some View {
      VStack(spacing: 2) {
         if showCallout {
            Text(title)
               .font(.caption2.bold())
               .padding(.horizontal, 6)
               .padding(.vertical, 3)
               .background(.thinMaterial)
               .clipShape(RoundedRectangle(cornerRadius: 6))
               .transition(.scale.combined(with: .opacity))

         }
         Image(systemName: "storefront.fill")
            .font(.title2)
            .foregroundStyle(.white)
            .padding(8)
            .background(Color.accentColor)
            .clipShape(Circle())
            .shadow(radius: 3)
            .onTapGesture {
               withAnimation(.spring(response: 0.3)) {
                  showCallout.toggle()
               }
            }
      }
   }
}

//struct StoreMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoreMapView()
//    }
//}
