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
    
    // размер звезды
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {didSet {setupButtons()}}
    
    // количество звезд
    @IBInspectable var starCount: Int = 5 {didSet {setupButtons()}}
    
    // Текущее значение рейтинга
    var rating = 0
    
    // Массив кнопок
    private var ratingButtons = [UIButton]()


    
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
        
        for button in ratingButtons {
            
            // удаляем представление
            removeArrangedSubview(button)
            
            // удаляем из стека
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
    // Load button image
        
         let filledStar = #imageLiteral(resourceName: <#T##String#>)
        
        
        
        
        
        
        for _ in 0..<starCount {
            
           
    // Сreate the button
        
        let button = UIButton()
        button.backgroundColor = .red
     
    // Add constraints for button
        
        button.translatesAutoresizingMaskIntoConstraints = false
            // отключает автоматически сгенерированные констрейнты для кнопки,
            // потому что если создавать объект программно, то его свойство
            // по умолчанию автоматически генерирует констрейнты
        
        
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            // строки определяющие высоту и ширину кнопки

    // Setup button action
        
        button.addTarget(self, // показываем что действие будет выполняться из класса
                         action: #selector(ratingButtonTapped(button:)), // действие
                         for: .touchUpInside) // событие по которому будет срабатывать вызов метода
        

        
    // Add button to the stackView
        
        addArrangedSubview(button)
        // это свойство добавляет кнопку в список представлений,
        // как subView класса ratingControl
            
    // Add new button in the rating button array
        ratingButtons.append(button)
    }

    }
}

 
