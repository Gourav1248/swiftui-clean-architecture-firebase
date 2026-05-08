//
//  ButtonStyles.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 08/05/26.
//

import Foundation
import SwiftUI

// MARK: - Button Style

struct ScaleButtonStyle: ButtonStyle {
   func makeBody(configuration: Configuration) -> some View {
      configuration.label
         .scaleEffect(configuration.isPressed ? 0.97 : 1)
         .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
   }
}
