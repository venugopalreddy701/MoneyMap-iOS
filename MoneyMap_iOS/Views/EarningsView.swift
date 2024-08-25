//
//  EarningsView.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 04/04/24.
//

import UIKit

final class EarningsView: UIView {
    
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
        imageView.image = UIImage(systemName: "arrow.up")
        imageView.tintColor = .black
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 0.705, green: 0.929, blue: 0.658, alpha: 1.0) // Light green
        
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
