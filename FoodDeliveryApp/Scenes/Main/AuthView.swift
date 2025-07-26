import SwiftUI

struct AuthView: View {
    //
    @EnvironmentObject var appStateManager: AppStateManager
    
    @StateObject var presenter: AuthPresenter
    
    var interactor: AuthBusinessLogic
    
    @State private var username: String = ""
    @State private var password: String = ""
    @FocusState private var focusedField: Field?
    
    @State private var showCustomBanner: Bool = false
    @State private var customBannerMessage: String = ""
    
    @State private var isPasswordVisible: Bool = false

    
    enum Field: Hashable {
        case username
        case password
    }
    
    init(interactor: AuthBusinessLogic, presenter: AuthPresenter) {
        self.interactor = interactor
        _presenter = StateObject(wrappedValue: presenter)
    }
        
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color.backgroundMain.ignoresSafeArea()
                
                VStack {
                    if showCustomBanner {
                        ErrorBannerView(message: customBannerMessage) {
                            showCustomBanner = false
                            presenter.showAlert = false
                        }
                        .transition(.move(edge: .top))
                        .animation(.default, value: showCustomBanner)
                    }
                    Spacer()
                    AuthContent(
                        username: $username,
                        password: $password,
                        focusedField: $focusedField,
                        isPasswordVisible: $isPasswordVisible,
                        authenticateUser: authenticateUser
                    )
                    Spacer()
                }
                
                AuthBottomPanel(
                    presenter: presenter,
                    username: username,
                    password: password,
                    authenticateUser: authenticateUser
                )
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Авторизация")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                }
            }
            .navigationBarHidden(false)
            .onTapGesture {
                focusedField = nil
                if showCustomBanner {
                    showCustomBanner = false
                    presenter.showAlert = false
                }
            }
            .onChange(of: presenter.viewModel.success) { success in
                if success {
                    appStateManager.isAuthenticated = true
                    appStateManager.mainScreenMessage = "Вход выполнен успешно"
                }
            }
            .onChange(of: presenter.showAlert) { showAlertValue in
                if showAlertValue && !presenter.viewModel.success {
                    customBannerMessage = presenter.alertMessage
                    showCustomBanner = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        if showCustomBanner {
                            showCustomBanner = false
                            presenter.showAlert = false
                        }
                    }
                }
            }
        }
    }
    
    private func authenticateUser() {
        focusedField = nil
        showCustomBanner = false
        presenter.showAlert = false
        let request = Auth.Login.Request(username: username, password: password)
        interactor.login(request: request)
    }
}


struct AuthContent: View {
    @Binding var username: String
    @Binding var password: String
    @FocusState.Binding var focusedField: AuthView.Field?
    
    @Binding var isPasswordVisible: Bool

    let authenticateUser: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Image("TopPizzaLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 322, height: 103)
                .padding(.top, 50)
            
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundStyle(.gray)
                        .font(.system(size: 20))
                    
                    TextField("Логин", text: $username)
                        .foregroundColor(.black)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .username)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedField = .password
                        }
                }
                .padding(.horizontal, 16)
                .frame(width: 343, height: 50)
                .background(Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 1)
                )
                
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.gray)
                        .font(.system(size: 20))
                    
                    if isPasswordVisible {
                        TextField("Пароль", text: $password)
                            .foregroundColor(.black)
                            .focused($focusedField, equals: .password)
                            .submitLabel(.done)
                            .onSubmit {
                                authenticateUser()
                            }
                    } else {
                        SecureField("Пароль", text: $password)
                            .foregroundColor(.black)
                            .focused($focusedField, equals: .password)
                            .submitLabel(.done)
                            .onSubmit {
                                authenticateUser()
                            }
                    }
                                        
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 16)
                .frame(width: 343, height: 50)
                .background(Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
        }
    }
}

struct AuthBottomPanel: View {
    @ObservedObject var presenter: AuthPresenter
    let username: String
    let password: String
    let authenticateUser: () -> Void
    
    var body: some View {
        VStack {
            Button(action: {
                authenticateUser()
            }) {
                if presenter.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.pink)
                        .cornerRadius(20)
                } else {
                    Text("Войти")
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(username.isEmpty || password.isEmpty ? Color.inactiveButton : Color.pink)
                        .cornerRadius(20)
                }
            }
            .disabled(presenter.isLoading || username.isEmpty || password.isEmpty)
            .padding(.horizontal, 16)
            .padding(.bottom, 50)
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity)
        .background(
            Color.white
                .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
                .ignoresSafeArea(edges: .bottom)
        )
        .frame(height: 118)
    }
}

struct ErrorBannerView: View {
    let message: String
    let onClose: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            Text(message)
                .font(.system(size: 13))
                .fontWeight(.semibold)
                .foregroundColor(.red)
                
            Spacer()
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(20)
        .frame(width: 343, height: 50)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        configureAuthModule()
            .environmentObject(AppStateManager())
    }
}
