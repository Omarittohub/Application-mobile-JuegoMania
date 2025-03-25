
struct DashboardData: Codable {
    let popularGames: [PopularGame]
    let salesSummary: [SalesSummary]
    let depositSummary: [DepositSummary]
    let jeuxStockes, jeuxVendues, jeuxInvendus: Int
}

struct PopularGame: Codable, Identifiable {
    var id: Int { JeuID }
    let JeuID: Int
    let JeuRef_id: Int
    let depot_ID: Int
    let prix_unitaire: Int
    let mise_en_vente: Bool
    let quantite_disponible: Int
    let jeuxMarque: JeuxMarque
}

struct JeuxMarque: Codable {
    let JeuRef_id: Int
    let Nom, Editeur, Description: String
}

struct SalesSummary: Codable {
    let AchatID: Int
    let Total_paye: Double
    let id_session: Int
    let comission_vente_total: Double
    let DateAchat: String
}

struct DepositSummary: Codable {
    let ID_depot: Int
    let VendeurID: Int
    let id_session: Int
    let comission_depot_total: Double
    let date_depot: String
}
