import Foundation
import CryptoKit

class AuthInteractor: AuthBusinessLogic, AuthDataStore {
    var presenter: AuthPresentationLogic?
    
    var someData: String?
    
    init() { }
    //
    func login (request: Auth.Login.Request) {
        print("AuthInteractor: login called with username: \(request.username)")
        presenter?.presentLoadingState(isLoading: true)
        
        let correctUsername = "user"
        let correctPasswordHash = "5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8"
        
        let enteredPasswordData = Data(request.password.utf8)
        let enteredPasswordHashed = SHA256.hash(data: enteredPasswordData).compactMap {String(format: "%02x", $0)}.joined()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            print("AuthInteractor: Async operation finished.")
            if request.username == correctUsername && enteredPasswordHashed == correctPasswordHash {
                print("AuthInteractor: Authentication Success.")
                let response = Auth.Login.Response(success: true, message: "Вход выполнен успешно")
                self.presenter?.presentLoginResult(response: response)
            } else {
                print("AuthInteractor: Authentication Failure.")
                let response = Auth.Login.Response (success: false, message: "Неверный логин или пароль")
                self.presenter?.presentLoginResult(response: response)
            }
        }
    }
}
