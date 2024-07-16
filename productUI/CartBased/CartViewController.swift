import UIKit
//TODO:  User defaultsta tokenı tut. Login ekranında eğer userdefaults içerisinde token varsa login ekranını direk geç

class CartViewController: UIViewController {
    
    let tableView = UITableView()
    let buyButton = UIButton(type: .system)
    let totalPriceLabel = UILabel()
    let emptyLabel = UILabel()
    
    var products: [CartProductResponse]
    
    init(products: [CartProductResponse]) {
        self.products = products
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        title = "Cart"
        
        setupTableView()
        setupTotalPriceLabel()
        setupBuyButton()
        layout()
//        fetchCart()
        
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        self.emptyLabel.text = "Sepetiniz boş"
        self.tableView.backgroundView = self.emptyLabel
        tableView.backgroundView?.isHidden = true
        tableView.register(CartCell.self, forCellReuseIdentifier: "CartCell")
        self.view.addSubview(tableView)
    }
    
    private func setupBuyButton() {
        buyButton.setTitle("Buy", for: .normal)
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(buyButton)
    }
    private func setupTotalPriceLabel() {
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        totalPriceLabel.textAlignment = .center
        totalPriceLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.view.addSubview(totalPriceLabel)
    }
    
    
    private func layout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -20),
            
            totalPriceLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            totalPriceLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            totalPriceLabel.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -10),
            totalPriceLabel.heightAnchor.constraint(equalToConstant: 30),
            
            
            buyButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            buyButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            buyButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
//    private func fetchCart() {
//           let userId = 1
//           APIManager.shared.fetchCart(userId: userId) { result in
//               DispatchQueue.main.async {
//                   switch result {
//                   case .success(let response):
//                       self.products = response?.userCart.products ?? []
//                       if let totalPrice = response?.totalPrice {
//                           self.totalPriceLabel.text = "Total Price: \(totalPrice) $"
//                       } else {
//                           self.totalPriceLabel.text = "Total Price: 0 $"
//                       }
//                       self.tableView.reloadData()
//                   case .failure(let error):
//                       let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//                       alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                       self.present(alert, animated: true, completion: nil)
//                   }
//               }
//           }
//       }
    
    @objc private func buyButtonTapped() {
        
        APIManager.shared.purchaseCart(userId: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.products.removeAll()
                let alert = UIAlertController(title: "Purchase", message: "Thank you for your purchase!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.tableView.reloadData()
                    self.totalPriceLabel.text = "0$"
                }))
            case .failure(let failure):
                let alert = UIAlertController(title: "Error", message: "Something went wrong!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.tableView.reloadData()
                    self.totalPriceLabel.text = "0$"
                }))
            }
        }
    }
}
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
//        let product = products[indexPath.row]
//        cell.configure(with: product.name,
//                       details: (price: product.price,
//                                 count: products.count, image: product.image))
//        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 // Set the height you want for each cell
    }
}
extension CartViewController: CartCellDelegate {
    func didUpdateQuantity(for product: String, increase: Bool) {
        print("Updated.")
    }
    
}
