import SwiftUI
import Combine

class RapportsViewModel: ObservableObject {
    @Published var vendeurs: [Vendeur] = []
    @Published var sessions: [Sessionrapport] = []
    private let baseURL = "http://162.38.39.28:3001"
    private var apiService = RapportsAPIService.shared
    @Published var isLoading = false
    @Published var bilan: BilanVendeurSession? = nil
    @Published var errorMessage: String? = nil
    
    func fetchVendeurs() {
        guard let url = URL(string: "\(baseURL)/stocks/vendeurs") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        self.vendeurs = try JSONDecoder().decode([Vendeur].self, from: data)
                    } catch {
                        print("Erreur de décodage des vendeurs: \(error)")
                    }
                }
            }
        }.resume()
    }
    
    func fetchSessions() {
        guard let url = URL(string: "\(baseURL)/sessions") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        self.sessions = try JSONDecoder().decode([Sessionrapport].self, from: data)
                    } catch {
                        print("Erreur de décodage des sessions: \(error)")
                    }
                }
            }
        }.resume()
    }
    
    func fetchBilan(vendeurID: Int, sessionID: Int) {
            isLoading = true
            apiService.fetchBilan(vendeurID: vendeurID, sessionID: sessionID) { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch result {
                    case .success(let bilan):
                        self.bilan = bilan
                    case .failure(let error):
                        self.errorMessage = "Erreur de chargement du bilan: \(error.localizedDescription)"
                    }
                }
            }
        }
}
