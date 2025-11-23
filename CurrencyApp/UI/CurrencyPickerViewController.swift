//
//  CurrencyPickerViewController.swift
//  CurrencyApp
//
//  Created by Артём Сноегин on 22.11.2025.
//

import UIKit

class CurrencyPickerViewController: UIViewController {
    
    
    let pickerView = CurrencyPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickerView()
    }
    
    private func setupPickerView() {

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        pickerView.addGestureRecognizer(panGesture)
        
        view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: view.topAnchor),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc private func pan(_ sender: UIPanGestureRecognizer) {
        
       
        let translation = sender.translation(in: pickerView)

        switch sender.state {
        case .began:
            sender.setTranslation(.zero, in: pickerView)
            
        case .changed:
            let new = pickerView.pointerXPosition + translation.x
            pickerView.configuration.pointerXPosition = .custom(value: new)
            pickerView.updateUI(animated: true)
            if pickerView.pointerXPosition > (view.frame.width / 4) * 3 || pickerView.pointerXPosition < (view.frame.width / 4) {
                
                sender.state = .ended
            }
            sender.setTranslation(.zero, in: pickerView)
            

        case .ended:
            pickerView.configuration.pointerXPosition = .center
            pickerView.updateUI(animated: true)
            
        case .cancelled:
            pickerView.configuration.pointerXPosition = .center
            pickerView.updateUI(animated: true)

        default:
            break
        }
    }
}

#Preview {
    CurrencyPickerViewController()
}
