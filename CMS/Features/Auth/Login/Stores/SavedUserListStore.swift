//
//  LoginStore.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 18/2/26.
//
import Foundation
internal import Combine

final class SavedUserListStore : ObservableObject {
	private let savedUsersService: SavedUsersServiceProtocol
	
	@Published var state: SavedUserListState = SavedUserListState()
	
	init(savedUsersService: SavedUsersServiceProtocol) {
		self.savedUsersService = savedUsersService
		state.data = savedUsersService.savedUsers
	}

	func delete(user: User) {
		savedUsersService.delete(user: user)
		state.data = savedUsersService.savedUsers
	}
}
