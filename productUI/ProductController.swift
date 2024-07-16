import UIKit

class ProductController: UIViewController {
    
    var type: FoodType
    var products: [Product] = []
    var filteredProducts: [Product] = []
    
    var cartCount = 0
    let cartButton = UIButton(type: .system)
    let cartButtonView = UIView()
    let cartImageView = UIImageView(image: UIImage(systemName: "cart"))
    let cartCountLabel = UILabel()
    
    var cartProducts: [CartProductResponse] = []
    
    
    init(type: FoodType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let searchBar = UISearchBar()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    
        setupSearchBar()
        setupCollectionView()
        setupCartButton()
        layout()
        fetchProducts()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search products"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchBar)
    }
    
    private func setupCartButton() {
        cartButtonView.backgroundColor = .clear
        cartButtonView.isUserInteractionEnabled = true
        cartButtonView.translatesAutoresizingMaskIntoConstraints = false
        cartButtonView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        cartButtonView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        cartImageView.translatesAutoresizingMaskIntoConstraints = false
        cartImageView.image = UIImage(systemName: "cart")
        cartImageView.tintColor = .systemBlue
        cartImageView.isUserInteractionEnabled = true
        cartImageView.contentMode = .scaleAspectFit
        
        cartCountLabel.text = "\(cartCount)"
        cartCountLabel.font = UIFont.systemFont(ofSize: 14)
        cartCountLabel.textColor = .white
        cartCountLabel.backgroundColor = .systemRed
        cartCountLabel.textAlignment = .center
        cartCountLabel.layer.cornerRadius = 10
        cartCountLabel.clipsToBounds = true
        cartCountLabel.isUserInteractionEnabled = true
        cartCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(cartButtonView)
        self.cartButtonView.addSubview(cartImageView)
        self.cartButtonView.addSubview(cartCountLabel)
        
        NSLayoutConstraint.activate([
            cartImageView.centerXAnchor.constraint(equalTo: cartButtonView.centerXAnchor),
            cartImageView.centerYAnchor.constraint(equalTo: cartButtonView.centerYAnchor),
            cartImageView.widthAnchor.constraint(equalToConstant: 24),
            cartImageView.heightAnchor.constraint(equalToConstant: 24),
            
            cartCountLabel.leadingAnchor.constraint(equalTo: cartImageView.trailingAnchor, constant: -10),
            cartCountLabel.centerYAnchor.constraint(equalTo: cartImageView.topAnchor, constant: 5),
            cartCountLabel.widthAnchor.constraint(equalToConstant: 20),
            cartCountLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cartButtonTapped))
        cartButtonView.addGestureRecognizer(tapGesture)
        
        let cartButton = UIBarButtonItem(customView: cartButtonView)
        navigationItem.rightBarButtonItem = cartButton
    }
    
    @objc private func cartButtonTapped(_ sender: UITapGestureRecognizer? = nil) {
        let cartVC = CartViewController(products: cartProducts)
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
    private func updateCartButton() {
        cartCount += 1
        cartCountLabel.text = "\(cartCount)"
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(VegetableCell.self, forCellWithReuseIdentifier: "VegetableCell")
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16)
        ])
    }
    private func fetchProducts() {
        guard let url = URL(string: "http://localhost:3000/products/getProductsByType/\(type.id)") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let fetchedProducts = try JSONDecoder().decode([Product].self, from: data)
                DispatchQueue.main.async {
                    self.products = fetchedProducts
                    self.filteredProducts = fetchedProducts
                    self.collectionView.reloadData()
                }
            } catch let jsonError {
                print("Failed to decode JSON:", jsonError)
            }
        }.resume()
    }
}
extension ProductController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VegetableCell", for: indexPath) as! VegetableCell
        let product = filteredProducts[indexPath.row]
       
        // Load image from URL
        if let url = URL(string: product.image) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        print("Data :\(data)")
                        cell.vegetableImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        
        // Create an attributed string for the product name and price
        let attributedText = NSMutableAttributedString(
            string: "\(product.name)\n",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 14),
                .foregroundColor: UIColor.black
            ]
        )
        
        let priceString = NSAttributedString(
            string: "\(product.price) $",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.darkGray
            ]
        )
        
        attributedText.append(priceString)
        
        cell.vegetableLabel.attributedText = attributedText
        cell.addButton.addTarget(self, action: #selector(addToCartTapped(_:)), for: .touchUpInside)
        cell.addButton.tag = indexPath.row
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 30) / 2
        return CGSize(width: width, height: width * 1.5) // Adjust the height as needed
    }
    
    @objc private func addToCartTapped(_ sender: UIButton) {
            let product = filteredProducts[sender.tag]
            APIManager.shared.addToCart(userId: 1, productIds: [product.id]) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    cartProducts = response.cart.cartProducts
                    DispatchQueue.main.async { self.updateCartButton() }
                case .failure(let error):
                    print("Failed to add \(product.name) to cart: \(error.localizedDescription)")
                }
            }
        }
    }
extension ProductController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredProducts = searchText.isEmpty ? products : products.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        collectionView.reloadData()
    }
}
