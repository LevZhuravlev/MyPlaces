//
//  RatingControl.swift
//  MyPlaces
//
//  Created by Zhuravlev Lev on 23/04/2020.
//  Copyright © 2020 Zhuravlev Lev. All rights reserved.
//

import UIKit

class RatingControl: UIStackView {

    

    
    // MARK: Initialization
    
    // теперь объявляем инициализаторы
    // вызвав у каждого из них
    // соответсвующий инициализатор
    // родительского класса
    
    
    override init(frame: CGRect) {
       
        // вызываем инициализатор
        // родительского класса
        
        super.init(frame: frame)
        setupButtons()

    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: Button action
    
    @objc func ratingButtonTapped(button: UIButton) {
        print("ButtonPressed 👍")
        
    }
    
    
    // MARK: Private Methods
    
    private func setupButtons() {
           
    // Сreate the button
        
        let button = UIButton()
        button.backgroundColor = .red
     
    // Add constraints for button
        
        button.translatesAutoresizingMaskIntoConstraints = false
            // отключает автоматически сгенерированные констрейнты для кнопки,
            // потому что если создавать объект программно, то его свойство
            // по умолчанию автоматически генерирует констрейнты
        
        
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
            // строки определяющие высоту и ширину кнопки

    // Setup button action
        
        button.addTarget(self, // показываем что действие будет выполняться из класса
                         action: #selector(ratingButtonTapped(button:)), // действие
                         for: .touchUpInside) // событие по которому будет срабатывать вызов метода
        

        
    // Add button to the stackView
        
        addArrangedSubview(button)
        // это свойство добавляет кнопку в список представлений,
        // как subView класса ratingControl
       }
   }
 
