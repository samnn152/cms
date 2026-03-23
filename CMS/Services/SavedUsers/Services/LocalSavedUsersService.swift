//
//  LocalSavedUsersService.swift
//  CMS
//  Created by Assistant.
//

import Foundation

final class LocalSavedUsersService: SavedUsersServiceProtocol {
    private let storageKey = "SavedUsersService_Users"
    private var users: [User] = []
    
    init() {
        loadUsers()
    }
    
    var lastLoginUser: User? {
        users.last
    }
    
    var savedUsers: [User] {
        users
    }
    
    func save(user: User) {
        if !users.contains(where: { $0.id == user.id }) {
            users.append(user)
            persist()
        }
    }
    
    func delete(user: User) {
        users.removeAll { $0.id == user.id }
        persist()
    }
    
    func reload() {
        loadUsers()
    }
    
    // MARK: - Persistence
    private func persist() {
        do {
            let data = try JSONEncoder().encode(users)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            // Ignore; real app might log or report error.
        }
    }
    
    private func loadUsers() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            users = try JSONDecoder().decode([User].self, from: data)
        } catch {
            users = []
        }
    }
}
