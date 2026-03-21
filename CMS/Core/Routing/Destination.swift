//
//  AppRoutes.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 19/2/26.
//
import SwiftUI

enum Destination: Equatable {
	case login
	case changeAccount
	case register
	case forgotPassword
	case home
	
	static func == (lhs: Destination, rhs: Destination) -> Bool {
		switch (lhs, rhs) {
			case (.login, .login): return true
			case (.changeAccount, .changeAccount): return true
			case (.register, .register): return true
			case (.forgotPassword, .forgotPassword): return true
			case (.home, .home): return true
		  default: return false
		}
	}
}
