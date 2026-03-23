//
//  APIAuthService.swift
//  CMS
//
//  Created by Assistant.
//

import Foundation

final class APIAuthService: AuthServiceProtocol {
	private enum APIConfiguration {
		private static let fallbackBaseURL = URL(string: "http://127.0.0.1:8080")!

		static let baseURL: URL = {
			guard
				let baseURLString = AppEnvironment.string(for: "API_BASE_URL"),
				let url = URL(string: baseURLString)
			else {
				return fallbackBaseURL
			}

			return url
		}()
	}

	private enum RequestKind {
		case login
		case register
		case requestPasswordReset
		case resetPassword
	}

    private(set) var user: User?
    
    var isAuthenticated: Bool {
        user != nil
    }

    func login(with method: AuthMethod, completion: @escaping (Result<User, AuthError>) -> Void) {
		guard case let .usernameAndPassword(identifier, password) = method else {
            completion(.failure(.invalidCredentials))
            return
        }

		performRequest(
			path: "/auth/login",
			kind: .login,
			body: LoginRequestBody(
				identifier: identifier.trimmingCharacters(in: .whitespacesAndNewlines),
				password: password
			)
		) { [weak self] (result: Result<AuthResponsePayload, AuthError>) in
			switch result {
			case let .success(payload):
				let user = payload.user.asUser()
				self?.user = user
				completion(.success(user))
			case let .failure(error):
				completion(.failure(error))
			}
		}
	}

	func register(email: String, studentID: String?, password: String, completion: @escaping (Result<User, AuthError>) -> Void) {
		performRequest(
			path: "/auth/register",
			kind: .register,
			body: RegisterRequestBody(
				email: email.trimmingCharacters(in: .whitespacesAndNewlines),
				password: password
			)
		) { (result: Result<RegisterResponsePayload, AuthError>) in
			switch result {
			case let .success(payload):
				completion(.success(payload.user.asUser(fallbackStudentID: studentID)))
			case let .failure(error):
				completion(.failure(error))
			}
		}
	}

	func requestPasswordReset(identifier: String, completion: @escaping (Result<String, AuthError>) -> Void) {
		performRequest(
			path: "/auth/request-reset-password",
			kind: .requestPasswordReset,
			body: IdentifierRequestBody(
				identifier: identifier.trimmingCharacters(in: .whitespacesAndNewlines)
			)
		) { (result: Result<MessageResponsePayload, AuthError>) in
			switch result {
			case let .success(payload):
				completion(.success(payload.message))
			case let .failure(error):
				completion(.failure(error))
			}
		}
	}

	func resetPassword(identifier: String, verificationCode: String, newPassword: String, completion: @escaping (Result<User, AuthError>) -> Void) {
		performRequest(
			path: "/auth/reset-password",
			kind: .resetPassword,
			body: ResetPasswordRequestBody(
				identifier: identifier.trimmingCharacters(in: .whitespacesAndNewlines),
				secretCode: verificationCode.trimmingCharacters(in: .whitespacesAndNewlines),
				newPassword: newPassword
			)
		) { [weak self] (result: Result<AuthResponsePayload, AuthError>) in
			switch result {
			case let .success(payload):
				let user = payload.user.asUser()
				self?.user = user
				completion(.success(user))
			case let .failure(error):
				completion(.failure(error))
			}
		}
	}

    func logout() {
        user = nil
    }

	static func makeOAuthStartURL(for provider: SocialProvider) -> URL? {
		URL(string: "/auth/oauth/\(provider.backendProvider)/start", relativeTo: APIConfiguration.baseURL)
	}

