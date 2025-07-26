import Foundation
import Combine

class AuthPresenter: AuthPresentationLogic, AuthDisplayLogic {
    //
    @Published var isLoading: Bool = false { didSet { print("AuthPresenter: isLoading -> \(isLoading)") } }
    @Published var showAlert: Bool = false { didSet { print("AuthPresenter: showAlert -> \(showAlert)") } }
    @Published var alertMessage: String = "" { didSet { print("AuthPresenter: alertMessage -> \(alertMessage)") } }
    @Published var viewModel: Auth.Login.ViewModel = Auth.Login.ViewModel(success: false, message: "") { didSet { print("AuthPresenter: viewModel updated.") } }

    func presentLoginResult(response: Auth.Login.Response) {
        let message = response.message
        let newViewModel = Auth.Login.ViewModel(success: response.success, message: message)
        
        DispatchQueue.main.async {
            self.viewModel = newViewModel
            self.alertMessage = message
            
            if !response.success {
                self.showAlert = true
            }
            self.isLoading = false
        }
    }
    
    func presentLoadingState(isLoading: Bool) {
        DispatchQueue.main.async {
            self.isLoading = isLoading
        }
    }
}
