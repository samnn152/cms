import SwiftUI

struct LoginView: View {
    @StateObject
    private var store: LoginStore

    @EnvironmentObject
    private var router: AppRouter
    
    @State
    private var showLoginError = false

	private var loginErrorMessage: String {
		store.state.status.errorMessage ?? "Vui long kiem tra lai thong tin dang nhap."
	}
    
    init() {
        _store = .init(wrappedValue: LoginStore(
            authService: APIAuthService(),
            savedUsersService: LocalSavedUsersService()
        ))
    }
    
    var body: some View {
        ZStack {
            LoginBackgroundView()
            VStack(alignment: .leading, spacing: 16) {
                LoginHeaderView(store: store)
                LoginBodyView(store: store)
                LoginFooterView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 16)
        }
        .onChange(of: store.state.status) { status in
            switch status {
            case .error:
                showLoginError = true
            case .success:
                router.go(to: .home)
            default:
                break
            }
        }
        .alert("Đăng nhập thất bại", isPresented: $showLoginError) {
            Button("OK", role: .cancel) {}
        } message: {
			Text(loginErrorMessage)
        }
    }
}

#Preview {
    LoginView()
}
