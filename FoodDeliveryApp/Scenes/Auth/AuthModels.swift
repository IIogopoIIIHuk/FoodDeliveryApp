import Foundation
import Combine
import SwiftUI

enum Auth {
    enum Login {
        struct Request {
            let username: String
            let password: String
        }
        struct Response {
            let success: Bool
            let message: String
        }
        struct ViewModel {
            let success: Bool
            let message: String
        }
    }
}

protocol AuthBusinessLogic {
    func login(request: Auth.Login.Request)
}

protocol AuthPresentationLogic {
    func presentLoginResult(response: Auth.Login.Response)
    func presentLoadingState(isLoading: Bool)
}

protocol AuthDisplayLogic: ObservableObject {
    var isLoading: Bool { get set }
    var showAlert: Bool { get set }
    var alertMessage: String { get set }
    var viewModel: Auth.Login.ViewModel { get set }
}

// Эти протоколы больше не используются в обновленной архитектуре
protocol AuthRoutingLogic {
    func navigateToMainScreen()
}

protocol AuthDataPassing {
    var dataStore: AuthDataStore? { get set }
}

protocol AuthDataStore{
    var someData: String? { get set }
}
