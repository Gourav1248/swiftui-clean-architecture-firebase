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
   static let primary = Color("Primary") // #4F46E5 Indigo
   static let background = Color("Background")
   static let white = Color.white
   static let surface = Color("Surface")
   static let textPrimary = Color("TextPrimary")
   static let textSecondary = Color("TextSecondary")
   static let border = Color("Border")
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
