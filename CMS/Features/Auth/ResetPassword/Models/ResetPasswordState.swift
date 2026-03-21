//
//  LoginState.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 18/2/26.
//

enum ResetPasswordStep: Int, CaseIterable {
	case submitUsername
	case submitNewPassword
}

struct ResetPasswordState {
	var status: BaseStatus = .idle
	var step: ResetPasswordStep = .submitUsername
	var avatarURL: String? = nil
	var loggedAccountName: String? = nil
	var username: String = ""
	var verificationCode: String = ""
	var password: String = ""
	var passwordConfirmation: String = ""
}
