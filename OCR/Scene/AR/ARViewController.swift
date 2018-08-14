//
//  ARViewController.swift
//  OCR
//
//  Created by Rodrigo Leite on 8/13/18.
//  Copyright © 2018 Rodrigo Leite. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var textView: UITextView!
    
    fileprivate lazy var session = ARSession()
//    fileprivate lazy var configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let referenecImages = ARReferenceImage.referenceImages(inGroupNamed: "ARImages", bundle: Bundle.main) else { return }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenecImages
        configuration.planeDetection = [.horizontal, .vertical]
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.session.run(configuration)
        
    }
    
    @IBAction func didTapScan(_ sender: UIButton) {
        textView.text = ""
        for child in sceneView.scene.rootNode.childNodes {
            child.removeFromParentNode()
        }
        guard let referenecImages = ARReferenceImage.referenceImages(inGroupNamed: "ARImages", bundle: Bundle.main) else { return }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenecImages
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration, options: [ARSession.RunOptions.resetTracking, ARSession.RunOptions.removeExistingAnchors])
    }
    
}

extension ARViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let currentImageAnchor = anchor as? ARImageAnchor else { return nil }
        
        let name = currentImageAnchor.referenceImage.name!
        let width = currentImageAnchor.referenceImage.physicalSize.width
        let height = currentImageAnchor.referenceImage.physicalSize.height
        DispatchQueue.main.async {
            self.textView.text = """
            Image Name = \(name)
            Image Width = \(width)
            Image Height = \(height)
            """
        }
        return nil
    }
    
}
