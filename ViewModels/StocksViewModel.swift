import Foundation
import SwiftUI

class StocksViewModel: ObservableObject {
    @Published var depots: [Depot] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    func fetchDepots() {
        isLoading = true
        StocksAPIService.shared.fetchDepots { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let depots):
                    self?.depots = depots
                case .failure(let error):
                    self?.errorMessage = "Erreur: \(error.localizedDescription)"
                }
            }
        }
    }
}
