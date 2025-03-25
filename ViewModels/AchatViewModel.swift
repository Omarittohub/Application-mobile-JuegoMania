import Foundation

class AchatViewModel: ObservableObject {
    @Published var games: [GameItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseURL = "http://162.38.39.28:3001"
    private var sellers: [Int: String] = [:]
    
    // Récupère la liste des vendeurs depuis l'API

    func fetchSellers() {
        guard let url = URL(string: "\(baseURL)/stocks/vendeurs") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Erreur: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received."
                    return
                }

                do {
                    let decodedSellers = try JSONDecoder().decode([Seller].self, from: data)
                    // Transforme la liste des vendeurs en un dictionnaire avec id en clé

                    self.sellers = Dictionary(uniqueKeysWithValues: decodedSellers.map { ($0.id, $0.name) })
                    
                    self.fetchGamesForSale() // Now fetch games once sellers are loaded
                } catch {
                    self.errorMessage = "Erreur de décodage des vendeurs: \(error)"
                }
            }
        }.resume()
    }
    
    // Récupère la liste des jeux en ventes l'API
    
    func fetchGamesForSale() {
        guard let url = URL(string: "\(baseURL)/stocks/jeuxenvente") else { return }
        
        isLoading = true
        errorMessage = nil
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    // Gère l'erreur en cas de problème réseau ou API

                    self.errorMessage = "Erreur: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received."
                    return
                }

                do {
                    var decodedGames = try JSONDecoder().decode([GameItem].self, from: data)
                    
                    // Transforme la liste des vendeurs en un dictionnaire avec id en clé
                    for index in decodedGames.indices {
                        if let sellerName = self.sellers[decodedGames[index].sellerID] {
                            decodedGames[index].sellerName = sellerName
                        }
                    }
                    
                    self.games = decodedGames
                } catch {
                    self.errorMessage = "Erreur de décodage des jeux: \(error)"
                }
            }
        }.resume()
    }
}
