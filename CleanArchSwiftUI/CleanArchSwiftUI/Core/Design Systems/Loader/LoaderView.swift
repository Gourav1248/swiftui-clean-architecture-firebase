//
//  LoaderView.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 14/05/26.
//

import SwiftUI

import SwiftUI

struct LoaderView: View {

   let message: String

   var body: some View {
      Color.black.opacity(0.5)          // ← Translucent background
         .ignoresSafeArea(.all)
         .overlay(
            VStack(spacing: 16) {
               ProgressView()
                  .progressViewStyle(
                     CircularProgressViewStyle(tint: .indigo)
                  )
                  .scaleEffect(1.4)

               Text(message)
                  .font(.system(size: 15, weight: .medium))
                  .foregroundColor(.primary)
            }
               .padding(.horizontal, 32)
               .padding(.vertical, 24)
               .background(
                  RoundedRectangle(cornerRadius: 20)
                     .fill(.ultraThinMaterial)  // ← Translucent card
               )
         )
   }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView(message: "Please wait...")
    }
}
