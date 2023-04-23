//
//  File.swift
//  Tangent
//
//  Created by Vikram Singh on 4/20/23.
//

import Foundation
import UIKit

//TODO: Docstrings, separate

//struct TAFilter {
//    let filterType: TAFilterType
//    let uiString: String
//    let choices: [
//
//    ]
//}

enum TAFilter {
    case price(uiString: String)
    case businessType(uiString: String)
}

class TAFilterView: UIView {
    
    let controller: UIViewController
    
    let filterButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.titleLabel?.text = "HELLO"
        button.setTitle("HELLO", for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 15
        return button
    }()
    
    init(filter: TAFilter, controller: UIViewController) {
        self.controller = controller
        super.init(frame: .zero)
        self.setUIProperties(filter: filter)
        self.addSubviewsAndEstablishConstraints()
    }
    
    private func setUIProperties(filter: TAFilter) {
        self.translatesAutoresizingMaskIntoConstraints = false
//        self.backgroundColor = .brown
        switch filter {
        case .price(let uiString):
            self.filterButton.setTitle(uiString, for: .normal)
            self.filterButton.addTarget(self, action: #selector(showDropdown), for: .touchUpInside)
        case .businessType(let uiString):
            self.filterButton.setTitle(uiString, for: .normal)
        }
    }
    
    @objc private func showDropdown() {
        let selectionVC = UIViewController()
        //        let detailViewController = DetailViewController()
        selectionVC.view.backgroundColor = .systemBackground
        let nav = UINavigationController(rootViewController: selectionVC)
        // 1
        nav.modalPresentationStyle = .pageSheet
        
        
        // 2
        if let sheet = nav.sheetPresentationController {
            
            // 3
            sheet.detents = [.medium(), .large()]
            
        }
        // 4
        self.controller.present(nav, animated: true)
//        self.present(nav, animated: true, completion: nil)
    }
    
    private func addSubviewsAndEstablishConstraints() {
        self.addSubview(self.filterButton)
        
        NSLayoutConstraint.activate([
            self.filterButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.filterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.filterButton.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.filterButton.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}

class TAFiltersView: UIStackView {
    let controller: UIViewController
    
    init(filters: [TAFilter], controller: UIViewController) {
        self.controller = controller
        super.init(frame: .zero)
        self.setUIProperties()
        
        let filterViews = self.createFilterViews(filters: filters)
        self.addSubviewsAndEstablishConstraints(filterViews: filterViews)
    }
    
    private func createFilterViews(filters: [TAFilter]) -> [TAFilterView] {
        return filters.compactMap({ TAFilterView(filter: $0, controller: self.controller) })
    }
    
    private func setUIProperties() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.distribution = .fillProportionally
        self.spacing = 10
    }
    
    private func addSubviewsAndEstablishConstraints(filterViews: [TAFilterView]) {
        for filterView in filterViews {
            self.addArrangedSubview(filterView)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
}
