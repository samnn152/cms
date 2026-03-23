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

extension AuthError {
	var fallbackMessage: String {
		switch self {
		case .invalidCredentials:
			return "Thông tin xác thực không hợp lệ."
		case .networkError:
			return "Không thể kết nối tới máy chủ."
		case .cancelled:
			return "Yêu cầu đã bị hủy."
		case let .unknown(_, message):
			return message
		}
	}
}
