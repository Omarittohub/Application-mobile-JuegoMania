import Foundation
import SwiftUI

class GamesViewModel: ObservableObject {
    @Published var games: [GameItems] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let apiService = GamesAPIService()

    func fetchGames() {
        isLoading = true
        errorMessage = nil

        apiService.fetchGames { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let fetchedGames):
                    self?.games = fetchedGames
                case .failure(let error):
                    self?.errorMessage = "Erreur: \(error.localizedDescription)"
                }
            }
        }
    }

    func toggleSaleStatus(for gameID: Int) {
        guard let index = games.firstIndex(where: { $0.id == gameID }) else { return }
        
        games[index].mis_en_vente.toggle()
        
        apiService.toggleSaleStatus(for: gameID, isSelling: games[index].mis_en_vente)
    }
}
