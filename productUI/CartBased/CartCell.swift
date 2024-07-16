import UIKit

protocol CartCellDelegate: AnyObject {
    func didUpdateQuantity(for product: String, increase: Bool)
}

class CartCell: UITableViewCell {
    
    weak var delegate: CartCellDelegate?
    
    private let productImageView = UIImageView()
    private let productLabel = UILabel()
    private let quantityLabel = UILabel()
    private let priceLabel = UILabel()
    private let increaseButton = UIButton(type: .system)
    private let decreaseButton = UIButton(type: .system)
    
    private var productName: String?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with product: String, details: (price: Double, count: Int, image: String)) {
        self.productName = product
        productLabel.text = product
        priceLabel.text = "\(details.price) $"
        quantityLabel.text = "\(details.count)"
        
        if let url = URL(string: details.image) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.productImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
    
    private func setupViews() {
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.contentMode = .scaleAspectFit
        productImageView.layer.cornerRadius = 8
        productImageView.clipsToBounds = true
        
        productLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        
        productLabel.translatesAutoresizingMaskIntoConstraints = false
        productLabel.font = UIFont.boldSystemFont(ofSize: 18) // Bold and larger font
        productLabel.numberOfLines = 0
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont.systemFont(ofSize: 16) // Smaller font
        
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.font = UIFont.systemFont(ofSize: 16)
        
        increaseButton.setTitle("+", for: .normal)
        decreaseButton.setTitle("-", for: .normal)
        
        increaseButton.addTarget(self, action: #selector(increaseTapped), for: .touchUpInside)
        decreaseButton.addTarget(self, action: #selector(decreaseTapped), for: .touchUpInside)
        
        contentView.addSubview(productImageView)
        contentView.addSubview(productLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(increaseButton)
        contentView.addSubview(decreaseButton)
    }
    
    private func layoutViews() {
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.heightAnchor.constraint(equalToConstant: 80),
            
            productLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            productLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            productLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            priceLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            priceLabel.topAnchor.constraint(equalTo: productLabel.bottomAnchor, constant: 5),
            
            decreaseButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            decreaseButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            decreaseButton.widthAnchor.constraint(equalToConstant: 30),
            decreaseButton.heightAnchor.constraint(equalToConstant: 30),
            
            quantityLabel.trailingAnchor.constraint(equalTo: decreaseButton.leadingAnchor, constant: -10),
            quantityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            increaseButton.trailingAnchor.constraint(equalTo: quantityLabel.leadingAnchor, constant: -10),
            increaseButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            increaseButton.widthAnchor.constraint(equalToConstant: 30),
            increaseButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc private func increaseTapped() {
        if let productName = productName {
            delegate?.didUpdateQuantity(for: productName, increase: true)
        }
    }
    
    @objc private func decreaseTapped() {
        if let productName = productName {
            delegate?.didUpdateQuantity(for: productName, increase: false)
        }
    }
}
