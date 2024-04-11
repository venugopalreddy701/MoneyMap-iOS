//
//  SpentView.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 04/04/24.
//

import UIKit

class SpentView: UIView {
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "arrow.down")
        imageView.tintColor = .black
        return imageView
    }()
    
    init(amount: String) {
        super.init(frame: .zero)
        setupView()
        amountLabel.text = amount
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0) // Light red
        
        addSubview(amountLabel)
        addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            amountLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.leadingAnchor.constraint(equalTo: amountLabel.trailingAnchor, constant: 10)
        ])
    }
    
    func setAmount(_ amount : Int)
    {
        amountLabel.text = "$" + String(amount)
    }
    
}

