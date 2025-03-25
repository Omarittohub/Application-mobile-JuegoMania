import SwiftUI

struct AdminPanelView: View {
    @StateObject private var viewModel = AdminPanelViewModel()
    
    @State private var managerName: String = ""
    @State private var managerFirstName: String = ""
    @State private var managerEmail: String = ""
    @State private var managerPassword: String = ""
    @State private var activeSessionName: String = ""
    @State private var commission: String = ""
    @State private var fraisDepot: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text("Welcome to the Admin Dashboard")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    
                    if let activeSession = viewModel.activeSession {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Session Active")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 5)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(activeSession.nomSession)
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Text("Commission: \(activeSession.commission, specifier: "%.2f")%")
                                    .font(.subheadline)
                                
                                Text("Frais de Dépôt: \(activeSession.fraisDepot, specifier: "%.2f")%")
                                    .font(.subheadline)
                                
                                Text("Date de Début: \(activeSession.dateDebut)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                Text("Statut: \(activeSession.statut ? "Active" : "Inactive")")
                                    .font(.subheadline)
                                    .foregroundColor(activeSession.statut ? .green : .red)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2))

                            Button(action: viewModel.closeSession) {
                                Text("Fermer la Session")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                            }
                            .padding(.top, 5)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15)
                            .fill(Color(.systemGray6))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2))
                        .padding(.horizontal)
                    } else {
                        Text("Aucune session active.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding()
                    }

                    // Session Management Section
                    VStack(spacing: 12) {
                        TextField("Nom de la Session", text: $activeSessionName)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                            .padding(.horizontal)

                        TextField("Commission (%)", text: $commission)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                            .keyboardType(.decimalPad)
                            .padding(.horizontal)

                        TextField("Frais de Dépôt (%)", text: $fraisDepot)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                            .keyboardType(.decimalPad)
                            .padding(.horizontal)

                        Button(action: {
                            guard let commissionValue = Double(commission),
                                  let fraisDepotValue = Double(fraisDepot) else {
                                viewModel.errorMessage = "Please enter valid numeric values."
                                return
                            }
                            viewModel.createSession(name: activeSessionName, commission: commissionValue, fraisDepot: fraisDepotValue)
                            activeSessionName = ""
                            fraisDepot = ""
                            commission = ""
                        }) {
                            Text("Créer une Nouvelle Session")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                        .padding(.top, 5)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2))
                    .padding(.horizontal)

                    // Session History Section
                    VStack(alignment: .leading) {
                        Text("Historique des Sessions")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top, 10)

                        if viewModel.sessionHistory.isEmpty {
                            Text("Aucune session enregistrée.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        } else {
                            ForEach(viewModel.sessionHistory, id: \.nomSession) { session in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(session.nomSession)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text("Commission: \(session.commission, specifier: "%.2f")%")
                                        .font(.subheadline)

                                    Text("Frais de Dépôt: \(session.fraisDepot, specifier: "%.2f")%")
                                        .font(.subheadline)
                                    
                                    Text("Date de Début: \(session.dateDebut)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)

                                    Text("Statut: \(session.statut ? "Active" : "Inactive")")
                                        .font(.subheadline)
                                        .foregroundColor(session.statut ? .green : .red)
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2))
                                .padding(.horizontal)
                                .padding(.bottom, 10)
                            }
                        }
                    }
                    
                    if let error = viewModel.errorMessage {
                        Text("Erreur: \(error)")
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("Admin Dashboard")
            .onAppear {
                viewModel.fetchSessions()
                viewModel.fetchActiveSession()
            }
        }
    }
}
