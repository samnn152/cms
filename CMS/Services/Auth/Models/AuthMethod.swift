//
//  AuthMethod.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 19/2/26.
//

enum AuthMethod {
	case usernameAndPassword(username: String, password: String)
	case oAuth2(provider: String, token: String)
	case refreshToken
}
