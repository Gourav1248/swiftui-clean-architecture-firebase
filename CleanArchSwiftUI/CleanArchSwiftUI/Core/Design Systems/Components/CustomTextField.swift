//
//  AuthTextField.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 08/05/26.
//

import SwiftUI

struct CustomTextField: View {
   let label: String
   let placeholder: String
   var icon: String? = nil
   var isSecure: Bool = false
   var keyboardType: UIKeyboardType = .default
   var textContentType: UITextContentType? = nil
   var errorMessage: String? = nil

   @Binding var text: String
   @State private var isRevealed: Bool = false
   @FocusState private var isFocused: Bool

   var body: some View {
      VStack(alignment: .leading, spacing: 6) {
         Text(label)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(.black.opacity(0.7))

         HStack(spacing: 10) {
            if let icon = icon {
               Image(systemName: icon)
                  .foregroundColor(isFocused ? .indigo : .black)
                  .frame(width: 18)
                  .animation(.easeInOut(duration: 0.2), value: isFocused)
            }

            Group {
               if isSecure && !isRevealed {
                  SecureField(placeholder, text: $text)
                     .foregroundColor(.black)
               } else {
                  TextField(placeholder, text: $text)
                     .keyboardType(keyboardType)
                     .foregroundColor(.black)
               }
            }
            .textContentType(textContentType)
            .focused($isFocused)
            .font(.system(size: 16))
            .autocorrectionDisabled()
            .autocapitalization(.none)

            if isSecure {
               Button {
                  isRevealed.toggle()
               } label: {
                  Image(systemName: isRevealed ? "eye.slash" : "eye")
                     .foregroundColor(.black)
                     .frame(width: 20)
               }
            }
         }
         .padding(.horizontal, 14)
         .padding(.vertical, 13)
         .background(
            RoundedRectangle(cornerRadius: 12)
               .fill(Color(.init(gray: 0.75, alpha: 0.45)))
               .overlay(
                  RoundedRectangle(cornerRadius: 12)
                     .strokeBorder(
                        errorMessage != nil
                        ? Color.red.opacity(0.7)
                        : (isFocused ? Color.indigo : Color(.systemGray4)),
                        lineWidth: isFocused ? 1.5 : 1
                     )
               )
         )
         .animation(.easeInOut(duration: 0.2), value: isFocused)

         if let error = errorMessage {
            Label(error, systemImage: "exclamationmark.circle.fill")
               .font(.system(size: 12))
               .foregroundColor(.red.opacity(0.8))
               .transition(.opacity.combined(with: .move(edge: .top)))
         }
      }
      .animation(.easeInOut(duration: 0.2), value: errorMessage)
   }
}

