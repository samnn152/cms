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

extension BaseStatus {
	var isLoading: Bool {
		if case .loading = self {
			return true
		}

		return false
	}

	var errorMessage: String? {
		if case let .error(_, message) = self {
			return message
		}

		return nil
	}
}
