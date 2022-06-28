//
//  CustomCollectionViewCell.swift
//  LoginAppNew
//
//  Created by Shabuddin on 22/05/22.
//

import Foundation
import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomCollectionViewCell"

    
    
    private let seperatorView: UIView = {
        let seperatorView = UILabel()
        return seperatorView
    }()
    
    private let titleLabel: UILabel = {
        let labelView = UILabel()
        return labelView
    }()
    
    private let descriptionLabel: UILabel = {
        let labelView = UILabel()
        return labelView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureCell()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
    
        super.layoutSubviews()
        
        let inset = CGFloat(15)
        
        NSLayoutConstraint.activate([
       
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -inset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: inset),
            descriptionLabel.bottomAnchor.constraint(equalTo: seperatorView.topAnchor,constant: -inset),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            
            seperatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            seperatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            seperatorView.heightAnchor.constraint(equalToConstant: 0.8)
        ])
    }
    
    // different label on each cell
    
    public func configure(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = nil
        titleLabel.text = nil
    }
}

extension CustomCollectionViewCell {
    func configureCell() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        contentView.addSubview(titleLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.adjustsFontForContentSizeCategory = true
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        contentView.addSubview(descriptionLabel)
        
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        seperatorView.backgroundColor = .darkGray
        contentView.addSubview(seperatorView)
        
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        
    }
}
