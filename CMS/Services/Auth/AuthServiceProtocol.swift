//
//  LoginServiceProtocol.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 19/2/26.
//

protocol AuthServiceProtocol {
	var isAuthenticated: Bool { get }
	
	func login(with method: AuthMethod, completion: @escaping (Result<User, AuthError>) -> Void)
	
	func logout()
	
	var user: User? { get }
}
