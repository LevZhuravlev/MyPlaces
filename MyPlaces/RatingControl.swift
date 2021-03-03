//
//  RatingControl.swift
//  MyPlaces
//
//  Created by Zhuravlev Lev on 23/04/2020.
//  Copyright © 2020 Zhuravlev Lev. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    // MARK: Properties
    
    // Текущее значение рейтинга
    var rating = 0 {didSet {updateButtonSelectionState()}}
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {didSet {setupButtons()}}
    
    @IBInspectable var starCount: Int = 5 {
        didSet {setupButtons()
        }
    }
    
    // Массив кнопок
    private var ratingButtons = [UIButton]()
    
    var isChanged = true


    
    // MARK: Initialization
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: Button action
    
    @objc func ratingButtonTapped(button: UIButton) {
        
        guard isChanged  else { return }
        
        guard let index = ratingButtons.firstIndex(of: button) else {
            return
        }
        
        let selectedRating = index + 1

        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    
    // MARK: Private Methods
    
    private func setupButtons() {
        
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
    // Load button image
        
        
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage( named: "filledStar",
                                  in: bundle,
                                  compatibleWith: self.traitCollection)
        
        let emptyStar = UIImage( named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage( named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for _ in 0..<starCount {
        let button = UIButton()

            
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true

            button.addTarget(self,
                         action: #selector(ratingButtonTapped(button:)),
                         for: .touchUpInside)
        
    // Add button to the stackView
        addArrangedSubview(button)
            
    // Add new button in the rating button array
        ratingButtons.append(button)
            
        }
        updateButtonSelectionState()
    }

    private func updateButtonSelectionState() {
        
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
 
