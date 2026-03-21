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
		state.status = .loading
		
		authService.login(with: .usernameAndPassword(username: state.username, password: state.password)) {[weak self] result in
			DispatchQueue.main.async {
				switch result {
				case .success:
					self?.state.status = .success
					self?.onLoginSuccess?()
				case .failure:
					self?.state.status = .error(code: 1, message: "Login failed")
				}
			}
		}
	}
	
	func changeAccount(user: User) {
		state.loggedAccountName = user.displayName
		state.username = user.email
		state.avatarURL = user.avatarURL
	}
}
