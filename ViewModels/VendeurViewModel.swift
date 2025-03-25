import SwiftUI

class VendeurViewModel: ObservableObject {
    @Published var vendeurs: [Vendeur] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var selectedVendeur: Vendeur? = nil  
    
    func fetchVendeurs() {
        isLoading = true
        errorMessage = nil
        
        VendeurAPIService.shared.fetchVendeurs { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let vendeurs):
                    self?.vendeurs = vendeurs
                case .failure(let error):
                    self?.errorMessage = "Erreur: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func addVendeur(name: String, email: String, phone: String) {
        isLoading = true
        errorMessage = nil
        
        let vendeurRequest = ["Nom": name, "Email": email, "Telephone": phone]
        
        VendeurAPIService.shared.addVendeur(vendeurRequest: vendeurRequest) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let vendeur):
                    self?.vendeurs.append(vendeur)
                case .failure(let error):
                    self?.errorMessage = "Erreur: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func updateVendeur(vendeur: Vendeur) {
        isLoading = true
        errorMessage = nil
        
        VendeurAPIService.shared.updateVendeur(vendeur: vendeur) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let updatedVendeur):
                    if let index = self?.vendeurs.firstIndex(where: { $0.id == updatedVendeur.id }) {
                        self?.vendeurs[index] = updatedVendeur
                    }
                case .failure(let error):
                    self?.errorMessage = "Erreur: \(error.localizedDescription)"
                }
            }
        }
    }
}
