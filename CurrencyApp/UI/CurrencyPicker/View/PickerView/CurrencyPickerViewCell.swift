//
//  CurrencyPickerViewCell.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 24.11.2025.
//

import UIKit

class CurrencyPickerViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CurrencyPickerViewCell"
    
    private var selectedColor: UIColor = .label
    private var deselectedColor: UIColor = .label.withProminence(.secondary)
    
    private let attributeStack = UIStackView()
    private let codeLabel = UILabel()
    private let segment = UIView()
    private var segmentWidthConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for currency: Currency,
                   selectedColor: UIColor,
                   deselectedColor: UIColor,
                   direction: CurrencyPickerDirection) {
        
        codeLabel.text = currency.code
        
        self.selectedColor = selectedColor
        self.deselectedColor = deselectedColor
        
        setSelection(to: false)
        self.setDirection(to: direction)
    }
    
    func setSelection(to selected: Bool) {
        codeLabel.textColor = selected ? selectedColor : deselectedColor
        segment.backgroundColor = selected ? selectedColor : deselectedColor
        segmentWidthConstraint?.constant = selected ? 10 : 5
        attributeStack.spacing = selected ? 7 : 2
        
        UIView.animate(withDuration: 0.2) {
            self.codeLabel.transform = selected ? CGAffineTransform(scaleX: 1.2, y: 1.2) : .identity
            self.layoutIfNeeded()
        }
    }
    
    func setDirection(to direction: CurrencyPickerDirection) {
        if !attributeStack.arrangedSubviews.isEmpty {
            
            attributeStack.arrangedSubviews.forEach {
                attributeStack.removeArrangedSubview($0)
            }
        }
        
        switch direction {
        case .leftToRight:
            attributeStack.addArrangedSubview(segment)
            attributeStack.addArrangedSubview(codeLabel)
            attributeStack.addArrangedSubview(UIView())
        case .rightToLeft:
            attributeStack.addArrangedSubview(UIView())
            attributeStack.addArrangedSubview(codeLabel)
            attributeStack.addArrangedSubview(segment)
        }
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        codeLabel.font = .preferredFont(forTextStyle: .headline)
        
        segmentWidthConstraint = segment.widthAnchor.constraint(equalToConstant: 5)
        segmentWidthConstraint?.isActive = true
        segment.heightAnchor.constraint(equalToConstant: 2).isActive = true
        segment.layer.cornerRadius = 1
        
        attributeStack.axis = .horizontal
        attributeStack.spacing = 2
        attributeStack.alignment = .center
        
        contentView.addSubview(attributeStack)
        attributeStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            attributeStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            attributeStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            attributeStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
}
