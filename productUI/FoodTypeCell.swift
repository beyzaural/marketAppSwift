//
//  FoodTypeCell.swift
//  productUI
//
//  Created by Sena Beyza Ural on 26.06.2024.
//

import UIKit

class FoodTypeCell: UICollectionViewCell {
    let foodTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 0.2
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.contentView.layer.shadowRadius = 2
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(foodTypeLabel)
        
        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            foodTypeLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            foodTypeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            foodTypeLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            foodTypeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10)
        ])
        
        /*let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
             self.addGestureRecognizer(tapGesture)
             
             let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
             longPressGesture.minimumPressDuration = 0
             self.addGestureRecognizer(longPressGesture)
         */
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            contentView.backgroundColor = isHighlighted ? .systemCyan : .white
        }
    }
    
    //BURA EKLENİNCE BOZULUYOR NEDEN?
    
    
    /*@objc private func handleTap(_ gesture: UITapGestureRecognizer) {
           // This will be handled in the view controller
           if let collectionView = self.superview as? UICollectionView,
              let indexPath = collectionView.indexPath(for: self) {
               collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
           }
       }

       @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
           switch gesture.state {
           case .began, .changed:
               contentView.backgroundColor = .systemCyan
           case .ended, .cancelled:
               contentView.backgroundColor = .white
           default:
               break
           }
       }
     */
}
