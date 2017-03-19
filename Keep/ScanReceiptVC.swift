//
//  ScanReceiptVC.swift
//  Keep
//
//  Created by Luna An on 2/7/17.
//  Copyright © 2017 Mimicatcodes. All rights reserved.
//

import UIKit
import TesseractOCR

class ScanReceiptVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewUnderImgV: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage: UIImage?
    var textsScanned:String = EmptyString.none
    var emptyArray = [String]()
    let picker = UIImagePickerController()
    var cancelled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = nil
        imageView.contentMode = .scaleAspectFill
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
        cancelled = true
        dismiss(animated: true, completion: nil)
    }
    
    func shouldCancelImageRecognition(for tesseract: G8Tesseract!) -> Bool {
        if cancelled == true {
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
        DispatchQueue.global(qos: .userInitiated).async {
            self.processScanning()
        }
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
        
        picker.allowsEditing = true
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
    
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
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

extension ScanReceiptVC : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedPhoto = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if let image = selectedPhoto {
            let scaledImage = scaleImage(image: image, maxDimension: 640)
            imageView.image = scaledImage
            saveButton.isEnabled = true
            saveButton.backgroundColor = Colors.tealish
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ScanReceiptVC : G8TesseractDelegate {
    func processScanning(){
        guard let img = imageView.image  else { return }
        let tesseract:G8Tesseract = G8Tesseract(language: TesseractLang.english)
        tesseract.engineMode = .tesseractCubeCombined
        tesseract.pageSegmentationMode = .auto
        tesseract.maximumRecognitionTime = 15.0
        tesseract.delegate = self
        tesseract.image = img
        tesseract.recognize()
        textsScanned = tesseract.recognizedText
        
        let newlineChars = NSCharacterSet.newlines
        let elementsArray = textsScanned.components(separatedBy: newlineChars).filter {!$0.isEmpty        }
        for string in elementsArray {
            let result = string.trimmingCharacters(in: CharacterSet(charactersIn: Filters.charSet))
            emptyArray.append(result)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Identifiers.Segue.toScannedItems, sender: self)
                self.imageView.image = nil
            }
        }
    }
}
