import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Festival des jeux")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .padding(.top, 40)
                    
                  
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(MenuItem.allCases, id: \.self) { item in
                                NavigationLink(destination: item.destination) {
                                    HStack {
                                        Image(systemName: item.icon)
                                            .foregroundColor(.secondary)
                                            .imageScale(.large)
                                            .frame(width: 40)

                                        Text(item.rawValue)
                                            .font(.system(size: 20, weight: .medium, design: .rounded))
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color(.systemBackground))
                                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2))
                                    .padding(.horizontal, 20)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.top, 20)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
        
    }
}

enum MenuItem: String, CaseIterable {
    case Dashboard, Stocks, Jeux, Achats, Vendeur, Rapports, Admin
    
    var destination: some View {
        switch self {
        case .Dashboard: return AnyView(DashboardView())
        case .Stocks: return AnyView(StocksView())
        case .Jeux: return AnyView(GamesView())
        case .Achats: return AnyView(AchatView())
        case .Vendeur: return AnyView(VendeurView())
        case .Rapports: return AnyView(RapportsView())
        case .Admin: return AnyView(AdminView())
        }
    }
    
  
    var icon: String {
        switch self {
        case .Dashboard: return "chart.bar.fill"
        case .Stocks: return "shippingbox.fill"
        case .Jeux: return "gamecontroller.fill"
        case .Achats: return "cart.fill"
        case .Vendeur: return "person.3.fill"
        case .Rapports: return "doc.text.fill"
        case .Admin: return "gearshape.fill"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
