import UIKit

class VegetableCell: UICollectionViewCell {
    let vegetableImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let vegetableLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0 // Allow multiple lines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Adding shadow and border
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        
        contentView.addSubview(vegetableImageView)
        contentView.addSubview(vegetableLabel)
        contentView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            
        
            vegetableImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            vegetableImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            vegetableImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            vegetableImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            
            vegetableLabel.topAnchor.constraint(equalTo: vegetableImageView.bottomAnchor, constant: 10),
            vegetableLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            vegetableLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            addButton.topAnchor.constraint(equalTo: vegetableLabel.bottomAnchor, constant: 10),
            addButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 40),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10) // Ensure button is not clipped
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
