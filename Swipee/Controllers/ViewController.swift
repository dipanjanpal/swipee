//
//  ViewController.swift
//  Swipee
//
//  Created by Dipanjan Pal on 07/04/20.
//  Copyright © 2020 Dipanjan Pal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewBasecard: UIView!
    var objSwipee : SwipeeModel?
    var divisor = CGFloat()
    var lastSwipeViewtag = 100
    override func viewDidLoad() {
        super.viewDidLoad()
        
        divisor = (view.frame.width / 2) / 0.61
        
        for i in 0...10{
            
            let viewNew = UIView()
            viewNew.backgroundColor = UIColor.yellow
            viewNew.layer.borderColor = UIColor.orange.cgColor
            viewNew.layer.borderWidth = 1.0
            viewNew.tag = 100 + i
            viewNew.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(viewNew)
            viewNew.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            viewNew.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
            viewNew.heightAnchor.constraint(equalToConstant: 360).isActive = true
            viewNew.widthAnchor.constraint(equalToConstant: 240).isActive = true
            
            let label = UILabel()
            label.text = "\(i)"
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            viewNew.addSubview(label)
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
            
            viewNew.isUserInteractionEnabled = true
            let panView = UIPanGestureRecognizer(target: self, action: #selector(panView(_:)))
            viewNew.addGestureRecognizer(panView)
        }
        
        //internet connection cehcking
//        if Reachability.isConnectedToNetwork(){
//            print("Internet Connection Available!")
//            fetchData()
//        }else{
//            print("Internet Connection not Available!")
//        }
        
        
    }
    
    @IBAction func buttonBackwardAction(_ sender: Any) {
        let cardToBack = view.viewWithTag(lastSwipeViewtag) ?? UIView()
        resetCard(cardView: cardToBack)
    }
    
    @IBAction func btnResetAction(_ sender: Any) {
        resetCard(cardView: self.viewBasecard)
    }
    @objc func panView(_ sender: UIPanGestureRecognizer) {
        let cardView = sender.view ?? UIView()
        let point = sender.translation(in: view)
        let xFromCenter = cardView.center.x - view.center.x
        
        cardView.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        cardView.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor)
        
        if sender.state == UIGestureRecognizer.State.ended{
            
            if cardView.center.x < 75 {
                // move to left side
                UIView.animate(withDuration: 0.3) {
                    cardView.center = CGPoint(x: cardView.center.x - 200, y: cardView.center.y + 75)
                    cardView.alpha = 0
                    print("left ==>",cardView.tag)
                }
                lastSwipeViewtag = cardView.tag
                return
            }
            else if cardView.center.x > (view.frame.width - 75){
                UIView.animate(withDuration: 0.3) {
                    cardView.center = CGPoint(x: cardView.center.x + 200, y: cardView.center.y + 75)
                    cardView.alpha = 0
                    print("right ==>",cardView.tag)
                }
                lastSwipeViewtag = cardView.tag
                return
            }
            let viewToReset = view.viewWithTag(cardView.tag) ?? UIView()
            resetCard(cardView: viewToReset)
        }
        
    }
    
    func resetCard(cardView : UIView){
        UIView.animate(withDuration: 0.2) {
            cardView.center = self.viewBasecard.center
            cardView.alpha = 1
            cardView.transform = .identity
        }
    }
    
    
    //MARK: api call
    
    func fetchData(){
        // common networking function is called. And we'll get back a model if call and convestion is success otherwise we'll get error flag true and an error msg.
        BaseNetworking.fetch { (model, err, errMsg) in
            if !err{
                
            }
            else{
                print("some error occured ===>>>", errMsg ?? "")
            }
        }
    }
}

