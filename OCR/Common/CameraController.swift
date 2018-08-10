//
//  CameraController.swift
//  ArcOCR
//
//  Created by Rodrigo Leite on 8/8/18.
//

import UIKit
import AVFoundation

public protocol CameraControllerDelegate: class {
    func cameraController(_ controller: CameraController, didCapture image: CMSampleBuffer)
}

public class CameraController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    // MARK: - Variables
    private(set) lazy var cameraLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    
    private lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.medium
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video),
                let input = try? AVCaptureDeviceInput(device: backCamera) else { return session }

        session.addInput(input)
        return session
    }()
    let overlayLayer = CALayer()

    weak public var delegate: CameraControllerDelegate?
    
    // MARK: - Vc Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        cameraLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraLayer)
        view.layer.addSublayer(overlayLayer)
        
        // register to receive buffers from the camera
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "CameraControllerQueue"))
        self.captureSession.addOutput(videoOutput)
        self.captureSession.sessionPreset = AVCaptureSession.Preset.medium

        // begin the session
        self.captureSession.startRunning()
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cameraLayer.frame = view.bounds
        self.overlayLayer.frame = view.bounds
    }
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let delegate = delegate{
            delegate.cameraController(self, didCapture: sampleBuffer)
        }
//        if let delegate = delegate,
//            let cvImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
//                let ciImage = CIImage(cvImageBuffer: cvImageBuffer)
//            let image = UIImage(ciImage: ciImage)
//            delegate.cameraController(self, didCapture: image)
//        }
    }

}
