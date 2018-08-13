//
//  GoogleVisionPhotoViewController.swift
//  OCR
//
//  Created by Rodrigo Leite on 8/9/18.
//  Copyright © 2018 Rodrigo Leite. All rights reserved.
//

import UIKit
import Stevia
import NVActivityIndicatorView

class GoogleVisionPhotoViewController: UIViewController, NVActivityIndicatorViewable, UINavigationControllerDelegate {

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
    let cloudButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("Cloud", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(didTouchCloudButton(_:)), for: .touchUpInside)
        return button
    }()
    
    let pickerController = PickerImageController()
    let googleVisionService = GoogleVisionService()
    var processOnCloud = true
    
    // MARK: - Vc Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerController.imageClosure = { [weak self] image in
            guard let strongSelf = self,
                let image = image else { return  }
            DispatchQueue.main.async {
                strongSelf.imageView.image = image
                strongSelf.startAnimating()
                strongSelf.googleVisionService.detectText(onCloudDetection: strongSelf.processOnCloud,
                                                          image: image,
                                                          completionHandler: { (value) in
                                                            DispatchQueue.main.async {
                                                                strongSelf.stopAnimating()
                                                                strongSelf.textView.text = value
                                                            }
                })
            }
            
        }
        setupView()
    }

    // MARK: - SETUP VIEW
    func setupView() {
        // Add Camera Controller to the view
        view.sv([textView, imageView, button, cloudButton])
        
        // Values into constraint
        textView.top(60).left(0).right(0).height(100)
        imageView.top(160).left(0).right(0).bottom(0)
        button.width(80).height(60).bottom(30).left(10)
        cloudButton.width(80).height(60).bottom(30).right(10)
        align(vertically: [textView, imageView])
    }

    // MARK: ACTION
    @objc func didTouchPhotoButton(_ sender: UIButton) {
        pickerController.modalPresentationStyle = .overCurrentContext
        present(pickerController, animated: false, completion: {
            self.pickerController.displayActionSheetPhotoPicker(source: self.button)
        })
    }
    
    @objc func didTouchCloudButton(_ sender: UIButton) {
        if sender.currentTitle == "Cloud" {
            processOnCloud = false
            sender.setTitle("Device", for: .normal)
        } else {
            processOnCloud = true
            sender.setTitle("Cloud", for: .normal)
        }
    }
    

}

