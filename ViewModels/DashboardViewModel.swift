import Foundation

class DashboardViewModel: ObservableObject {
    @Published var dashboardData: DashboardData? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var apiService = DashboardAPIService.shared

    func fetchDashboardData() {
        isLoading = true
        apiService.fetchDashboardData { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    self.dashboardData = data
                case .failure(let error):
                    self.errorMessage = "Error loading data: \(error.localizedDescription)"
                }
            }
        }
    }
}
