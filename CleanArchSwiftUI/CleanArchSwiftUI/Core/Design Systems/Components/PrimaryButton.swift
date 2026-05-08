//
//  PrimaryButton.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 08/05/26.
//

import Foundation
import SwiftUI

// MARK: - Reusable: PrimaryButton

struct PrimaryButton: View {
   let title: String
   var icon: String? = nil
   var isLoading: Bool = false
   var isDisabled: Bool = false
   let action: () -> Void

   var body: some View {
      Button(action: action) {
         HStack(spacing: 8) {
            if isLoading {
               ProgressView()
                  .tint(.white)
                  .scaleEffect(0.85)
            } else {
               if let icon = icon {
                  Image(systemName: icon)
                     .font(.system(size: 16, weight: .medium))
               }
               Text(title)
                  .font(.system(size: 16, weight: .semibold))
            }
         }
         .frame(maxWidth: .infinity)
         .frame(height: 52)
         .background(
            RoundedRectangle(cornerRadius: 14)
               .fill(isDisabled ? Color.indigo.opacity(0.4) : Color.indigo)
         )
         .foregroundColor(.white)
      }
      .disabled(isDisabled || isLoading)
      .buttonStyle(ScaleButtonStyle())
   }
}
