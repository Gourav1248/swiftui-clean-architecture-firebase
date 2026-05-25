//
//  MapView.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 25/05/26.
//

import SwiftUI

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

   let region: MKCoordinateRegion
   let annotations: [StoreAnnotation]

   func makeUIView(context: Context) -> MKMapView {
      let mapView = MKMapView()
      mapView.delegate = context.coordinator
      mapView.showsUserLocation = true
      return mapView
   }

   func updateUIView(_ mapView: MKMapView, context: Context) {
      // ✅ Sirf region change hone par update karo
      if !mapView.region.isEqual(to: region) {
         mapView.setRegion(region, animated: true)
      }

      // ✅ Annotations update karo
      mapView.removeAnnotations(mapView.annotations)
      mapView.addAnnotations(annotations)
   }

   func makeCoordinator() -> Coordinator {
      Coordinator()
   }

   final class Coordinator: NSObject, MKMapViewDelegate {
      func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         guard annotation is StoreAnnotation else { return nil }

         let identifier = "StorePin"
         var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

         if view == nil {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view?.canShowCallout = true
         } else {
            view?.annotation = annotation
         }

         if let markerView = view as? MKMarkerAnnotationView {
            markerView.markerTintColor = UIColor(Color.accentColor)
            markerView.glyphImage = UIImage(systemName: "storefront.fill")
         }

         return view
      }
   }
}

// MARK: - Region comparison helper
extension MKCoordinateRegion {
   func isEqual(to other: MKCoordinateRegion) -> Bool {
      center.latitude == other.center.latitude &&
      center.longitude == other.center.longitude &&
      span.latitudeDelta == other.span.latitudeDelta &&
      span.longitudeDelta == other.span.longitudeDelta
   }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
