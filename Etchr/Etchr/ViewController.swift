//
//  ViewController.swift
//  Etchr
//
//  Created by Justin on 2/23/17.
//  Copyright © 2017 Justin Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // outlets to scene
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var leftDial: UIImageView!
    @IBOutlet weak var rightDial: UIImageView!
    
    // variables for keeping track of left and right dial rotation
    var leftDialRotation: CGFloat = 0
    var rightDialRotation: CGFloat = 0
    
    // rotation gesture recognizers for controls
    let leftRotateRec = UIRotationGestureRecognizer()
    let rightRotateRec = UIRotationGestureRecognizer()
    
    // variables for keeping track of stylus and rotation
    var lastXrot: CGFloat = 0
    var curXrot: CGFloat = 0
    var lastYrot: CGFloat = 0
    var curYrot: CGFloat = 0
    var x: CGFloat = 0
    var lastX: CGFloat = 0
    var y: CGFloat = 0
    var lastY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load buttons
        shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        
        // load rotation gesture recognizers
        leftRotateRec.addTarget(self, action: #selector(ViewController.rotateLeft(_:)))
        self.leftView!.addGestureRecognizer(leftRotateRec)
        rightRotateRec.addTarget(self, action: #selector(ViewController.rotateRight(_:)))
        self.rightView!.addGestureRecognizer(rightRotateRec)
        
        // initialize stylus variables
        x = CGFloat(view.frame.width / 2)
        y = CGFloat(view.frame.height / 2)
        lastX = CGFloat(view.frame.width / 2)
        lastY = CGFloat(view.frame.height / 2)
    }
    
    // Selector function for leftView rotation gesture recognizer
    func rotateLeft(_ sender: UIRotationGestureRecognizer) {
        if(sender.state == .began) {
            lastXrot = 0
            curXrot = 0
        }
        if(sender.state == .changed) {
            curXrot = sender.rotation
            leftDialRotation += curXrot - lastXrot
            leftDial.transform = CGAffineTransform(rotationAngle: leftDialRotation)
            x += (curXrot - lastXrot) * 40
            if(x < 0) {
                x = 0
            }
            if(x > view.frame.width) {
                x = view.frame.width
            }
            drawLines(fromPoint: CGPoint(x: lastX, y: lastY), toPoint: CGPoint(x: x, y: y))
            lastX = x
            lastXrot = curXrot
            print("rotating left")
        }
        if(sender.state == .ended) {
        }
    }
    
    // Selector function for rightView rotation gesture recognizer
    func rotateRight(_ sender: UIRotationGestureRecognizer) {
        if(sender.state == .began) {
            lastYrot = 0
            curYrot = 0
        }
        if(sender.state == .changed) {
            curYrot = sender.rotation
            rightDialRotation += curYrot - lastYrot
            rightDial.transform = CGAffineTransform(rotationAngle: rightDialRotation)
            y -= (curYrot - lastYrot) * 40
            if(y < 0) {
                y = 0
            }
            if(y > view.frame.height) {
                y = view.frame.height
            }
            drawLines(fromPoint: CGPoint(x: lastX, y: lastY), toPoint: CGPoint(x: x, y: y))
            lastY = y
            lastYrot = curYrot
            print("rotating right")
        }
        if(sender.state == .ended) {
        }
    }
    
    // Draw a line between two given points
    func drawLines(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(self.view.frame.size)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.square)
        context?.setLineWidth(1)
        context?.setStrokeColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor)
        
        context?.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    // When share button is clicked, image view can be exported
    func share(sender: UIButton!) {
        let activityItem: [AnyObject] = [self.imageView.image as AnyObject]
        let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        self.present(avc, animated: true, completion: nil)
    }
    
    // When clear button is clicked, image view is cleared (same behavior as shaking the device)
    func clear(sender: UIButton!) {
        let alertController = UIAlertController(title: "Clear screen?", message: "", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
            self.imageView.image = nil;
            self.lastX = self.x
            self.lastY = self.y
        }
        
        let actionNo = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction) in }
        
        alertController.addAction(actionYes)
        alertController.addAction(actionNo)
        self.present(alertController, animated: true, completion:nil)
    }
    
    // When device is shaken, user is prompted to clear imageView
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake {
            let alertController = UIAlertController(title: "Clear screen?", message: "", preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction) in
                self.imageView.image = nil;
                self.lastX = self.x
                self.lastY = self.y
            }
            
            let actionNo = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction) in }
            
            alertController.addAction(actionYes)
            alertController.addAction(actionNo)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Always hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

