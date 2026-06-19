//
//  StoreCardView.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 15/05/26.
//

import SwiftUI

struct StoreCardView: View {
   let store: Store

   var body: some View {
      HStack(spacing: 14) {


         // Store Info
         VStack(alignment: .leading, spacing: 4) {
            Text(store.name)
               .font(.system(size: 16, weight: .semibold))
               .foregroundColor(AppTheme.primary)

            Text(store.category)
               .font(.system(size: 13))
               .foregroundColor(AppTheme.secondary)

            HStack(spacing: 4) {
               Image(systemName: "star.fill")
                  .font(.system(size: 11))
                  .foregroundColor(.orange)
               Text("\(store.rating, specifier: "%.1f")")
                  .font(.system(size: 13, weight: .medium))
                  .foregroundColor(AppTheme.darkSurface)
            }
         }

         Spacer()

         // Open/Closed Badge
         Text(store.isActive ? "Open" : "Closed")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(store.isActive ? .green : .red)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
               Capsule()
                  .fill(store.isActive ? Color.green.opacity(0.12) : Color.red.opacity(0.12))
            )
      }
      .padding(16)
      .background(AppTheme.surface)
      .cornerRadius(16)
      .shadow(color: .black.opacity(0.10), radius: 6, x: 0, y: 2)
      .overlay(
         RoundedRectangle(cornerRadius: 10.0)
            .stroke(AppTheme.border, lineWidth: 1.5)
      )
   }
}
