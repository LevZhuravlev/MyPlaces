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
    
    // размер звезды
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {didSet {setupButtons()}}
    
    // количество звезд
    @IBInspectable var starCount: Int = 5 {didSet {setupButtons()}}
    
    // Массив кнопок
    private var ratingButtons = [UIButton]()
    
    var isChanged = true


    
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
        
        guard isChanged  else { return }
        
        // сначала мы узнаем индекс выбранной кнопки
        guard let index = ratingButtons.firstIndex(of: button) else {return}
        
        // далее создаем свойство в котором
        // будет указываться выбранный рейтинг
        let selectedRating = index + 1
        
        // условие которое будет обнулять рейтинг
        // если мы нажем на тот рейтинг который был
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
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
        
        
        let bundle = Bundle(for: type(of: self))
        // данный класс определяет местоположение ресурсов
        // которые храняться в катологе assets нашего проекта
        
        // дальше для кажого свойства определяющего
        // звезду прописываем местоположение
        let filledStar = UIImage( named: "filledStar", // тут будет имя файла
                                  in: bundle,          // местоположение файлов
                                  compatibleWith: self.traitCollection)
                                // используется для того чтобы убедиться в том,
                                // что загружен правильный вариант изображения
        let emptyStar = UIImage( named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage( named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for _ in 0..<starCount {
            
           
    // Сreate the button
        let button = UIButton()

    // Set the button Image
            
            button.setImage(emptyStar,   	// изображение кнопки
                            for: .normal) 	// состояние кнопки
                                            // .normal это обычное состояние
                                            // кнопки, то есть когда с ней
                                            // ничего не происходит
            
            button.setImage(filledStar,
                            for: .selected) // выбрано
            
            button.setImage(highlightedStar, 	// состояние кнопки при
                            for: .highlighted) 	// прикосновении к ней
        
            
            // если звезда выделена и мы прикасаемся к ней
            // тут мы будем использовать
            // два состояния для кнопки
            
            button.setImage(highlightedStar,
                            for: [.highlighted, .selected])
            
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
        updateButtonSelectionState()

    }

    private func updateButtonSelectionState() {
        
        // при вызове данного метода
        // мы будем выполнять итерацию по всем кнопкам и устанавливать
        // состояние каждой из них в соответствии с индексом и рейтингом
        // метод .enumerated() возвращает пару: объект и его индекс
        
        for (index, button) in ratingButtons.enumerated() {
            
            // затем мы возьмем каждую кнопку и присвоем для свойства кнопки
            // isSelected логическое значение true или false
            // в зависимости от значения index < rating
            
            button.isSelected = index < rating
            
            // то есть если если индекс кнопки будет меньше рейтинга
            // то свойству .isSelected будет присвоен true и она она будет заполнена
            // и все те которые меньше по индексу так как процесс происходит в цикле
        }
        
    }
}
 
