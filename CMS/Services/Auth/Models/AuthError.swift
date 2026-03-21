//
//  AuthError.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 19/2/26.
//

enum AuthError: Error {
		case invalidCredentials
		case networkError
		case cancelled
		case unknown(code: Int, message: String)
}
