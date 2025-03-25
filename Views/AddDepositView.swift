import SwiftUI

struct AddDepositView: View {
    @Binding var isPresented: Bool
    @StateObject private var viewModel = AddDepositViewModel()
    
    @State private var selectedSeller: String = ""
    @State private var games: [GameDeposit] = [GameDeposit()]

    var totalDepositValue: Double {
        return games.reduce(0) { $0 + ($1.unitPrice * Double($1.quantity)) }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sélectionnez un Vendeur")) {
                    if viewModel.sellers.isEmpty {
                        ProgressView("Chargement des vendeurs...")
                    } else {
                        Picker("Sélectionnez un Vendeur", selection: $selectedSeller) {
                            ForEach(viewModel.sellers, id: \.id) { seller in
                                Text("\(seller.id) - \(seller.name)").tag("\(seller.id)")
                            }
                        }
                    }
                }

                Section(header: Text("Jeux Déposés")) {
                    ForEach($games.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 8) {
                            Picker("Jeu", selection: $games[index].gameName) {
                                ForEach(viewModel.availableGames, id: \.id) { game in
                                    Text("\(game.id) - \(game.name)").tag("\(game.id)")
                                }
                            }

                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Prix Unitaire (€)")
                                        .font(.caption)
                                    TextField("Entrez le prix", text: $games[index].unitPriceString)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }

                                Spacer()

                                VStack(alignment: .leading) {
                                    Text("Quantité Déposée")
                                        .font(.caption)
                                    TextField("Quantité", text: $games[index].quantityString)
                                        .keyboardType(.numberPad)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                            }
                        }
                        .padding(.vertical, 6)
                    }

                    Button(action: {
                        games.append(GameDeposit())
                    }) {
                        Label("Ajouter un Jeu", systemImage: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }

                Section(header: Text("Résumé du Dépôt")) {
                    HStack {
                        Text("Total des Dépôts")
                        Spacer()
                        Text(String(format: "%.2f €", totalDepositValue))
                            .font(.headline)
                            .foregroundColor(.blue)
                    }

                    HStack {
                        Text("Frais de Dépôt (\(String(format: "%.1f", viewModel.commissionFee * 100))%)")
                        Spacer()
                        Text(String(format: "%.2f €", totalDepositValue * viewModel.commissionFee))
                            .font(.headline)
                            .foregroundColor(.red)
                    }

                    HStack {
                        Text("Valeur Final")
                        Spacer()
                        Text(String(format: "%.2f €", totalDepositValue - totalDepositValue * viewModel.commissionFee))
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }

                Section {
                    HStack {
                        Button("Annuler") {
                            isPresented = false
                        }
                        .foregroundColor(.red)
                        
                        Spacer()
                        
                        Button("Déposer") {
                            viewModel.createDepot(vendeurID: Int(selectedSeller) ?? 0, games: games) { success in
                                if success {
                                    isPresented = false
                                }
                            }
                            NotificationCenter.default.post(name: NSNotification.Name("RefreshDepots"), object: nil)
                        }
                        .disabled(selectedSeller.isEmpty || games.isEmpty || games.first?.gameName.isEmpty == true)

                    }
                }
            }
            .navigationTitle("Ajouter un Dépôt")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchSellers()
                viewModel.fetchAvailableGames()
                viewModel.fetchFraisDepot()
            }
        }
    }
}
