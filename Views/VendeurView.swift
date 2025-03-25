import SwiftUI

struct VendeurView: View {
    @StateObject private var viewModel = VendeurViewModel()
    
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    
    @State private var isUpdatePopupPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    TextField("Nom", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                    
                    TextField("Téléphone", text: $phone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.phonePad)
                    
                    Button(action: {
                        viewModel.addVendeur(name: name, email: email, phone: phone)
                        name = ""
                        email = ""
                        phone = ""
                    }) {
                        Text("Ajouter Vendeur")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                ScrollView {
                    ForEach(viewModel.vendeurs) { vendeur in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(vendeur.name)
                                    .font(.headline)
                                Text("Email: \(vendeur.email)")
                                Text("Téléphone: \(vendeur.phone)")
                            }
                            Spacer()
                            Button(action: {
                                viewModel.selectedVendeur = vendeur // Correctly update selectedVendeur
                                isUpdatePopupPresented = true
                            }) {
                                Text("Mettre à jour")
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(Color.yellow)
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Page des Vendeurs")
            .onAppear {
                viewModel.fetchVendeurs()
            }
            .sheet(isPresented: $isUpdatePopupPresented) {
                if let selectedVendeur = viewModel.selectedVendeur {
                    UpdateVendeurPopup(vendeur: selectedVendeur, viewModel: viewModel)
                }
            }
        }
    }
}
