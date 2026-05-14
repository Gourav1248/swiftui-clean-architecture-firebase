//
//  ViewDivider.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 08/05/26.
//

import SwiftUI

struct AuthDivider: View {
   var label: String = "or"

   var body: some View {
      HStack(spacing: 12) {
         Rectangle()
            .fill(Color(.systemGray4))
            .frame(height: 1)
         Text(label)
            .font(.system(size: 13))
            .foregroundColor(.secondary)
         Rectangle()
            .fill(Color(.systemGray4))
            .frame(height: 1)
      }
   }
}

struct AuthHeader: View {
   let title: String
   let subtitle: String
   var logoSystemName: String = "lock.square.fill"

   var body: some View {
      VStack(spacing: 12) {
         ZStack {
            RoundedRectangle(cornerRadius: 20)
               .fill(Color.indigo.opacity(0.12))
               .frame(width: 64, height: 64)
            Image(systemName: logoSystemName)
               .font(.system(size: 30))
               .foregroundStyle(Color.indigo)
         }

         VStack(spacing: 4) {
            Text(title)
               .font(.system(size: 26, weight: .bold, design: .serif))
               .foregroundColor(AppTheme.black)

            Text(subtitle)
               .font(.system(size: 15))
               .foregroundColor(AppTheme.black)
               .multilineTextAlignment(.center)
         }
      }
   }
}

// MARK: - Reusable: AuthFooterLink

struct AuthFooterLink: View {
   let prompt: String
   let actionTitle: String
   let action: () -> Void

   var body: some View {
      HStack(spacing: 4) {
         Text(prompt)
            .font(.system(size: 14))
            .foregroundColor(.black)
         Button(action: action) {
            Text(actionTitle)
               .font(.system(size: 14, weight: .semibold))
               .foregroundColor(.indigo)
         }
      }
   }
}
