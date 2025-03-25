import Foundation

struct GameItem: Identifiable, Codable {
    let id: Int
    let name: String
    let sellerID: Int
    var sellerName: String = "Unknown Seller"
    let price: Double
    let quantityAvailable: Int
    var isOnSale: Bool

    enum CodingKeys: String, CodingKey {
        case id = "JeuID"
        case price = "prix_unitaire"
        case quantityAvailable = "quantite_disponible"
        case isOnSale = "mise_en_vente"
        case depot
        case jeuxMarque
    }

    struct DepotInfo: Codable {
        let VendeurID: Int
    }

    struct JeuxMarqueInfo: Codable {
        let Nom: String
    }

    let depot: DepotInfo
    let jeuxMarque: JeuxMarqueInfo

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        price = try container.decode(Double.self, forKey: .price)
        quantityAvailable = try container.decode(Int.self, forKey: .quantityAvailable)
        isOnSale = try container.decode(Bool.self, forKey: .isOnSale)
        
        depot = try container.decode(DepotInfo.self, forKey: .depot)
        jeuxMarque = try container.decode(JeuxMarqueInfo.self, forKey: .jeuxMarque)
        
        sellerID = depot.VendeurID
        name = jeuxMarque.Nom
    }
}
