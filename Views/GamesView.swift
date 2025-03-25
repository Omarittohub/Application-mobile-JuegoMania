import SwiftUI

struct GamesView: View {
    @StateObject private var viewModel = GamesViewModel()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Jeux Disponibles")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                if viewModel.isLoading {
                    ProgressView("Chargement...")
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(viewModel.games.indices, id: \.self) { index in
                                GameCard(game: $viewModel.games[index], toggleSaleStatus: viewModel.toggleSaleStatus)
                            }
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                viewModel.fetchGames()
            }
        }
    }
}

struct GameCard: View {
    @Binding var game: GameItems
    let toggleSaleStatus: (Int) -> Void

    var body: some View {
        VStack {
            VStack(spacing: 4) {
                Text(game.name)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)

                Text(game.price)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                Text("Quantité: \(game.quantite)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal)

            Spacer()

            Button(action: {
                toggleSaleStatus(game.id)
            }) {
                Text(game.mis_en_vente ? "Retirer de la vente" : "Mettre en vente")
                    .font(.footnote)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(game.mis_en_vente ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .frame(width: 160, height: 165)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}
