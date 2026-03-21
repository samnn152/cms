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
