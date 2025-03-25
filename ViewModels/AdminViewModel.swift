import SwiftUI

class AdminViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false

    private let correctUsername = "A"
    private let correctPassword = "A"

    func authenticate() {
        if username == correctUsername && password == correctPassword {
            isAuthenticated = true
        }
    }
}


