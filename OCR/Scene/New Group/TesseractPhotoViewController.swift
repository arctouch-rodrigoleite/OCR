//
//  TesseractPhotoViewController.swift
//  OCR
//
//  Created by Rodrigo Leite on 8/13/18.
//  Copyright © 2018 Rodrigo Leite. All rights reserved.
//

import UIKit
import Stevia
import TesseractOCR
import NVActivityIndicatorView

class TesseractPhotoViewController: UIViewController, NVActivityIndicatorViewable, UINavigationControllerDelegate {

    // MARK: - VARIABLES
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let textView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .center
        return textView
    }()
    let button: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("Photo", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(didTouchPhotoButton(_:)), for: .touchUpInside)
        return button
    }()
    let pickerController = PickerImageController()
    var tesseractService = TesseractService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tesseractService.delegate = self
        pickerController.imageClosure = { [weak self] image in
            guard let strongSelf = self,
                let image = image else { return  }
            DispatchQueue.main.async {
                strongSelf.imageView.image = image
                strongSelf.tesseractService.handle(image: image)
            }
            
        }
        setupView()
    }

    // MARK: - SETUP VIEW
    func setupView() {
        // Add Camera Controller to the view
        view.sv([textView, imageView, button])
        
        // Values into constraint
        textView.top(60).left(0).right(0).height(100)
        imageView.top(160).left(0).right(0).bottom(0)
        button.width(80).height(60).bottom(30).left(10)
        align(vertically: [textView, imageView, button])
    }
    
    // MARK: ACTION
    @objc func didTouchPhotoButton(_ sender: UIButton) {
        pickerController.modalPresentationStyle = .overCurrentContext
        present(pickerController, animated: false, completion: {
            self.pickerController.displayActionSheetPhotoPicker(source: self.button)
        })
    }

}

extension TesseractPhotoViewController: TesseractDelegate {
    func tessService(_ service: TesseractService, didDetect text: String) {
        DispatchQueue.main.async {
            self.textView.text = text
            self.stopAnimating()
        }
    }
}
