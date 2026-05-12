//
//  LoginView.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 08/05/26.
//

import SwiftUI

struct LoginView: View {

   @StateObject private var viewModel = LoginViewModel()

   // Navigation callbacks — wired by AppCoordinator
   var onLoginSuccess: ((User?) -> Void)? = nil
   var onSignupTap: (() -> Void)? = nil
   var onForgotPasswordTap: (() -> Void)? = nil
   @EnvironmentObject var router: AppRouter

   @State private var appeared = false

   var body: some View {
      ZStack {
         AppTheme.white
            .ignoresSafeArea()
         

         ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

               // ── Header ──────────────────────────────────
               AuthHeader(
                  title: "Welcome back",
                  subtitle: "Sign in to your account",
                  logoSystemName: "bolt.shield.fill"
               )
               .padding(.top, 56)
               .padding(.bottom, 36)
               .animateEntrance(appeared, delay: 0.00)

               // ── Form ────────────────────────────────────
               VStack(spacing: AppTheme.spacingMD) {

                  CustomTextField(
                     label: "Email address",
                     placeholder: "you@example.com",
                     icon: "envelope",
                     keyboardType: .emailAddress,
                     textContentType: .emailAddress,
                     errorMessage: viewModel.emailError,
                     text: $viewModel.email
                  )

                  CustomTextField(
                     label: "Password",
                     placeholder: "Enter your password",
                     icon: "lock",
                     isSecure: true,
                     textContentType: .password,
                     errorMessage: viewModel.passwordError,
                     text: $viewModel.password
                  )

                  // Forgot password
                  HStack {
                     Spacer()
                     Button("Forgot password?") {
                        onForgotPasswordTap?()
                     }
                     .font(.system(size: 13, weight: .medium))
                     .foregroundColor(.indigo)
                  }
               }
               .padding(.horizontal, AppTheme.spacingLG)
               .animateEntrance(appeared, delay: 0.08)

               // ── Error Banner ────────────────────────────
               if let error = viewModel.generalError {
                  HStack(spacing: 8) {
                     Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 13))
                     Text(error)
                        .font(.system(size: 13))
                  }
                  .foregroundColor(AppTheme.error)
                  .padding(.horizontal, 14)
                  .padding(.vertical, 11)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .background(
                     RoundedRectangle(cornerRadius: AppTheme.radiusMD)
                        .fill(AppTheme.error.opacity(0.07))
                        .overlay(
                           RoundedRectangle(cornerRadius: AppTheme.radiusMD)
                              .strokeBorder(AppTheme.error.opacity(0.25), lineWidth: 1)
                        )
                  )
                  .padding(.horizontal, AppTheme.spacingLG)
                  .padding(.top, 12)
                  .transition(.opacity.combined(with: .move(edge: .top)))
               }

               // ── Primary CTA ─────────────────────────────
               PrimaryButton(
                  title: "Sign In",
                  isLoading: viewModel.isLoading,
                  isDisabled: !viewModel.isFormValid
               ) {
                  Task {
                     await viewModel.login()
                     if viewModel.loginSucceeded {
                        onLoginSuccess?(viewModel.currentUser)
                     }
                  }
               }
               .padding(.horizontal, AppTheme.spacingLG)
               .padding(.top, AppTheme.spacingLG)
               .animateEntrance(appeared, delay: 0.14)

               // ── Social Auth ──────────────────────────────
               VStack(spacing: 12) {
                  AuthDivider(label: "or continue with")

//                  HStack(spacing: 12) {
//                     SocialAuthButton(provider: .apple) {}
//                     SocialAuthButton(provider: .google) {}
//                  }
               }
               .padding(.horizontal, AppTheme.spacingLG)
               .padding(.top, AppTheme.spacingMD)
               .animateEntrance(appeared, delay: 0.20)

               // ── Footer ───────────────────────────────────
               AuthFooterLink(
                  prompt: "Don't have an account?",
                  actionTitle: "Sign up"
               ) {
                  router.push(.signup)
               }
               .padding(.top, AppTheme.spacingXL)
               .padding(.bottom, 48)
               .animateEntrance(appeared, delay: 0.25)
            }
         }
      }
      .animation(.easeOut(duration: 0.4), value: viewModel.generalError)
      .onAppear { appeared = true }
   }
}

// MARK: - Entrance Animation

private extension View {
   func animateEntrance(_ appeared: Bool, delay: Double) -> some View {
      self
         .opacity(appeared ? 1 : 0)
         .offset(y: appeared ? 0 : 18)
         .animation(
            .spring(response: 0.52, dampingFraction: 0.80).delay(delay),
            value: appeared
         )
   }
}
