import Foundation

struct GameDeposit {
    var gameName: String = ""
    var unitPriceString: String = "0"
    var quantityString: String = "0"

    var unitPrice: Double {
        return Double(unitPriceString) ?? 0
    }

    var quantity: Int {
        return Int(quantityString) ?? 0
    }
}
