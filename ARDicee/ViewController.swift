//
//  ViewController.swift
//  ARDicee
//
//  Created by Nicolas Dolinkue on 16/04/2022.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
//        // creamos el cubo desde xcode
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//
//        let material = SCNMaterial()
//
//        // para entrar dentro de las propiedades del cubo, el material, son propiedades dentro de ARkit
//        material.diffuse.contents = UIColor.red
//
//        // creamos un array por si le damos mas materiales al objeto, en este caso uno solo que es el color
//        cube.materials = [material]
//
//        // posicion del objeto
//        let node = SCNNode()
//
//        // en x,y, z
//        node.position = SCNVector3(0, 0.1, -0.5)
//
//        node.geometry = cube
//
//        //el rootnode en la base y se le pueden ir agrendo hijos por si queres poner mas de  uno
//        sceneView.scene.rootNode.addChildNode(node)
        
        
        sceneView.automaticallyUpdatesLighting = true
        
        
        // Create a new scene
        let diceScene = SCNScene(named: "art.scnassets/diceColladaCopy.scn")!
        
        let dicenote = diceScene.rootNode.childNode(withName: "Dice", recursively: true)
        
        dicenote?.position = SCNVector3(0, 0, -0.1)
        
        
        sceneView.scene.rootNode.addChildNode(dicenote!)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }


}
