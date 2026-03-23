//
//  LoginServiceProtocol.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 19/2/26.
//

protocol SavedUsersServiceProtocol {
	var lastLoginUser: User? { get }
	
	var savedUsers: [User] { get }
	
	func save(user: User)
	
	func delete(user: User)
	
	func reload()
}
