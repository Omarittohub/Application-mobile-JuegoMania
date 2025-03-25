import SwiftUI
import Charts

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @State private var expandedGame: PopularGame? = nil

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                            .padding()
                    } else if let data = viewModel.dashboardData {
                        
                        Text("Top 5 Jeux Populaires")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)

                        let topGames = data.popularGames
                            .sorted { $0.quantite_disponible > $1.quantite_disponible }
                            .prefix(5)
                        
                        ForEach(topGames, id: \.id) { game in
                            Button(action: {
                                self.expandedGame = game
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(game.jeuxMarque.Nom)
                                            .font(.headline)
                                        
                                        Text("Prix: $\(game.prix_unitaire)")
                                            .font(.subheadline)
                                        
                                        Text("Stock: \(game.quantite_disponible)")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    
                                    Spacer()
                                }
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                                .padding(.horizontal)
                            }
                        }

                        Text("Données Des Ventes")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)

                        if #available(iOS 16.0, *) {
                            Chart {
                                BarMark(x: .value("Category", "Jeux Stockes"), y: .value("Value", data.jeuxStockes))
                                    .foregroundStyle(.blue)

                                BarMark(x: .value("Category", "Jeux Vendues"), y: .value("Value", data.jeuxVendues))
                                    .foregroundStyle(.green)

                                BarMark(x: .value("Category", "Jeux Invendus"), y: .value("Value", data.jeuxInvendus))
                                    .foregroundStyle(.red)
                            }
                            .frame(height: 200)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                        } else {
                            Text("Charts are only available on iOS 16.0 or newer")
                                .foregroundColor(.gray)
                                .padding()
                        }

                        VStack(spacing: 15) {
                            HStack {
                                Text("Jeux Stockes:")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(data.jeuxStockes)")
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                            .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                            
                            HStack {
                                Text("Jeux Vendues:")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(data.jeuxVendues)")
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                            .shadow(color: .green.opacity(0.3), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                            
                            HStack {
                                Text("Jeux Invendus:")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(data.jeuxInvendus)")
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.red)
                            .cornerRadius(12)
                            .shadow(color: .red.opacity(0.3), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                        }
                        .padding(.top, 20)
                    }
                }
                .padding(.vertical)
            }
            .onAppear(perform: viewModel.fetchDashboardData)
            .navigationTitle("Dashboard")
            .sheet(item: $expandedGame) { game in
                GameDetailView(game: game)
            }
        }
    }
}

struct GameDetailView: View {
    var game: PopularGame

    var body: some View {
        VStack(spacing: 20) {
            Text(game.jeuxMarque.Nom)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.primary)
                .padding(.bottom, 10)
            
            Text("Price: $\(game.prix_unitaire)")
                .font(.title2)
                .foregroundColor(.green)
            
            Text("Stock Available: \(game.quantite_disponible)")
                .font(.title3)
                .foregroundColor(.gray)
            
            Text(game.jeuxMarque.Description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Spacer()

            Button(action: {
                // Placeholder action for closing the detail view
            }) {
                Text("Close")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal, 15)
        .padding(.top, 10)
    }
}

