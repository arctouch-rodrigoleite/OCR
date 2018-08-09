//
//  ViewController.swift
//  OCR
//
//  Created by Rodrigo Leite on 8/8/18.
//  Copyright © 2018 Rodrigo Leite. All rights reserved.
//

import UIKit
import ArcOCR
import Stevia
import AVFoundation

class GoogleVisionViewController: UIViewController {

    // MARK: - VARIABLES
    let cameraController = CameraController()
    let googleVisionService = GoogleVisionService()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .center
        return textView
    }()
    
    // MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraController.delegate = self
        setupView()
    }

    // MARK: - SETUP VIEW
    func setupView() {
        // Add Camera Controller to the view
        cameraController.willMove(toParentViewController: self)
        self.view.sv(cameraController.view)
        cameraController.didMove(toParentViewController: self)
        
        // Add TextView to the view
        self.view.sv(textView)
        
        // Values into constraint
        textView.top(60).left(0).right(0).height(100)
        cameraController.view.top(0).left(0).right(0).bottom(0)
        align(vertically: [textView, cameraController.view])
    }
    
}

extension GoogleVisionViewController: CameraControllerDelegate {
    
    func cameraController(_ controller: CameraController, didCapture image: CMSampleBuffer) {
        googleVisionService.detectText(image: image) { (text) in
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                if !text.isEmpty {
                    strongSelf.textView.text = text
                }
            }
        }
    }
    
}
