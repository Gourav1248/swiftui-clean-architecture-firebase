//
//  SecondaryButton.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 08/05/26.
//

import Foundation
import SwiftUI

struct SecondaryButton: View {
   let title: String
   var icon: String? = nil
   let action: () -> Void

   var body: some View {
      Button(action: action) {
         HStack(spacing: 8) {
            if let icon = icon {
               Image(systemName: icon)
                  .font(.system(size: 15, weight: .medium))
            }
            Text(title)
               .font(.system(size: 15, weight: .medium))
         }
         .frame(maxWidth: .infinity)
         .frame(height: 52)
         .background(
            RoundedRectangle(cornerRadius: 14)
               .fill(Color(.systemGray6))
         )
         .foregroundColor(.primary)
      }
      .buttonStyle(ScaleButtonStyle())
   }
}
