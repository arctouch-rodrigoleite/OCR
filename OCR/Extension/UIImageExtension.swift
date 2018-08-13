//
//  UIImageExtension.swift
//  OCR
//
//  Created by Rodrigo Leite on 8/9/18.
//  Copyright © 2018 Rodrigo Leite. All rights reserved.
//

import UIKit

extension UIImage {
    func scaleImage(_ maxDimension: CGFloat) -> UIImage? {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        
        if size.width > size.height {
            let scaleFactor = size.height / size.width
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            let scaleFactor = size.width / size.height
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func imageFixedOrientation() -> UIImage? {
        
        guard imageOrientation != UIImageOrientation.up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.cgImage else {
            //CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
    
//    func crop(image: UIImage, rectangle: VNRectangleObservation) -> UIImage? {
//        var t: CGAffineTransform = CGAffineTransform.identity;
//        t = t.scaledBy(x: image.size.width, y: -image.size.height);
//        t = t.translatedBy(x: 0, y: -1 );
//        let x = rectangle.boundingBox.applying(t).origin.x
//        let y = rectangle.boundingBox.applying(t).origin.y
//        let width = rectangle.boundingBox.applying(t).width
//        let height = rectangle.boundingBox.applying(t).height
//        let fromRect = CGRect(x: x, y: y, width: width, height: height)
//        let drawImage = image.cgImage!.cropping(to: fromRect)
//        if let drawImage = drawImage {
//            let uiImage = UIImage(cgImage: drawImage)
//            return uiImage
//        }
//        return nil
//    }
    
//    func preProcess(image: UIImage) -> UIImage {
//        let width = image.size.width
//        let height = image.size.height
//        let addToHeight2 = height / 2
//        let addToWidth2 = ((6 * height) / 3 - width) / 2
//        let imageWithInsets = insertInsets(image: image,
//                                           insetWidthDimension: addToWidth2,
//                                           insetHeightDimension: addToHeight2)
//        let size = CGSize(width: 28, height: 28)
//        let resizedImage = resize(image: imageWithInsets, targetSize: size)
//        let grayScaleImage = convertToGrayscale(image: resizedImage)
//        return grayScaleImage
//    }

    
}
