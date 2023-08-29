//
//  JokeTableViewCell.swift
//  RandomGeekJoke
//
//  Created by Sajal Gupta on 29/08/23.
//

import UIKit

final class JokeTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
       let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        return titleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addArrangeViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addArrangeViews() {
       
        let mainVStack = UIStackView(arrangedSubviews: [titleLabel])
        
        mainVStack.axis = .vertical
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainVStack)
        
        NSLayoutConstraint.activate([
            mainVStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            mainVStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            mainVStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8),
            mainVStack.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
    }
}

