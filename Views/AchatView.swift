import SwiftUI

struct AchatView: View {
    @StateObject private var viewModel = AchatViewModel()
    @State private var selectedGames: [Int: Int] = [:]
    @State private var isCheckoutPresented = false
    @State private var searchText = ""

    var filteredGames: [GameItem] {
        if searchText.isEmpty {
            return viewModel.games
        } else {
            return viewModel.games.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Produits")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)

                TextField("Rechercher un produit...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top, 10)

                if viewModel.isLoading {
                    ProgressView("Chargement...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List {
                        Section {
                            ForEach(filteredGames) { game in
                                HStack {
                                    Button(action: {
                                        toggleSelection(for: game.id)
                                    }) {
                                        Image(systemName: selectedGames.keys.contains(game.id) ? "checkmark.square.fill" : "square")
                                            .foregroundColor(selectedGames.keys.contains(game.id) ? .blue : .gray)
                                    }

                                    VStack(alignment: .leading) {
                                        Text(game.name)
                                            .font(.headline)
                                        Text("Vendeur: \(game.sellerName)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Text("Quantité: \(game.quantityAvailable)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()

                                    Text(String(format: "%.2f €", game.price))
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                }
                                .padding(.vertical, 4)
                            }
                        } header: {
                            Text("Sélectionnez les jeux")
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }

                Button(action: {
                    isCheckoutPresented = true
                }) {
                    Text("Faire un Achat")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedGames.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(selectedGames.isEmpty)
                .sheet(isPresented: $isCheckoutPresented) {
                    CheckoutView(isPresented: $isCheckoutPresented, selectedGames: $selectedGames, games: viewModel.games)
                }
            }
            .onAppear {
                viewModel.fetchSellers()
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RefreshGames"))) { _ in
                viewModel.fetchGamesForSale()
            }
            .navigationBarHidden(true)
        }
    }

    private func toggleSelection(for gameId: Int) {
        if selectedGames.keys.contains(gameId) {
            selectedGames.removeValue(forKey: gameId)
        } else {
            selectedGames[gameId] = 1 // Default quantity set to 1
        }
    }
}
