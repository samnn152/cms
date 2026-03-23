import SwiftUI

struct ResetPasswordView: View {
	@StateObject
	private var store: ResetPasswordStore
	
	@EnvironmentObject
	private var router: AppRouter

	@State
	private var showResetPasswordError = false

	private var resetPasswordErrorMessage: String {
		store.state.status.errorMessage ?? "Không thể xử lý yêu cầu lúc này."
	}
	
	init() {
		_store = .init(wrappedValue: ResetPasswordStore(
			authService: APIAuthService()
		))
	}
	
	var body: some View {
		ZStack {
			ResetPasswordBackgroundView()
			VStack(alignment: .leading, spacing: 16) {
				ResetPasswordHeaderView(store: store)
				ResetPasswordBodyView(store: store)
			}.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
				.padding(.horizontal, 16)
		}
		.onChange(of: store.state.status) { status in
			switch status {
			case .error:
				showResetPasswordError = true
			case .success:
				router.go(to: .home)
			default:
				break
			}
		}
		.alert("Không thể đặt lại mật khẩu", isPresented: $showResetPasswordError) {
			Button("OK", role: .cancel) {}
		} message: {
			Text(resetPasswordErrorMessage)
		}
		.navigationBarBackButtonHidden(true)
	}
}

#Preview {
	ResetPasswordView()
}
