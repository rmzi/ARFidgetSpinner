//
//  ViewController.swift
//  block-test
//
//  Created by Ramzi Abdoch on 7/28/17.
//  Copyright © 2017 Ramzi Abdoch. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    // Scene Variables
    var spinnerNode: SCNNode?
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/FidgetSpinner.dae")!
        
        // Find treeNode
        self.spinnerNode = scene.rootNode.childNode(withName: "FidgetSpinner", recursively: true)

        // Place treeNode at (0,0,-1)
        // self.treeNode?.position = SCNVector3Make(0, 0, -1)
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
/*
     // Override to create trees on touch
 */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        guard let hitFeature = results.last else { return }
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        let spinnerClone = spinnerNode!.clone()
        spinnerClone.position = hitPosition
        sceneView.scene.rootNode.addChildNode(spinnerClone)
        
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 3)
        let repAction = SCNAction.repeatForever(action)
        spinnerClone.runAction(repAction, forKey: "myrotate")
    }
}
