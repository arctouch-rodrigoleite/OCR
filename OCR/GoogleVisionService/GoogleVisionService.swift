//
//  GoogleVisionService.swift
//  OCR
//
//  Created by Rodrigo Leite on 8/8/18.
//  Copyright © 2018 Rodrigo Leite. All rights reserved.
//

import Foundation
import Firebase
import FirebaseMLVision
import AVFoundation

struct GoogleVisionService {
    
    private let vision = Vision.vision()
    
    func detectText(onCloudDetection: Bool = false, image: CMSampleBuffer, completionHandler: @escaping (_ text: String) -> Void) {
        let visionImage = VisionImage(buffer: image)
        process(onCloudDetection: onCloudDetection, visionImage: visionImage, completionHandler: completionHandler)
    }

    
    func detectText(onCloudDetection: Bool = false, image: UIImage, completionHandler: @escaping (_ text: String) -> Void) {
        let visionImage = VisionImage(image: image)
//        let metadata = VisionImageMetadata()
//        metadata.orientation = .bottomLeft
//        visionImage.metadata = metadata
        process(onCloudDetection: onCloudDetection, visionImage: visionImage, completionHandler: completionHandler)
    }
    
    fileprivate func process(onCloudDetection: Bool, visionImage: VisionImage, completionHandler: @escaping (_ text: String) -> Void) {
        let textRecognizer: VisionTextRecognizer?
        if onCloudDetection {
            let options = VisionCloudTextRecognizerOptions()
            options.languageHints = ["en"] // Define the language
            textRecognizer = vision.cloudTextRecognizer(options: options)
        } else {
            textRecognizer = vision.onDeviceTextRecognizer()
        }
        textRecognizer?.process(visionImage) { result, error in
            print(result?.text)
            var text = ""
            if let result = result {
                for block in result.blocks {
                    print(block.text)
                    text += (block.text + "\n")
                }
            }
            completionHandler(text)
        }
    }
    
}
