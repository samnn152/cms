//
//  AuthUser.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 19/2/26.
//

enum UserRole: String, Equatable {
	case admin
	case lead
	case member
	case guest
}

struct User: Equatable, Identifiable {
	var id: String
	
	var email: String
	var studentID: String?
	
	var displayName: String = ""
	var avatarURL: String?
	
	var role: UserRole = .guest
	var isActive: Bool?
}
