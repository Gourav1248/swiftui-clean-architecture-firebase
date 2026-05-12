//
//  AlertManager.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 12/05/26.
//

import SwiftUI

// MARK: - Alert Type

enum AlertType {
   case success(title: String, message: String)
   case error(title: String, message: String)
   case warning(title: String, message: String)
   case info(title: String, message: String)
}

// MARK: - AlertManager

@MainActor
final class AlertManager: ObservableObject {

   @Published var isPresented: Bool = false
   @Published var alertType: AlertType = .info(title: "", message: "")

   // MARK: - Show Methods

   func showSuccess(title: String = "Success", message: String) {
      alertType = .success(title: title, message: message)
      isPresented = true
   }

   func showError(title: String = "Error", message: String) {
      alertType = .error(title: title, message: message)
      isPresented = true
   }

   func showWarning(title: String = "Warning", message: String) {
      alertType = .warning(title: title, message: message)
      isPresented = true
   }

   func showInfo(title: String = "Info", message: String) {
      alertType = .info(title: title, message: message)
      isPresented = true
   }

   func dismiss() {
      isPresented = false
   }
}

extension AlertManager {

   var alertTitle: String {
      switch alertType {
         case .success(let title, _),
               .error(let title, _),
               .warning(let title, _),
               .info(let title, _):
            return title
      }
   }

   var alertMessage: String {
      switch alertType {
         case .success(_, let message),
               .error(_, let message),
               .warning(_, let message),
               .info(_, let message):
            return message
      }
   }
}


extension View {
   func withAlert(_ alertManager: AlertManager) -> some View {
      modifier(AlertViewModifier(alertManager: alertManager))
   }
}
