//
//  TesseractService.swift
//  OCR
//
//  Created by Rodrigo Leite on 8/9/18.
//  Copyright © 2018 Rodrigo Leite. All rights reserved.
//

import Foundation
import TesseractOCR
import AVFoundation

protocol TesseractDelegate: class {
    func tessService(_ service: TesseractService, didDetect text: String)
}

struct TesseractService {
    private let tesseract = G8Tesseract(language: "eng")!
    
    weak var delegate: TesseractDelegate?
    
    init() {
        tesseract.engineMode = .tesseractCubeCombined
        tesseract.pageSegmentationMode = .singleBlock
    }
    
    func handle(image: UIImage) {
        handleWithTesseract(image: image)
    }
    
    func handle(buffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else {
            return
        }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        guard let image = ciImage.toUIImage() else {
            return
        }
        handleWithTesseract(image: image)
    }
    
    private func handleWithTesseract(image: UIImage) {
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        let text = tesseract.recognizedText ?? ""
        delegate?.tessService(self, didDetect: text)
    }
    
}
