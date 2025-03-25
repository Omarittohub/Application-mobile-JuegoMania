import Foundation

struct Depot: Identifiable, Codable {
    let id: Int
    let sessionId: Int
    let vendeur: VendeurDetails

    var vendeurNom: String {
        return vendeur.nom
    }

    enum CodingKeys: String, CodingKey {
        case id = "ID_depot"
        case sessionId = "id_session"
        case vendeur
    }
}
