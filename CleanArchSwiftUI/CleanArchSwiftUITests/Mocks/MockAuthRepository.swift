//
//  MockAuthRepository.swift
//  CleanArchSwiftUITests
//
//  Created by Gourav Joshi on 25/05/26.
//
//  PURPOSE: FirebaseAuthRepository ka in-memory replacement.
//  Firebase ya network touch nahi karta — sirf stubbedResults return karta hai.
//

import Foundation
@testable import CleanArchSwiftUI

final class MockAuthRepository: AuthRepositoryProtocol {

    // MARK: - Stubs (test mein set karo)
    var stubbedSignInResult:  Result<User, Error> = .failure(AuthError.unknown)
    var stubbedSignUpResult:  Result<User, Error> = .failure(AuthError.unknown)
    var stubbedForgotResult:  Error?               = nil   // nil = success
    var stubbedChangePassResult: Error?            = nil
    var stubbedCurrentUser:   User?                = nil
    var stubbedLogoutError:   Error?               = nil

    // MARK: - Call Trackers (assert karne ke liye)
    private(set) var signInCallCount:      Int = 0
    private(set) var signUpCallCount:      Int = 0
    private(set) var forgotPassCallCount:  Int = 0
    private(set) var changePassCallCount:  Int = 0
    private(set) var logoutCallCount:      Int = 0
    private(set) var getCurrentUserCount:  Int = 0

    // Captured arguments
    private(set) var capturedSignInEmail:    String?
    private(set) var capturedSignInPassword: String?
    private(set) var capturedSignUpRequest:  SignUpRequestModel?
    private(set) var capturedForgotEmail:    String?

    // MARK: - Protocol Implementations

    func signInRequest(email: String, password: String) async throws -> User {
        signInCallCount += 1
        capturedSignInEmail    = email
        capturedSignInPassword = password

        switch stubbedSignInResult {
        case .success(let user): return user
        case .failure(let error): throw error
        }
    }

    func signUpRequest(_ request: SignUpRequestModel) async throws -> User {
        signUpCallCount += 1
        capturedSignUpRequest = request

        switch stubbedSignUpResult {
        case .success(let user): return user
        case .failure(let error): throw error
        }
    }

    func forgotPasswordRequest(email: String) async throws {
        forgotPassCallCount += 1
        capturedForgotEmail = email
        if let error = stubbedForgotResult { throw error }
    }

    func changePasswordRequest(currentPassword: String, newPassword: String) async throws {
        changePassCallCount += 1
        if let error = stubbedChangePassResult { throw error }
    }

    func logoutRequest() throws {
        logoutCallCount += 1
        if let error = stubbedLogoutError { throw error }
    }

    func getCurrentUserRequest() -> User? {
        getCurrentUserCount += 1
        return stubbedCurrentUser
    }

    // MARK: - Reset Helper (setUp mein use karo)
    func reset() {
        stubbedSignInResult   = .failure(AuthError.unknown)
        stubbedSignUpResult   = .failure(AuthError.unknown)
        stubbedForgotResult   = nil
        stubbedChangePassResult = nil
        stubbedCurrentUser    = nil
        stubbedLogoutError    = nil
        signInCallCount       = 0
        signUpCallCount       = 0
        forgotPassCallCount   = 0
        changePassCallCount   = 0
        logoutCallCount       = 0
        getCurrentUserCount   = 0
        capturedSignInEmail    = nil
        capturedSignInPassword = nil
        capturedSignUpRequest  = nil
        capturedForgotEmail    = nil
    }
}
