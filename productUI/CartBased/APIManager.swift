import Foundation

class APIManager {
    static let shared = APIManager()
    private init() {}

    let baseURL = "http://localhost:3000" // Replace with your backend URL
    
    
    func fetchCart(userId: Int, completion: @escaping (Result<CartResponse?, Error>) -> Void) {
           let url = URL(string: "\(baseURL)/cart/\(userId)")!
           var request = URLRequest(url: url)
           request.httpMethod = "GET"

           URLSession.shared.dataTask(with: request) { data, response, error in
               
               if let error = error {
                   completion(.failure(error))
                   return
               }
               
               guard let data = data else {
                   completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                   return
               }
               
               
               do {
                   let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                   print("Json Response: \(jsonResponse)")
                   let response = try? JSONDecoder().decode(CartResponse.self, from: data) as CartResponse
                   completion(.success(response ?? nil))
               } catch {
                   completion(.failure(error))
               }
           }.resume()
       }
    

    func addToCart(userId: Int, productIds: [Int], completion: @escaping (Result<CartResponse, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/cart/addToCart")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["user": userId, "products": productIds]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("Json Response: \(jsonResponse)")
                let response = try JSONDecoder().decode(CartResponse.self, from: data) 
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func purchaseCart(userId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/cart/purchase/\(userId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }.resume()
    }
}
