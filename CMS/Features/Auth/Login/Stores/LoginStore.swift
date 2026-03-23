//
//  LoginStore.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 18/2/26.
//
import Foundation
internal import Combine

final class LoginStore : ObservableObject {
	private let authService: AuthServiceProtocol
	private let savedUsersService: SavedUsersServiceProtocol
	
	@Published var state: LoginState = LoginState()
	
	var onLoginSuccess: (() -> Void)?
	
	init(authService: AuthServiceProtocol, savedUsersService: SavedUsersServiceProtocol) {
		self.authService = authService
		self.savedUsersService = savedUsersService
		if let lastUser: User = savedUsersService.lastLoginUser {
			changeAccount(user: lastUser)
		}
	}
	
	func login() {
		let identifier = state.username.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !identifier.isEmpty else {
			state.status = .error(code: 1, message: "Vui lòng nhập email hoặc MSSV.")
			return
		}

		guard !state.password.isEmpty else {
			state.status = .error(code: 1, message: "Vui lòng nhập mật khẩu.")
			return
		}

		state.status = .loading
		
		authService.login(with: .usernameAndPassword(username: identifier, password: state.password)) { [weak self] result in
			switch result {
			case let .success(user):
				self?.savedUsersService.save(user: user)
				self?.changeAccount(user: user)
				self?.state.status = .success
				self?.onLoginSuccess?()
			case let .failure(error):
				self?.state.status = .error(code: 1, message: self?.errorMessage(for: error) ?? error.fallbackMessage)
			}
		}
	}
	
	func changeAccount(user: User) {
		state.loggedAccountName = user.displayName
		state.username = user.email
		state.avatarURL = user.avatarURL
	}

	private func errorMessage(for error: AuthError) -> String {
		switch error {
		case .invalidCredentials:
			return "Thông tin đăng nhập không đúng."
		default:
			return error.fallbackMessage
		}
	}
}
