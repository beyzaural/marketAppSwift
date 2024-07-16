//class CartManager {
//    static let shared = CartManager()
//    private init() {}
//    
//    var products: [String: (price: Double, count: Int, image: String,id: Int)] = [:]
//    var userId: Int = 1 // Assume a logged-in user with ID 1
//    
//    var cartCount: Int {
//        return products.values.reduce(0) { $0 + $1.count }
//    }
//    
//    func updateCart(with cart: [String: (price: Double, count: Int, image: String, id: Int)]) {
//            self.products = cart
//        }
//    
//    func addProduct(name: String, price: Double, image: String, id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
//            if let product = products[name] {
//                products[name] = (price, product.count + 1, image, id)
//            } else {
//                products[name] = (price, 1, image, id)
//            }
//
//            let productIds = products.values.flatMap { Array(repeating: $0.id, count: $0.count) }
//            APIManager.shared.addToCart(userId: userId, productIds: productIds, completion: completion)
//        }
//
//    
//    func removeProduct(name: String) {
//           if let product = products[name], product.count > 1 {
//               products[name] = (product.price, product.count - 1, product.image, product.id)
//           } else {
//               products.removeValue(forKey: name)
//           }
//       }
//    
//    func clearCart(completion: @escaping (Result<Void, Error>) -> Void) {
//           products.removeAll()
//           APIManager.shared.purchaseCart(userId: userId, completion: completion)
//       }
//}
