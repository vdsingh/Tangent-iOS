//
//  TAFilterView.swift
//  Tangent
//
//  Created by Vikram Singh on 4/25/23.
//

import Foundation
import UIKit

//TODO: Docstrings
class TAFilterButtonView: UIView, Debuggable {
    
    let debug = true
    
    //TODO: Docstrings
    let controller: UIViewController
    
    //TODO: Docstrings
    let filterState: TAFilterState
    
    //TODO: Docstrings
    let filterButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .systemBackground
        return button
    }()
    
    //TODO: Docstrings
    init(filterState: TAFilterState, controller: UIViewController) {
        self.controller = controller
        self.filterState = filterState
        super.init(frame: .zero)
        self.setUIProperties()
        self.addSubviewsAndEstablishConstraints()
    }
    
    //TODO: Docstrings
    private func setUIProperties() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.filterButton.setTitle("   \(self.filterState.displayString)   ", for: .normal)
        self.filterButton.addTarget(self, action: #selector(showDropdown), for: .touchUpInside)
    }
    
    //TODO: Docstrings
    @objc private func showDropdown() {
        let selectionVC = TAFilterViewController(filterState: self.filterState)
        selectionVC.view.backgroundColor = .systemBackground
        let nav = UINavigationController(rootViewController: selectionVC)

        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
        }

        self.controller.present(nav, animated: true)
    }
    
    //TODO: Docstrings
    private func addSubviewsAndEstablishConstraints() {
        self.addSubview(self.filterButton)
        
        NSLayoutConstraint.activate([
            self.filterButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.filterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.filterButton.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.filterButton.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
    
    //TODO: Docstrings
    func refreshView() {
        self.printDebug("Refreshing Filter View for option \(self.filterState.filterOption)")
        self.setUIProperties()
    }
    
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (TAFilterView): \(message)")
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
