import SwiftUI
import Charts

struct RapportsView: View {
    @StateObject private var viewModel = RapportsViewModel()
    @State private var selectedVendeur: String = ""
    @State private var selectedSession: String = ""
    @State private var showBilan = false
    
    var body: some View {
        NavigationView {
            ScrollView { // Enable scrolling for the entire view
                VStack(spacing: 20) {
                    
                    // Vendeur Picker
                    Section(header: Text("Sélectionnez un Vendeur")) {
                        if viewModel.vendeurs.isEmpty {
                            ProgressView("Chargement des vendeurs...")
                        } else {
                            Picker("Sélectionnez un Vendeur", selection: $selectedVendeur) {
                                ForEach(viewModel.vendeurs, id: \.id) { vnd in
                                    Text("\(vnd.id) - \(vnd.name)").tag("\(vnd.id)")
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                        }
                    }
                    
                    // Session Picker
                    Section(header: Text("Sélectionnez une Session")) {
                        if viewModel.sessions.isEmpty {
                            ProgressView("Chargement des sessions...")
                        } else {
                            Picker("Sélectionnez une Session", selection: $selectedSession) {
                                ForEach(viewModel.sessions, id: \.id) { session in
                                    Text("\(session.id) - \(session.name)").tag("\(session.id)")
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                        }
                    }
                    
                    Button(action: {
                        if let vendeurID = Int(selectedVendeur), let sessionID = Int(selectedSession) {
                            viewModel.fetchBilan(vendeurID: vendeurID, sessionID: sessionID)
                            showBilan = true
                        }
                    }) {
                        Text("Générer le Bilan")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .disabled(selectedVendeur.isEmpty || selectedSession.isEmpty)
                    
                    if showBilan, let bilan = viewModel.bilan {
                        
                        // Display Total Gains in a nice bubble
                        HStack {
                            Text("Total des Gains :")
                                .font(.headline)
                            Text(String(format: "%.2f €", bilan.totalGains))
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .padding(.top, 20)
                        
                        // Bar Graph
                        if #available(iOS 16.0, *) {
                            Chart {
                                BarMark(
                                    x: .value("Type", "Dépôts"),
                                    y: .value("Valeur", bilan.totalDepots)
                                )
                                .foregroundStyle(Color.blue)
                                
                                BarMark(
                                    x: .value("Type", "Ventes"),
                                    y: .value("Valeur", bilan.totalVentes)
                                )
                                .foregroundStyle(Color.green)
                                
                                BarMark(
                                    x: .value("Type", "Restant"),
                                    y: .value("Valeur", max(bilan.totalDepots - bilan.totalVentes, 0))
                                )
                                .foregroundStyle(Color.red)
                            }
                            .frame(height: 250)
                            .padding()
                        } else {
                            Text("Les graphiques nécessitent iOS 16.0 ou plus.")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Rapports")
            .onAppear {
                viewModel.fetchVendeurs()
                viewModel.fetchSessions()
            }
        }
    }
}


struct RapportsView_Previews: PreviewProvider {
    static var previews: some View {
        RapportsView()
    }
}
