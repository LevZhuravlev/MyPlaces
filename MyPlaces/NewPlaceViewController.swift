//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Zhuravlev Lev on 04/04/2020.
//  Copyright © 2020 Zhuravlev Lev. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {

    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

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

