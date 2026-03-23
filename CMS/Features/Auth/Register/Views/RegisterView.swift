import SwiftUI

struct RegisterView: View {
	@StateObject
	private var store: RegisterStore

	@EnvironmentObject
	private var router: AppRouter

	@State
	private var showRegisterError = false

	private var registerErrorMessage: String {
		store.state.status.errorMessage ?? "Không thể tạo tài khoản lúc này."
	}
	
	init() {
		_store = .init(wrappedValue: RegisterStore(
			authService: APIAuthService(),
		))
	}
	
	var body: some View {
		ZStack {
			RegisterBackgroundView()
			VStack(alignment: .leading, spacing: 16) {
				RegisterHeaderView(store: store)
				RegisterBodyView(store: store)
			}.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
				.padding(.horizontal, 16)
		}
		.onChange(of: store.state.status) { status in
			switch status {
			case .error:
				showRegisterError = true
			case .success:
				router.go(to: .login)
			default:
				break
			}
		}
		.alert("Đăng ký thất bại", isPresented: $showRegisterError) {
			Button("OK", role: .cancel) {}
		} message: {
			Text(registerErrorMessage)
		}
		.navigationBarBackButtonHidden(true)
	}
}

#Preview {
	RegisterView()
}
