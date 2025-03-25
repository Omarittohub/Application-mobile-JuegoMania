import SwiftUI

struct AdminView: View {
    @StateObject private var viewModel = AdminViewModel()

    var body: some View {
        if viewModel.isAuthenticated {
            AdminPanelView()
        } else {
            VStack {
                Text("Admin Login")
                    .font(.largeTitle)
                    .padding()
                
                TextField("Username", text: $viewModel.username)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $viewModel.password)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    viewModel.authenticate()
                }) {
                    Text("Login")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
        }
    }
}
