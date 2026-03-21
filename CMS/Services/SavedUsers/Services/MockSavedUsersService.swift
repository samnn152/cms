//
//  AuthService.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 19/2/26.
//

import Foundation

final class MockSavedUsersService: SavedUsersServiceProtocol {
	private var users: [User] = [
		User(id: "1", email: "hello@sis.com", studentID: "20226677", displayName: "Hello"),
		User(id: "2", email: "hello@sis.com", studentID: "20226677", displayName: "Hello2"),
		User(id: "3", email: "hello@sis.com", studentID: "20226677", displayName: "Hello3"),
		User(id: "4", email: "hello@sis.com", studentID: "20226677", displayName: "Hello4"),
	]
	
	var lastLoginUser: User? {
		users.last
	}
	
	var savedUsers: [User] {
		users
	}
	
	func save(user: User) {
		if !users.contains(where: {saved in saved.id == user.id}) {
			users.append(user)
		}
	}
}
