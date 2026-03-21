//
//  BaseStatus.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 18/2/26.
//

enum BaseStatus: Equatable {
	case idle
	case loading
	case success
	case error(code: Int, message: String)
}
