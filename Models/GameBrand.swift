struct GameBrand: Identifiable, Codable {
    let id: Int
    var name: String

    enum CodingKeys: String, CodingKey {
        case id = "JeuRef_id"
        case name = "Nom"
    }
}
