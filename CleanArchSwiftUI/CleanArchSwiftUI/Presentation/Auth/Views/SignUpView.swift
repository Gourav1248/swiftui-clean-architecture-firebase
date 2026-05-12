//
//  SignUpView.swift
//  CleanArchSwiftUI
//
//  Created by Gourav Joshi on 10/05/26.
//

import SwiftUI

import SwiftUI

// MARK: - SignupView
// Location: Presentation/Auth/Views/SignupView.swift

struct SignUpView: View {

   @StateObject private var viewModel = SignUpViewModel()
   @State private var appeared = false

   var onSignupSuccess: ((User?) -> Void)? = nil
   var onLoginTap: (() -> Void)? = nil

   var body: some View {
      ZStack {
         AppTheme.white
            .ignoresSafeArea()

         ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

               // ── Header ──────────────────────────────────
               AuthHeader(
                  title: "Create account",
                  subtitle: "Fill in your details to get started",
                  logoSystemName: "person.badge.plus"
               )
               .padding(.top, 48)
               .padding(.bottom, 28)
               .animateEntrance(appeared, delay: 0.00)

               // ── Form ────────────────────────────────────
               VStack(spacing: AppTheme.spacingMD) {

                  // MARK: Personal Info
                  Group {
                     SignUpSectionHeader(title: "Personal Info", icon: "person")

                     HStack(spacing: 10) {
                        CustomTextField(
                           label: "First Name",
                           placeholder: "Gourav",
                           icon: "person",
                           textContentType: .givenName,
                           errorMessage: viewModel.firstNameError,
                           text: $viewModel.firstName
                        )
                        CustomTextField(
                           label: "Last Name",
                           placeholder: "Joshi",
                           textContentType: .familyName,
                           errorMessage: viewModel.lastNameError,
                           text: $viewModel.lastName
                        )
                     }
                  }


                  GenderPickerRow(selected: $viewModel.selectedGender)

                  // MARK: Contact

                  Group {
                     SignUpSectionHeader(title: "Contact", icon: "envelope")
                        .padding(.top, 4)

                     CustomTextField(
                        label: "Email Address",
                        placeholder: "you@example.com",
                        icon: "envelope",
                        keyboardType: .emailAddress,
                        textContentType: .emailAddress,
                        errorMessage: viewModel.emailError,
                        text: $viewModel.email
                     )

                     CustomTextField(
                        label: "Phone Number",
                        placeholder: "9926XXXXXX",
                        icon: "phone",
                        keyboardType: .phonePad,
                        textContentType: .telephoneNumber,
                        errorMessage: viewModel.phoneError,
                        text: $viewModel.phone
                     )

                  }

                  // MARK: Address
                  SignUpSectionHeader(title: "Address", icon: "mappin.circle")
                     .padding(.top, 4)

                  CustomTextField(
                     label: "Address",
                     placeholder: "45-B, Indira Gandhi Nagar",
                     icon: "house",
                     textContentType: .streetAddressLine1,
                     errorMessage: viewModel.addressError,
                     text: $viewModel.address
                  )

                  CustomTextField(
                     label: "City",
                     placeholder: "Indore",
                     icon: "building.2",
                     textContentType: .addressCity,
                     errorMessage: viewModel.cityError,
                     text: $viewModel.city
                  )

                  // MARK: Security
                  SignUpSectionHeader(title: "Security", icon: "lock")
                     .padding(.top, 4)

                  CustomTextField(
                     label: "Password",
                     placeholder: "Min. 6 characters",
                     icon: "lock",
                     isSecure: true,
                     textContentType: .newPassword,
                     errorMessage: viewModel.passwordError,
                     text: $viewModel.password
                  )

                  CustomTextField(
                     label: "Confirm Password",
                     placeholder: "Re-enter password",
                     icon: "lock.rotation",
                     isSecure: true,
                     textContentType: .newPassword,
                     errorMessage: viewModel.confirmPasswordError,
                     text: $viewModel.confirmPassword 
                  )

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

               // ── CTA ─────────────────────────────────────
               PrimaryButton(
                  title: "Create Account",
                  icon: "arrow.right",
                  isLoading: viewModel.isLoading,
                  isDisabled: !viewModel.isFormValid
               ) {
                  Task {
                     await viewModel.signup()
                     if viewModel.signupSucceeded {
                        onSignupSuccess?(viewModel.currentUser)
                     }
                  }
               }
               .padding(.horizontal, AppTheme.spacingLG)
               .padding(.top, AppTheme.spacingLG)
               .animateEntrance(appeared, delay: 0.14)

               // ── Footer ───────────────────────────────────
               AuthFooterLink(
                  prompt: "Already have an account?",
                  actionTitle: "Sign in"
               ) {
                  onLoginTap?()
               }
               .padding(.top, AppTheme.spacingXL)
               .padding(.bottom, 48)
               .animateEntrance(appeared, delay: 0.18)
            }
         }
      }
      .animation(.easeOut(duration: 0.4), value: viewModel.generalError)
      .onAppear { appeared = true }
   }
}

// MARK: - SignupSectionHeader

private struct SignUpSectionHeader: View {
   let title: String
   let icon: String

   var body: some View {
      HStack(spacing: 6) {
         Image(systemName: icon)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.indigo)
         Text(title.uppercased())
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(.indigo)
            .tracking(0.8)
         Rectangle()
            .fill(Color.indigo.opacity(0.2))
            .frame(height: 1)
      }
   }
}

// MARK: - GenderPickerRow

struct GenderPickerRow: View {
   @Binding var selected: Gender

   var body: some View {
      VStack(alignment: .leading, spacing: 6) {
         Text("Gender")
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(.black.opacity(0.7))

         HStack(spacing: 10) {
            Image(systemName: "person.2")
               .foregroundColor(.black)
               .frame(width: 18)

            Picker("Gender", selection: $selected) {
               ForEach(Gender.allCases, id: \.self) { gender in
                  Text(gender.displayName).tag(gender)
               }
            }
            .pickerStyle(.menu)
            .tint(.indigo)
            .frame(maxWidth: .infinity, alignment: .leading)
         }
         .padding(.horizontal, 14)
         .frame(height: 50)
         .background(
            RoundedRectangle(cornerRadius: AppTheme.radiusMD)
               .fill(Color(.init(gray: 0.75, alpha: 0.45)))
               .overlay(
                  RoundedRectangle(cornerRadius: AppTheme.radiusMD)
                     .strokeBorder(Color(.black), lineWidth: 1)
               )
         )
      }
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

// MARK: - Preview

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
