//
//  LoginServiceProtocol.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 19/2/26.
//

protocol AuthServiceProtocol {
	var isAuthenticated: Bool { get }
	
	func login(with method: AuthMethod, completion: @escaping (Result<User, AuthError>) -> Void)

	func register(email: String, studentID: String?, password: String, completion: @escaping (Result<User, AuthError>) -> Void)

	func requestPasswordReset(identifier: String, completion: @escaping (Result<String, AuthError>) -> Void)

	func resetPassword(identifier: String, verificationCode: String, newPassword: String, completion: @escaping (Result<User, AuthError>) -> Void)
	
	func logout()
	
	var user: User? { get }
}
