import SwiftUI

class AdminPanelViewModel: ObservableObject {
    @Published var sessionHistory: [Session] = []
    @Published var activeSession: Session?
    @Published var managerList: [String] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Fetch Sessions
    func fetchSessions() {
        isLoading = true
        errorMessage = nil
        
        AdminAPIService.shared.fetchSessions { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let sessions):
                    self?.sessionHistory = sessions
                case .failure(let error):
                    self?.errorMessage = "Erreur: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - Fetch Active Session
    func fetchActiveSession() {
        isLoading = true
        errorMessage = nil
        
        AdminAPIService.shared.fetchActiveSession { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let session):
                    self?.activeSession = session
                case .failure(let error):
                    self?.errorMessage = "Erreur: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - Create New Session
    func createSession(name: String, commission: Double, fraisDepot: Double) {
        isLoading = true
        errorMessage = nil
        
        AdminAPIService.shared.createSession(name: name, commission: commission, fraisDepot: fraisDepot) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success:
                    self?.fetchSessions() // Refresh the list of sessions
                    self?.fetchActiveSession() // Refresh the active session
                    
                    
                case .failure(let error):
                    self?.errorMessage = "Erreur: \(error.localizedDescription)"
                    
                }
            }
        }
    }
    
    // MARK: - Close Session
    func closeSession() {
        isLoading = true
        errorMessage = nil
        
        AdminAPIService.shared.closeSession { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success:
                    self?.activeSession = nil
                    self?.fetchSessions() // Refresh the sessions list after closing the active session
                case .failure(let error):
                    self?.errorMessage = "Erreur: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - Fetch Managers
    func fetchManagers() {
        isLoading = true
        errorMessage = nil
        
        AdminAPIService.shared.fetchManagers { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let managers):
                    self?.managerList = managers.map { "\($0.Prenom) \($0.Nom) (\($0.Email))" }
                case .failure(let error):
                    self?.errorMessage = "Erreur: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - Add Manager
    func addManager(manager: Manager) {
        isLoading = true
        errorMessage = nil
        
        AdminAPIService.shared.addManager(manager: manager) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success:
                    self?.fetchManagers() // Refresh the managers list
                case .failure(let error):
                    self?.errorMessage = "Erreur: \(error.localizedDescription)"
                }
            }
        }
    }
}
