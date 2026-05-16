//
//  AppTheme.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 08/05/26.
//

import Foundation
import SwiftUI

struct AppTheme {
   // Colors

   //Core
   static let primary       = Color(hex: "#3D5AFE")  // AppPrimaryBlue
   static let secondary     = Color(hex: "#7C4DFF")  // AppVoilet
   static let accent        = Color(hex: "#00E5A0")  // AppMint

   // Backgrounds
   static let background    = Color(hex: "#FFFFFF")  // AppWhite
   static let surface       = Color(hex: "#F8F8FF")  // AppPearlWhite
   static let darkSurface   = Color(hex: "#2C2C3E")  // AppDarkGrey

   // Text
   static let textPrimary   = Color(hex: "#1A1A2E")  // AppText
   static let textSecondary = Color(hex: "#9E9E9E")  // AppLightGray

   // Semantic
   static let warning       = Color(hex: "#FFD600")  // AppYellow
   static let border        = Color(hex: "#E0E0EF")  // AppViewBorder
   static let lavender      = Color(hex: "#EDE7FF")  // AppLavender

   // Base
   static let white         = Color(hex: "#FFFFFF")
   static let black         = Color(hex: "#0A0A0A")

   static let error = Color.red.opacity(0.85)
   static let lightGray = Color.gray.opacity(0.45)

   // Typography
   static let fontDisplay = "Georgia" // Refined serif for headings
   static let fontBody = "SF Pro Text"

   // Spacing
   static let spacingSM: CGFloat = 8
   static let spacingMD: CGFloat = 16
   static let spacingLG: CGFloat = 24
   static let spacingXL: CGFloat = 32

   // Corner Radius
   static let radiusMD: CGFloat = 12
   static let radiusLG: CGFloat = 16
}

// Color+Hex.swift
extension Color {
   init(hex: String) {
      let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
      var int: UInt64 = 0
      Scanner(string: hex).scanHexInt64(&int)
      let a, r, g, b: UInt64
      switch hex.count {
         case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
         case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
         default:
            (a, r, g, b) = (255, 0, 0, 0)
      }
      self.init(.sRGB,
                red: Double(r) / 255,
                green: Double(g) / 255,
                blue: Double(b) / 255,
                opacity: Double(a) / 255)
   }
}
