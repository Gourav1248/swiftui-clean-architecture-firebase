//
//  StoreAnnotation.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 25/05/26.
//

import Foundation
import MapKit

final class StoreAnnotation: NSObject, MKAnnotation, Identifiable {
   let id: String
   let title: String?
   let subtitle: String?
   let coordinate: CLLocationCoordinate2D

   init(store: Store) {
      self.id = store.id
      self.title = store.name
      self.subtitle = "\(store.location.area) - \(store.location.city)"
      self.coordinate = CLLocationCoordinate2D(
         latitude: store.location.lat,
         longitude: store.location.long
      )
   }

   var isValidCoordinate: Bool {
      coordinate.latitude  >= -90  && coordinate.latitude  <= 90 &&
      coordinate.longitude >= -180 && coordinate.longitude <= 180
   }
}
