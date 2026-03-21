//
//  CMSApp.swift
//  CMS
//
//  Created by Ngô Ngọc Sâm on 18/2/26.
//
import SwiftUI
import NavigationStackBackport
internal import Combine

@main
struct CMSApp: App {
	var body: some Scene {
		WindowGroup {
			AppView()
		}
	}
}

struct AppView: View {
	@StateObject private var router = AppRouter()

	var body: some View {
		ZStack {
			if !router.initialized {
				SplashView()
			} else {
				NavigationStackBackport.NavigationStack(path: $router.stack) {
					rootView
						.backport.navigationDestination(for: Destination.self) { destination in
							destinationView(for: destination)
						}
				}
			}
		}
		.environmentObject(router)
	}

	@ViewBuilder
	private var rootView: some View {
		if let firstDestination = router.root {
			destinationView(for: firstDestination)
		} else {
			EmptyView()
		}
	}

	@ViewBuilder
	private func destinationView(for destination: Destination) -> some View {
		switch destination {
		case .login, .changeAccount:
			LoginView()
		case .register:
			RegisterView()
		case .forgotPassword:
			ResetPasswordView()
		case .home:
			HomeView()
		default:
			EmptyView()
		}
	}
}

final class AppRouter: ObservableObject {
	@Published var initialized: Bool = false
	@Published var stack: [Destination] = []
	@Published var root: Destination?
	
	var current: Destination? {
		self.stack.last ?? self.root
	}

	func go(to path: Destination) {
		self.initialized = true
		self.stack.removeAll()
		self.root = path
	}
	
	func push(to next: Destination) {
		self.stack.append(next)
	}
	
	func pushReplacement(to next: Destination) {
		if self.stack.isEmpty {
			self.root = next
		} else {
			self.stack.removeLast()
			self.stack.append(next)
		}
	}
	
	func pop() {
		self.stack.popLast()
	}
}

#Preview {
	AppView()
}
