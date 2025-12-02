//
//  СurrencyPickerView.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 24.11.2025.
//

import UIKit

class CurrencyPickerView: UIView {
    
    var currencies = [Currency]()
    
    var configuration: CurrencyPickerConfiguration
    
    private let tableView = UITableView()
    
    init(configuration: CurrencyPickerConfiguration) {
        self.configuration = configuration
        
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupTableView()
        setupPointerView()
        setupTextField()
        applyShadow()
    }
    
    private func setupTableView() {
        
        tableView.backgroundColor = configuration.pickerColor
        tableView.rowHeight = configuration.cellHeight
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CurrencyPickerViewCell.self, forCellReuseIdentifier: CurrencyPickerViewCell.reuseIdentifier)
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupPointerView() {
        
        let pointerView = UIView()
        pointerView.backgroundColor = .clear
        
        let shape = CAShapeLayer()

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: configuration.cellHeight / 7, y: configuration.cellHeight / 2))
        path.addLine(to: CGPoint(x: 0, y: configuration.cellHeight))
        path.close()
        
        shape.path = path.cgPath
        shape.fillColor = configuration.pickerColor.cgColor
        
        pointerView.layer.addSublayer(shape)
        
        addSubview(pointerView)
        pointerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pointerView.leadingAnchor.constraint(equalTo: trailingAnchor),
            pointerView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -(configuration.cellHeight / 2))
        ])
    }
    
    private func setupTextField() {
        
        let textField = UITextField()
        
        textField.font = .preferredFont(forTextStyle: .extraLargeTitle)
        textField.textColor = .white
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        textField.backgroundColor = .white.withAlphaComponent(0.2)
        textField.layer.cornerRadius = (configuration.cellHeight / 2.5) / 2
        textField.adjustsFontSizeToFitWidth = true
        
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.heightAnchor.constraint(equalToConstant: configuration.cellHeight / 2.5),
            textField.widthAnchor.constraint(lessThanOrEqualToConstant: configuration.cellHeight),
            textField.widthAnchor.constraint(greaterThanOrEqualToConstant: configuration.cellHeight / 2.5),
        ])
    }
    
    private func applyShadow() {
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 2, height: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let inset = (tableView.bounds.height - tableView.rowHeight) / 2
        tableView.contentInset = UIEdgeInsets(top: inset - safeAreaInsets.top,left: 0, bottom: inset - safeAreaInsets.bottom, right: 0)
        
        selectCellWithScroll()
    }

    
    private func selectCellWithScroll() {

        let center = CGPoint(x: tableView.bounds.midX, y: tableView.bounds.midY)
        
        guard let nextSelectedRowIndexPath = tableView.indexPathForRow(at: center) else { return }
        
        if let previousSelectedRowIndexPath = tableView.indexPathForSelectedRow {
            
            tableView.deselectRow(at: previousSelectedRowIndexPath, animated: true)
            tableView.delegate?.tableView?(tableView, didDeselectRowAt: previousSelectedRowIndexPath)
        }
        
        tableView.selectRow(at: nextSelectedRowIndexPath, animated: true, scrollPosition: .none)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: nextSelectedRowIndexPath)
    }
}

extension CurrencyPickerView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyPickerViewCell.reuseIdentifier, for: indexPath) as? CurrencyPickerViewCell else { return UITableViewCell() }
        
        cell.configure(for: currencies[indexPath.row],
                       selectedColor: configuration.selectedAttributesColor,
                       deselectedColor: configuration.deselectedAttributesColor,
                       direction: configuration.direction)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? CurrencyPickerViewCell
        cell?.setSelection(to: true)
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
        
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? CurrencyPickerViewCell
        cell?.setSelection(to: false)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            selectCellWithScroll()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        selectCellWithScroll()
    }
}
