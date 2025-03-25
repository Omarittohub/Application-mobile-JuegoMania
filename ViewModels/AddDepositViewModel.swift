import Foundation
import SwiftUI

class AddDepositViewModel: ObservableObject {
    @Published var sellers: [Seller] = []
    @Published var availableGames: [GameBrand] = []
    @Published var commissionFee: Double = 0.0
    @Published var errorMessage: String?
    @Published var isDepositSuccessful: Bool = false
    
    // Récupère la liste des vendeurs depuis l'API
    
    func fetchSellers() {
        AddDepositAPIService.shared.fetchSellers { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sellers):
                    self?.sellers = sellers
                case .failure(let error):
                    self?.errorMessage = "Erreur: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // Récupère la liste des Marques depuis l'API

    func fetchAvailableGames() {
        AddDepositAPIService.shared.fetchAvailableGames { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let games):
                    self?.availableGames = games
                case .failure(let error):
                    self?.errorMessage = "Erreur: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // Récupère les frais de depots depuis l'API
    
    func fetchFraisDepot() {
        AddDepositAPIService.shared.fetchFraisDepot { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let commissionFee):
                    self?.commissionFee = commissionFee
                case .failure(let error):
                    self?.errorMessage = "Erreur: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func createDepot(vendeurID: Int, games: [GameDeposit], completion: @escaping (Bool) -> Void) {
        let jeuxDeposes: [[String: Any]] = games.map { game in
            let gameId = Int(game.gameName.components(separatedBy: " - ").first ?? "") ?? 0
            return [
                "nomJeu": gameId,
                "prixUnitaire": game.unitPrice,
                "quantite_depose": game.quantity
            ]
        }

        let depotData: [String: Any] = [
            "vendeurId": vendeurID,
            "jeux": jeuxDeposes
        ]

        AddDepositAPIService.shared.createDepot(depotData: depotData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.isDepositSuccessful = true
                    completion(true)
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshDepots"), object: nil)
                case .failure(let error):
                    self.errorMessage = "Erreur: \(error.localizedDescription)"
                    completion(false)
                }
            }
        }
        // Send notification pour refresh la liste depots 
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshDepots"), object: nil)
    }
}
