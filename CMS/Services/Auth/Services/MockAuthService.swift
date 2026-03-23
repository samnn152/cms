//
//  AuthService.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 19/2/26.
//

import Foundation

final class MockAuthService: AuthServiceProtocol {
	internal var user: User?
	
	var isAuthenticated: Bool {
		user != nil
	}
	
	/// Cấu hình hành vi mock
	enum Mode {
		case success
		case invalidCredentials
		case networkError
	}
	
	private let mode: Mode
	
	init(mode: Mode = .success) {
		self.mode = mode
	}
	
	func login(
		with method: AuthMethod,
		completion: @escaping (Result<User, AuthError>) -> Void
	) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			
			switch self.mode {
				
			case .success:
				let mockUser = User(
					id: "mock_user_001",
					email: "mock@gdgoc.hust",
					displayName: "Mock User",
					avatarURL: nil,
					role: .member,
					isActive: true
				)
				
				self.user = mockUser
				completion(.success(mockUser))
				
			case .invalidCredentials:
				completion(.failure(.invalidCredentials))
				
			case .networkError:
				completion(.failure(.networkError))
			}
		}
	}

	func register(email: String, studentID: String?, password: String, completion: @escaping (Result<User, AuthError>) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			switch self.mode {
			case .success:
				let mockUser = User(
					id: UUID().uuidString,
					email: email,
					studentID: studentID,
					displayName: email.components(separatedBy: "@").first ?? "New User",
					avatarURL: nil,
					role: .guest,
					isActive: true
				)

				self.user = mockUser
				completion(.success(mockUser))
			case .invalidCredentials:
				completion(.failure(.unknown(code: 409, message: "Email nay da duoc su dung.")))
			case .networkError:
				completion(.failure(.networkError))
			}
		}
	}

	func requestPasswordReset(identifier: String, completion: @escaping (Result<String, AuthError>) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			switch self.mode {
			case .success, .invalidCredentials:
				completion(.success("Neu tai khoan ton tai, huong dan dat lai mat khau da duoc gui."))
			case .networkError:
				completion(.failure(.networkError))
			}
		}
	}

	func resetPassword(identifier: String, verificationCode: String, newPassword: String, completion: @escaping (Result<User, AuthError>) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			switch self.mode {
			case .success:
				let mockUser = User(
					id: "mock_user_001",
					email: identifier,
					studentID: nil,
					displayName: identifier,
					avatarURL: nil,
					role: .member,
					isActive: true
				)

				self.user = mockUser
				completion(.success(mockUser))
			case .invalidCredentials:
				completion(.failure(.invalidCredentials))
			case .networkError:
				completion(.failure(.networkError))
			}
		}
	}

  func logout() {
		user = nil
	}

  func currentUser() -> User? {
		user
	}
	
	func getLastLoginUser() -> User? {
		return User(id: "123", email: "Cuong.DM221234@sis.hust.edu.vn", displayName: "Đỗ Mạnh Cường")
	}
}
