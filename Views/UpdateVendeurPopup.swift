import SwiftUI

struct UpdateVendeurPopup: View {
    @State var vendeur: Vendeur
    @ObservedObject var viewModel: VendeurViewModel
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations du Vendeur")) {
                    TextField("Nom", text: $vendeur.name)
                        .textInputAutocapitalization(.words)
                    
                    TextField("Email", text: $vendeur.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    TextField("Téléphone", text: $vendeur.phone)
                        .keyboardType(.phonePad)
                }
            }
            .navigationTitle("Mettre à jour")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        viewModel.updateVendeur(vendeur: vendeur)
                        dismiss()
                    }
                }
            }
        }
    }
}
