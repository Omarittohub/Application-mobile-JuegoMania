import SwiftUI

struct StocksView: View {
    @StateObject private var viewModel = StocksViewModel()
    @State private var isAddingDeposit = false
    @State private var shouldRefresh = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Inventaires")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                Button(action: { isAddingDeposit = true }) {
                    Text("Ajouter un Dépôt")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.top, 10)
                .sheet(isPresented: $isAddingDeposit, onDismiss: {
                    viewModel.fetchDepots() // Forcefully fetch depots when modal is dismissed
                }) {
                    AddDepositView(isPresented: $isAddingDeposit)
                }

                if viewModel.isLoading {
                    ProgressView("Chargement des dépôts...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.depots) { depot in
                                DepotCard(depot: depot)
                            }
                        }
                        .padding()
                    }
                }

                Spacer()
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.fetchDepots()
            }
            .onChange(of: shouldRefresh) { _ in
                viewModel.fetchDepots()
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RefreshDepots"))) { _ in
                viewModel.fetchDepots()
            }
        }
    }
}


struct DepotCard: View {
    let depot: Depot

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: "shippingbox.fill")
                    .foregroundColor(.blue)
                Text("ID Dépôt: \(depot.id)")
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
            }

            HStack(alignment: .center, spacing: 10) {
                Image(systemName: "person.crop.circle.fill")
                    .foregroundColor(.green)
                Text("Vendeur: \(depot.vendeurNom)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
            }

            HStack(alignment: .center, spacing: 10) {
                Image(systemName: "calendar.badge.clock")
                    .foregroundColor(.orange)
                Text("Session ID: \(depot.sessionId)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)))
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}
