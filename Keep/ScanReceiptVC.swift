//
//  ScanReceiptVC.swift
//  Keep
//
//  Created by Luna An on 2/7/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import TesseractOCR

// TODO: Activitiy indicator / progress bar/ 
// TODO: Activate button

class ScanReceiptVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, G8TesseractDelegate {
    
    var selectedImage: UIImage?
    var textsScanned:String = ""
    var emptyArray = [String]()
    let picker = UIImagePickerController()
    var isFinishedProcessing = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewUnderImgV: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var test = false

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = nil
        picker.delegate = self
        saveButton.isEnabled = false
        saveButton.backgroundColor = Colors.tealishFaded
        cameraButton.isEnabled = true
        cameraButton.isEnabled = true
        activityIndicator.isHidden = true
        styleSubViews()
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        imageView.image = nil
        test = true
        dismiss(animated: true, completion: nil)
    }
    
    func shouldCancelImageRecognition(for tesseract: G8Tesseract!) -> Bool {
        if test == true {
            return true
        }
        return false
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.isHidden = true
        cameraButton.isEnabled = true
        libraryButton.isEnabled = true
        emptyArray.removeAll()
    }
    
    func processScanning(){
        guard let img = imageView.image  else { return }
        let tesseract:G8Tesseract = G8Tesseract(language: TesseractLang.english)
        tesseract.engineMode = .tesseractCubeCombined
        tesseract.pageSegmentationMode = .auto
        tesseract.maximumRecognitionTime = 30.0
        tesseract.delegate = self
        tesseract.image = img
        tesseract.recognize()
        print(tesseract.recognizedText)
        textsScanned = tesseract.recognizedText
        print(textsScanned)
        let newlineChars = NSCharacterSet.newlines
        let elementsArray = textsScanned.components(separatedBy: newlineChars).filter {!$0.isEmpty        }
        print(elementsArray)
        for string in elementsArray {
            let result = string.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.,"))
            emptyArray.append(result)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Identifiers.Segue.toScannedItems, sender: self)
                self.imageView.image = nil
            }
        }
    }
    
    func progressImageRecognition(for tesseract: G8Tesseract!) {
        updateProgress(with: Float(tesseract.progress))
    }
    
    func updateProgress(with value: Float) {
        print("\n")
        print("value: \(value)")
    }

    @IBAction func takePhotoButtonTapped(_ sender: Any) {
        handleCameraImage()
    }
    
    @IBAction func importButtonTapped(_ sender: Any) {
        handleLibraryImage()
    }
    
    @IBAction func scanButtonTapped(_ sender: Any) {
        
        cameraButton.isEnabled = false
        libraryButton.isEnabled = false
        saveButton.isEnabled = false
        saveButton.backgroundColor = Colors.tealishFaded
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .background).async {
            self.processScanning()
        }

        print(emptyArray)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            imageView.image = selectedImage
            saveButton.isEnabled = true
            saveButton.backgroundColor = Colors.tealish
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func enableSaveButton(){
        if imageView.image != nil {
            saveButton.isEnabled = true
            saveButton.backgroundColor = Colors.tealish
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = Colors.tealish
        }
    }
    
    func handleCameraImage(){
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.delegate = self
            picker.sourceType = .camera
            present(picker, animated: true, completion: nil)
        } else {
            print("No camera")
        }
        picker.allowsEditing = false
    }
    
    func handleLibraryImage(){
        
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.delegate = self
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
            
        } else {
            print("No photo library")
        }
        
        picker.allowsEditing = true
    }
    
    func styleSubViews(){
        viewUnderImgV.layer.borderWidth = 1
        viewUnderImgV.layer.masksToBounds = true
        viewUnderImgV.layer.borderColor = Colors.tealish.cgColor
        cameraButton.layer.cornerRadius = 8
        libraryButton.layer.cornerRadius = 8
        saveButton.layer.cornerRadius = 8
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Identifiers.Segue.toScannedItems {
            if emptyArray.isEmpty {
                return false
            }
            else {
                return true
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.Segue.toScannedItems {
            let dest = segue.destination as! ScannedItemsVC
            if !emptyArray.isEmpty {
                dest.resultsArray = emptyArray
            }
        }
    }
}
