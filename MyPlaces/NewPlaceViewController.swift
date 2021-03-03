//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Zhuravlev Lev on 04/04/2020.
//  Copyright © 2020 Zhuravlev Lev. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    var imageIsChanged = false
    var currentPlace:Place!
 
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var mapButton: UIButton!
    
    
    override func viewDidLoad() {

        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        
        saveButton.isEnabled = false
        mapButton.isHidden = true
    
        setupEditScreen()
        placeName.addTarget( self, action: #selector(textFieldChanged), for: .editingChanged)
        
        placeLocation.addTarget( self, action: #selector(MapFieldChanged), for: .editingChanged)}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            let actionSheet = UIAlertController(title: nil, message: nil,preferredStyle: UIAlertController.Style.actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default)
            { _ in self.chooseImagePicker(source: .camera)}
                        
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
            view.endEditing(true)}
    }
    
    func savePlace() {
        
        var image: UIImage?
        if imageIsChanged {image = placeImage.image}
        else {image = #imageLiteral(resourceName: "imagePlaceholder")}
        
        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             imageData: image?.pngData(),
                             rating: Double(ratingControl.rating))
    
        
        if currentPlace != nil {
           
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            }
        }
        
        else {StorageManager.saveObject(newPlace)}
    }
    
    private func setupEditScreen(){

        guard currentPlace != nil else { return }
        
        
        placeName.text = currentPlace?.name
        placeLocation.text = currentPlace?.location
        placeType.text = currentPlace?.type
        
        
        guard let data = currentPlace!.imageData,
            let image = UIImage(data: data)
            else {return}
        placeImage.image = image
        placeImage.contentMode = .scaleToFill
        imageIsChanged = true

        setNavigationBar()
        ratingControl.rating = Int(currentPlace.rating)

    }
    
    private func setMapButton() {
        
        
    }
    
    private func setNavigationBar() { 
        
        guard currentPlace != nil else { return }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
        guard currentPlace.location != "" else { return }
        mapButton.isHidden = false
            
    }

    @IBAction func cancelAction(_ sender: Any) {
    dismiss(animated: true)
}

    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identefier = segue.identifier, let segueVC = segue.destination as? MapViewController
            else { return }
        
        segueVC.incomeSegueIdentefier = identefier
        segueVC.mapViewControllerDelegate = self
        
        if identefier == "showPlace" {
            segueVC.place.name = placeName.text!
            segueVC.place.location = placeLocation.text!
            segueVC.place.type = placeType.text!
            segueVC.place.imageData = placeImage.image?.pngData()
        }
    }
}


// MARK: Text field delegate


    extension NewPlaceViewController: UITextFieldDelegate {

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        @objc private func textFieldChanged() {
            
            if placeName.text?.isEmpty == false {
                saveButton.isEnabled = true
            } else {
                saveButton.isEnabled = false
            }
        }
        
        @objc private func MapFieldChanged() {
            
            if placeLocation.text?.isEmpty == false {
                mapButton.isHidden = false
            } else {
                mapButton.isHidden = true
            }
        }
 
        
}

// MARK: Work With Image

    extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
        func chooseImagePicker(source: UIImagePickerController.SourceType) {
            
            if UIImagePickerController.isSourceTypeAvailable(source){
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = source
                present(imagePicker, animated: true)
            }
        }
                
                
                func imagePickerController(_ picker: UIImagePickerController,
                                           didFinishPickingMediaWithInfo info : [UIImagePickerController.InfoKey: Any]) {
                    placeImage.image = info[.editedImage] as? UIImage
                    placeImage.contentMode = .scaleAspectFill
                    placeImage.clipsToBounds = true
                    imageIsChanged = true
                    dismiss(animated: true) 
               }
    }

// метод отображения в поле location данных с карты
    extension NewPlaceViewController: MapViewControllerDelegate {
        func getAddress(_ address: String?) {
            placeLocation.text = address
        }
}

