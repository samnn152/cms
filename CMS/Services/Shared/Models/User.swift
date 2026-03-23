//
//  AuthUser.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 19/2/26.
//

enum UserRole: String, Codable, Equatable {
	case admin
	case leader
	case member
	case guest

	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let rawValue = try container.decode(String.self)

		switch rawValue {
		case "lead":
			self = .leader
		default:
			self = UserRole(rawValue: rawValue) ?? .guest
		}
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(rawValue)
	}
}

struct User: Codable, Equatable, Identifiable {
	var id: String
	
	var email: String
	var studentID: String?
	
	var displayName: String = ""
	var avatarURL: String?
	
	var role: UserRole = .guest
	var isActive: Bool?
}
