//
//  TesseractViewController.swift
//  OCR
//
//  Created by Rodrigo Leite on 8/9/18.
//  Copyright © 2018 Rodrigo Leite. All rights reserved.
//

import UIKit
import Stevia
import Vision
import AVFoundation

class TesseractViewController: UIViewController {

    // MARK: - VARIABLES
    let cameraController = CameraController()
    var tesseractService = TesseractService()
    let visionService = VisionService()
    let boxService = BoxService()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .center
        return textView
    }()
    
    // MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraController.delegate = self
        visionService.delegate = self
        boxService.delegate = self
        tesseractService.delegate = self
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

extension TesseractViewController: CameraControllerDelegate {
    
    func cameraController(_ controller: CameraController, didCapture image: CMSampleBuffer) {
        visionService.handle(buffer: image)
    }

}

extension TesseractViewController: VisionServiceDelegate {
    
    func visionService(_ version: VisionService, didDetect image: UIImage, results: [VNTextObservation]) {
        boxService.handle(
            overlayLayer: cameraController.overlayLayer,
            image: image,
            results: results,
            on: cameraController.view
        )
    }
    
}

extension TesseractViewController: BoxServiceDelegate {
    func boxService(_ service: BoxService, didDetect image: UIImage) {
        tesseractService.handle(image: image)
    }
}

extension TesseractViewController: TesseractDelegate {
    func tessService(_ service: TesseractService, didDetect text: String) {
        DispatchQueue.main.async {
            self.textView.text = text
        }
    }

}


