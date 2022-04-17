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
        
        // para ver el plano que esta buscando en la camara
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
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
        
        
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // delegate para detectar cuando y donde el usuario toca para poder interactuar con la app
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let query: ARRaycastQuery? = sceneView.raycastQuery(from: touchLocation, allowing: .existingPlaneGeometry, alignment: .horizontal)
                    guard let nonOptQuery = query else {
                        print("query is nil")
                        return
                    }
                    let results: [ARRaycastResult] = sceneView.session.raycast(nonOptQuery)
                    
            if let hitResult = results.first {
                
                // Create a new scene
                let diceScene = SCNScene(named: "art.scnassets/diceColladaCopy.scn")!
                
                let dicenote = diceScene.rootNode.childNode(withName: "Dice", recursively: true)
                
                
                // pasamos la ubicacion donde toca el usuario
                dicenote?.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + (dicenote?.boundingSphere.radius)!, hitResult.worldTransform.columns.3.z)
                
                
                sceneView.scene.rootNode.addChildNode(dicenote!)
                
                
                // creamos los mov random tanto en x como en z
                let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
                
                let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
                
                
                // aca damos la animacion para la rotacion con los datos que cargamos arriba
                dicenote?.runAction(
                    SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.5)
                    
                
                )
                
            }
            
            
                }
      }
    
    
    
    //delegate metodo para decir que identifique la superficie horizontal
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // verifica si el ancho es del tipo arplaneanchor de planedetection
        if anchor is ARPlaneAnchor {
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            
            //rotamos el plano 90grados para dejarlo en los ejes de x z ya que viene por default en x y
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            
            planeNode.geometry = plane
            
            // node viene de la funcio delegate que creamos que te permite agregar sin necesidad de pasar por el rootnote
            node.addChildNode(planeNode)
            
        }else{
            return
        }
    }

}