	private func performRequest<Body: Encodable, Payload: Decodable>(
		path: String,
		kind: RequestKind,
		body: Body,
		completion: @escaping (Result<Payload, AuthError>) -> Void
	) {
		guard let url = URL(string: path, relativeTo: APIConfiguration.baseURL) else {
			DispatchQueue.main.async {
				completion(.failure(.networkError))
			}
			return
		}

		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")

		do {
			request.httpBody = try JSONEncoder().encode(body)
		} catch {
			DispatchQueue.main.async {
				completion(.failure(.networkError))
			}
			return
		}

		URLSession.shared.dataTask(with: request) { data, response, error in
			if error != nil {
				DispatchQueue.main.async {
					completion(.failure(.networkError))
				}
				return
			}

			guard let response = response as? HTTPURLResponse, let data else {
				DispatchQueue.main.async {
					completion(.failure(.networkError))
				}
				return
			}

			let decoder = JSONDecoder()

			if (200 ..< 300).contains(response.statusCode) {
				do {
					let payload = try decoder.decode(Payload.self, from: data)
					DispatchQueue.main.async {
						completion(.success(payload))
					}
				} catch {
					DispatchQueue.main.async {
						completion(.failure(.unknown(code: response.statusCode, message: "Phản hồi máy chủ không hợp lệ.")))
					}
				}
				return
			}

			let message = self.extractErrorMessage(from: data, statusCode: response.statusCode)

			DispatchQueue.main.async {
				completion(.failure(self.mapError(kind: kind, statusCode: response.statusCode, message: message)))
			}
		}.resume()
	}

	private func mapError(kind: RequestKind, statusCode: Int, message: String) -> AuthError {
		switch kind {
		case .login:
			if [400, 401, 422].contains(statusCode) {
				return .invalidCredentials
			}
		case .register:
			if statusCode == 409 {
				return .unknown(code: statusCode, message: "Email này đã được sử dụng.")
			}
		case .resetPassword:
			if [400, 401, 403, 422].contains(statusCode) {
				return .invalidCredentials
			}
		case .requestPasswordReset:
			break
		}

		return .unknown(code: statusCode, message: message)
	}

	private func extractErrorMessage(from data: Data, statusCode: Int) -> String {
		if
			let payload = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
			let message = payload["message"] as? String,
			!message.isEmpty
		{
			return message
		}

		return HTTPURLResponse.localizedString(forStatusCode: statusCode)
	}
}

private struct LoginRequestBody: Encodable {
	let identifier: String
	let password: String
}

private struct RegisterRequestBody: Encodable {
	let email: String
	let password: String
}

private struct IdentifierRequestBody: Encodable {
	let identifier: String
}

private struct ResetPasswordRequestBody: Encodable {
	let identifier: String
	let secretCode: String
	let newPassword: String

	enum CodingKeys: String, CodingKey {
		case identifier
		case secretCode = "secret_code"
		case newPassword = "new_password"
	}
}

private struct MessageResponsePayload: Decodable {
	let message: String
}

private struct RegisterResponsePayload: Decodable {
	let user: APIUserPayload
}

private struct AuthResponsePayload: Decodable {
	let user: APIUserPayload
}

private struct APIUserPayload: Decodable {
	let id: String
	let email: String?
	let studentID: String?
	let name: String?
	let avatarURL: String?
	let role: String?

	enum CodingKeys: String, CodingKey {
		case id
		case email
		case studentID = "student_id"
		case name
		case avatarURL = "avatar_url"
		case role
	}

	func asUser(fallbackStudentID: String? = nil) -> User {
		let resolvedEmail = email?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
		let resolvedName = name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
		let resolvedAvatarURL = avatarURL?.trimmingCharacters(in: .whitespacesAndNewlines)

		return User(
			id: id,
			email: resolvedEmail,
			studentID: studentID ?? fallbackStudentID,
			displayName: resolvedName.isEmpty ? (resolvedEmail.isEmpty ? "Người dùng" : resolvedEmail) : resolvedName,
			avatarURL: resolvedAvatarURL,
			role: UserRole(rawValue: role ?? "guest") ?? .guest,
			isActive: nil
		)
	}
}
