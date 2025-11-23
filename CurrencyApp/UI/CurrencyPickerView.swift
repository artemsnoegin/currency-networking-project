//
//  CurrencyPickerView.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 22.11.2025.
//

import UIKit

class CurrencyPickerView: UIView {
    
    var configuration: CurrencyPickerConfiguration
    
    private var primaryColor: UIColor {  configuration.primaryColor }
    private var secondaryColor: UIColor { configuration.secondaryColor.withAlphaComponent(0.8) }
    
    private var pointerHeight: CGFloat { configuration.pointerHeight }
    private var pointerWidth: CGFloat { configuration .pointerWidth }
    
    var pointerXPosition: CGFloat {
        
        switch configuration.pointerXPosition {
        case .center:
            return frame.width / 2
        case .left:
            return (frame.width / 2) + (frame.width / 5)
        case .right:
            return (frame.width / 2) - (frame.width / 5)
        case .custom(let value):
            return value
        }
    }
    
    var pointerYPosition: CGFloat {
        
        switch configuration.pointerYPosition {
        case .center:
            return (frame.height / 2)
        case .top:
            return (frame.height / 3)
        case .custom(let value):
            return value
        }
    }
    
    private var pointerXConstraint: NSLayoutConstraint?
    private var pointerYConstraint: NSLayoutConstraint?
    
    private let secondaryView = UIView()
    private let primaryView = UIView()
    
    init(configuration: CurrencyPickerConfiguration = DefaultCurrencyPickerConfiguration()) {
        self.configuration = configuration
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateUI(animated: false)
    }
    
    func updateUI(animated: Bool) {
 
        pointerXConstraint?.constant = pointerXPosition
        pointerYConstraint?.constant = pointerYPosition
        
        if animated {
            UIView.animate(springDuration: 0.3, bounce: 0.5, initialSpringVelocity: 0) {
                self.layoutIfNeeded()
            }
        }
        else {
            self.layoutIfNeeded()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        backgroundColor = .white
        
        setupSecondaryView()
        setupPrimaryView()
    }
    
    private func setupSecondaryView() {
        
        secondaryView.backgroundColor = secondaryColor.withAlphaComponent(0.8)
        
        addSubview(secondaryView)
        secondaryView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            secondaryView.topAnchor.constraint(equalTo: topAnchor),
            secondaryView.leadingAnchor.constraint(equalTo: leadingAnchor),
            secondaryView.trailingAnchor.constraint(equalTo: trailingAnchor),
            secondaryView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupPrimaryView() {
        
        primaryView.backgroundColor = primaryColor
        primaryView.layer.shadowRadius = 2
        primaryView.layer.shadowOpacity = 0.3
        primaryView.layer.shadowOffset = CGSize(width: 2, height: 0)
        
        addSubview(primaryView)
        primaryView.translatesAutoresizingMaskIntoConstraints = false
        
        pointerXConstraint = primaryView.trailingAnchor.constraint(equalTo: leadingAnchor, constant: pointerXPosition)
        pointerXConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: topAnchor),
            primaryView.leadingAnchor.constraint(equalTo: leadingAnchor),
            primaryView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let triangleView = UIView()
        
        let shape = CAShapeLayer()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: pointerWidth, y: pointerHeight / 2))
        path.addLine(to: CGPoint(x: 0, y: pointerHeight))
        path.close()
        
        shape.path = path.cgPath
        shape.fillColor = primaryColor.cgColor
        triangleView.layer.addSublayer(shape)
        
        primaryView.addSubview(triangleView)
        triangleView.translatesAutoresizingMaskIntoConstraints = false
        
        pointerYConstraint = triangleView.centerYAnchor.constraint(equalTo: primaryView.topAnchor, constant: pointerYPosition)
        pointerYConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            triangleView.leadingAnchor.constraint(equalTo: primaryView.trailingAnchor),
            triangleView.widthAnchor.constraint(equalToConstant: pointerWidth),
            triangleView.heightAnchor.constraint(equalToConstant: pointerHeight)
        ])
    }
}
