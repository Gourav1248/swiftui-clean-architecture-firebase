//
//  AlertView.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 12/05/26.
//

import SwiftUI

// MARK: - AlertView Modifier

struct AlertViewModifier: ViewModifier {
   @ObservedObject var alertManager: AlertManager

   func body(content: Content) -> some View {
      content
         .alert(
            alertManager.alertTitle,
            isPresented: $alertManager.isPresented
         ) {
            Button("OK", role: .cancel) {
               alertManager.dismiss()
            }
         } message: {
            Text(alertManager.alertMessage)
         }
   }
}
