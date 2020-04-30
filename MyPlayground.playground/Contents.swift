import Foundation

class VendingMachineProduct {
    var name: String
    var amount: Int
    var price: Double
    var cartao: String
    
    init(name: String, amount: Int, price: Double, cartao: String) {
        self.name = name
        self.amount = amount
        self.price = price
        self.cartao = cartao
    }
}

enum VendingMachineError: Error {
    case productNotFound
    case productUnavailable
    case produtcStuck
    case insufficientFunds
}

extension VendingMachineError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .productNotFound:
            return "num tem isso aqui não"
        case .productUnavailable:
            return "acabou isso ai"
        case .produtcStuck:
            return "o seu produto ficou preso"
        case .insufficientFunds:
            return "tá faltando dinheiro nisso ai"
        }
    }
}

public class VendingMachine {
    public var teste = 0
    private var estoque: [VendingMachineProduct]
    private var money: Double
    
    init(products: [VendingMachineProduct]) {
        self.estoque = products
        self.money = 0
    }
    
    func getProduct(named name: String, with money: Double) throws {
        self.money += money
        
        let produtoOptional = estoque.first { (produto) -> Bool in
            return produto.name == name
        }
        guard let produto = produtoOptional else { throw VendingMachineError.productNotFound }
        
        guard produto.amount > 0 else { throw VendingMachineError.productUnavailable }
        
        guard produto.price <= self.money else { throw VendingMachineError.insufficientFunds }
        
        
        self.money -= produto.price
        produto.amount -= 1
        
        if Int.random(in: 0...100) < 10 {
            throw VendingMachineError.produtcStuck
        }
    }
    
    func getTroco() -> Double {
        let money = self.money
        self.money = 0.0
        
        return money
    }

}
let vendingMachine = VendingMachine(products: [
    VendingMachineProduct(name: "Carregador de iPhone", amount: 5, price: 150.00, cartao: "Debito"),
    VendingMachineProduct(name: "Funnions", amount: 2, price: 7.00, cartao: "Credito"),
    VendingMachineProduct(name: "Xiaomi Umbrella", amount: 5, price: 125.00, cartao: "Credito"),
    VendingMachineProduct(name: "Trator", amount: 1, price: 75000.00, cartao: "Debito"),
    VendingMachineProduct(name: "MesaGamer", amount: 2, price: 7.00, cartao: "Debito")
])

do {
    try vendingMachine.getProduct(named: "MesaGamer", with: 15.0)
    try vendingMachine.getProduct(named: "Trator", with: 140.0)
    print("Parabéns")
} catch VendingMachineError.produtcStuck {
    print("Pedimos desculpas, mas houve um problema, o seu produto ficou preso.")
} catch {
    print(error.localizedDescription)
}



