import SwiftUI

struct CheckoutView: View {
    @Binding var isPresented: Bool
    @Binding var selectedGames: [Int: Int]  // This holds the selected games and their quantities.
    let games: [GameItem]
    
    @State private var buyerName = ""
    @State private var quantities: [Int: String] = [:] 
    
    private let baseURL = "http://162.38.39.28:3001"
    
    var subtotal: Double {
        return selectedGames.reduce(0) { total, entry in
            if let game = games.first(where: { $0.id == entry.key }), let qty = Int(quantities[entry.key] ?? "0") {
                return total + (Double(qty) * game.price)
            }
            return total
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations de l'Acheteur")) {
                    TextField("Nom de l'Acheteur", text: $buyerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                Section(header: Text("Quantité par Jeu")) {
                    ForEach(selectedGames.keys.sorted(), id: \.self) { gameId in
                        if let game = games.first(where: { $0.id == gameId }) {
                            HStack {
                                Text("\(game.name) - \(String(format: "%.2f €", game.price))")
                                Spacer()
                                TextField("Quantité", text: Binding(
                                    get: { quantities[gameId] ?? "1" },
                                    set: { quantities[gameId] = $0 }
                                ))
                                .keyboardType(.numberPad)
                                .frame(width: 50)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                    }
                }
                
                Section(header: Text("Total Général")) {
                    HStack {
                        Text("Total à Payer")
                        Spacer()
                        Text(String(format: "%.2f €", subtotal))
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }

                Section {
                    HStack {
                        Button("Annuler") {
                            isPresented = false
                        }
                        .foregroundColor(.red)
                        
                        Spacer()
                        
                        Button("Finaliser l'Achat") {
                            finalizePurchase()
                        }
                        .disabled(buyerName.isEmpty || subtotal == 0)
                    }
                }
            }
            .navigationTitle("Confirmer l'Achat")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func finalizePurchase() {
        let purchaseData = selectedGames.compactMap { (gameId, _) -> [String: Any]? in
            guard let game = games.first(where: { $0.id == gameId }),
                  let quantity = Int(quantities[gameId] ?? "0"),
                  quantity > 0 else {
                return nil
            }
            return [
                "JeuID": game.id,
                "quantite": quantity
            ]
        }

        guard !purchaseData.isEmpty else { return }

        let requestData: [String: Any] = [
            "selectedGames": purchaseData
        ]

        guard let url = URL(string: "\(baseURL)/achats/achat") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestData)
        } catch {
            print("Erreur JSON: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Erreur: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Pas de réponse serveur.")
                    return
                }

                if httpResponse.statusCode == 201 {
                    print("Achat réussi")
                    isPresented = false
                    selectedGames.removeAll()
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshGames"), object: nil)
                } else {
                    print("Échec de l'achat")
                }
            }
        }.resume()
    }
}
