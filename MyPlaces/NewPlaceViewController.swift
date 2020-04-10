//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Zhuravlev Lev on 04/04/2020.
//  Copyright © 2020 Zhuravlev Lev. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    var newPlace: Place?

    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        // скрываем кнопку
        saveButton.isEnabled = false
        
        // для того чтобы кнопка скрывалась или
        // становилась доступной в зависимости от
        // заполненности поля name реализуем метод
        
        placeName.addTarget(
            self, // кем выполняется действие (в данном случае это будет наш класс)
            action: #selector(textFieldChanged), // какое будет выполняться действие
            for: .editingChanged) // когда оно будет выполняться
        
// то есть каждый раз при редактировани поля placeName будет срабатывать метод
// .editingChanged, который в свою очередь будет вызывать метод textFieldChanged
// который уже в свою очередь будет следить за тем заполнено ли текстовое поле
// или нет, если будет заполненно то кнопка safe будет доступна иначе нет

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // тут мы проверяем на какую ячейку было нажатие
        if indexPath.row == 0 {
            
            // изображения alertController
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            
            // открытие alertController
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: UIAlertController.Style.actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default)
            { _ in self.chooseImagePicker(source: .camera)}			// логика вызова камеры
            
            
            // образаемся к объекту камера и вызываем метод setValue
            // он позволяет установить значение любого типа
            // по определенному ключу
            
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
           
            let photo = UIAlertAction(title: "Photo", style: .default)
            { _ in self.chooseImagePicker(source: .photoLibrary)} 	// логика вызова фото
            
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

            
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
        }
            
        else {
            // а тут мы будем просто
            // скрывать при тапе на другие ячейки
            view.endEditing(true)}
    }
    
    func saveNewPlace() {
        newPlace = Place(name: placeName.text!,
                         location: placeLocation.text ,
                         type: placeType.text,
                         rest_image: nil,
                         image: placeImage.image)

    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    
}

    
// MARK: Text field delegate
    
// Для того чтобы поработать с клавиатурой
// нам необходимо подписаться под протокол UITextFieldDelegate

    extension NewPlaceViewController: UITextFieldDelegate {
        
        // скрываем клавиаутуру по нажатию на done
        // и делать мы это будем в методе
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        @objc private func textFieldChanged() {
            
            if placeName.text?.isEmpty == false {
                saveButton.isEnabled = true
            } else {saveButton.isEnabled = false}}
        
        
    }

// MARK: Work With Image
// это отдельное расширение класса в котором будет
// реализовываться метод открытия фото

    extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        // метод открытия изображения
        // у него будет параметр, через который
        // будет определяться источник выбора изображения
        // (фото или камера)
        
        func chooseImagePicker(source: UIImagePickerController.SourceType) {
            
            // первое что мы делаем в методе это проверяем
            // на доступность источника выбора изображения
            
            if UIImagePickerController.isSourceTypeAvailable(source){
                
                // если он доступен до создаем экземпляр этого класса
                let imagePicker = UIImagePickerController()
                
               imagePicker.delegate = self

                // далее реализуем метод позволяющий
                // редактировать выбранное изображение
                imagePicker.allowsEditing = true
                
                // определяем тип источника для выбранного изображения
                imagePicker.sourceType = source
                
                // далее его нам надо отобразить
                present(imagePicker, animated: true)    }
                 }
                
            // для того чтобы назначить OutLet'у изображение
            // в классе UIImagePickerControllerDelegate в
            // на который мы подписались необходимо
            // выполнить метод
                
                func imagePickerController(_ picker: UIImagePickerController,
                                           didFinishPickingMediaWithInfo info : [UIImagePickerController.InfoKey: Any]) {
                    placeImage.image = info[.editedImage] as? UIImage // работа с выбранным по ключу изображением
                    placeImage.contentMode = .scaleAspectFill // заполнение в нужной ячейке
                    placeImage.clipsToBounds = true // обрезка выбранного изображения
                    dismiss(animated: true) 
               }}

