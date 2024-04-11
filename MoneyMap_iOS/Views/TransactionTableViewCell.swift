//
//  TransactionTableViewCell.swift
//  MoneyMap_iOS
//
//  Created by Venugopal on 06/04/24.
//

import UIKit

class TransactionTableViewCell : UITableViewCell {
    
    static let identifier = "TransactionTableViewCell"
    
    private let titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    private let subtitleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.textColor = .lightGray
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    private let amountLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let dateLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
                contentView.addSubview(subtitleLabel)
                contentView.addSubview(amountLabel)
                contentView.addSubview(dateLabel)
                applyConstraints()
    }
    
    private func applyConstraints() {
           NSLayoutConstraint.activate([
               // Title Label Constraints
               titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
               titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
               
               // Subtitle Label Constraints
               subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
               subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
               subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
               
               // Amount Label Constraints
               amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
               amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
               
               // Date Label Constraints
               dateLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 4),
               dateLabel.trailingAnchor.constraint(equalTo: amountLabel.trailingAnchor),
               dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
           ])
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure cell with text for labels
    func configure(with title: String, subtitle: TransactionType, amount: String, date: String) {
            titleLabel.text = title
            subtitleLabel.text = subtitle.rawValue
            dateLabel.text = date
        if subtitle.rawValue == TransactionType.spent.rawValue {
            amountLabel.textColor = .systemRed
            amountLabel.text = "-$"+amount
        }
        else
        {
            amountLabel.text = "+$"+amount
            amountLabel.textColor = .systemGreen
        }
        
        }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            titleLabel.text = nil
            subtitleLabel.text = nil
            amountLabel.text = nil
            dateLabel.text = nil
        }
    
    
}
