//
//  LoginState.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 18/2/26.
//

struct LoginState {
	var status: BaseStatus = .idle
	var avatarURL: String? = nil
	var loggedAccountName: String? = nil
	var username: String = ""
	var password: String = ""
}
