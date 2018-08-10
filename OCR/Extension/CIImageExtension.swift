//
//  CIImageExtension.swift
//  OCR
//
//  Created by Rodrigo Leite on 8/9/18.
//  Copyright © 2018 Rodrigo Leite. All rights reserved.
//

import UIKit

extension CIImage {
    func toUIImage() -> UIImage? {
        let context: CIContext = CIContext.init(options: nil)
        
        if let cgImage: CGImage = context.createCGImage(self, from: self.extent) {
            return UIImage(cgImage: cgImage)
        } else {
            return nil
        }
    }
}
