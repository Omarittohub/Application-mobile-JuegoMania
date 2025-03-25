struct BilanVendeurSession: Codable {
    var totalDepots: Int
    var totalVentes: Int
    var totalStocks: Int
    var totalGains: Double
    var totalCommissions: Double

    enum CodingKeys: String, CodingKey {
        case totalDepots = "total_depots"
        case totalVentes = "total_ventes"
        case totalStocks = "total_stocks"
        case totalGains = "total_gains"
        case totalCommissions = "total_comissions"
    }
}
