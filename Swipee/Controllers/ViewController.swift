//
//  ViewController.swift
//  Swipee
//
//  Created by Dipanjan Pal on 07/04/20.
//  Copyright © 2020 Dipanjan Pal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var lblBaseView: UILabel!
    @IBOutlet weak var viewLoader: UIView!
    @IBOutlet weak var viewBasecard: UIView!
    var divisor = CGFloat()
    var lastSwipeViewtag = Int()
    var totalCards = Int()
    
    
    //MARK: view lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewBasecard.layer.cornerRadius = 10
        lblBaseView.text = "That's all folks!"
        lblCounter.text = "Showing page 0 out of 0"
        
        divisor = (view.frame.width / 2) / 0.61
        
        
        //internet connection cehcking
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            fetchData()
        }else{
            lblBaseView.text = "Internet Connection not Available.\nPlease Restart."
            print("Internet Connection not Available!")
        }
        
        
    }
    
    
    //MARK: button actions
    @IBAction func buttonBackwardAction(_ sender: Any) {
        if lastSwipeViewtag <= ((totalCards-1) + 100){
            let cardToBack = view.viewWithTag(lastSwipeViewtag) ?? UIView()
            resetCard(cardView: cardToBack)
            lastSwipeViewtag = lastSwipeViewtag + 1
        }
        else{
            Common.alert(message: "You are at latest page.\nTry swiping some", vc: self)
        }
        
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
                UIView.animate(withDuration: 0.3, animations: {
                    cardView.center = CGPoint(x: cardView.center.x - 200, y: cardView.center.y + 75)
                    cardView.alpha = 0
                }) { (_) in
                    self.lastSwipeViewtag = cardView.tag
                    DispatchQueue.main.async {
                        self.lblCounter.text = "Showing page \(self.lastSwipeViewtag - 100) out of \(self.totalCards)"
                    }
                }
                return
            }
            else if cardView.center.x > (view.frame.width - 75){
                
                UIView.animate(withDuration: 0.3, animations: {
                    cardView.center = CGPoint(x: cardView.center.x + 200, y: cardView.center.y + 75)
                    cardView.alpha = 0
                }) { (_) in
                    self.lastSwipeViewtag = cardView.tag
                    DispatchQueue.main.async {
                        self.lblCounter.text = "Showing page \(self.lastSwipeViewtag - 100) out of \(self.totalCards)"
                    }
                }
                
                return
            }
            
            let viewToReset = view.viewWithTag(cardView.tag) ?? UIView()
            resetCard(cardView: viewToReset)
        }
    }
    
    
    func resetCard(cardView : UIView){
        UIView.animate(withDuration: 0.3, animations: {
            cardView.center = self.viewBasecard.center
            cardView.alpha = 1
            cardView.transform = .identity
        }) { (_) in
            DispatchQueue.main.async {
                self.lblCounter.text = "Showing page \(self.lastSwipeViewtag - 100) out of \(self.totalCards)"
            }
        }
        
    }
    
    
    // create stack of views and labels to swipe
    func createSwipableView(text : String, tag : Int){
        
        let viewNew = UIView()
        viewNew.backgroundColor = UIColor.systemYellow
        viewNew.layer.borderColor = UIColor.orange.cgColor
        viewNew.layer.borderWidth = 2.0
        viewNew.layer.cornerRadius = 10
        viewNew.tag = 100 + tag //adding an arbitary number 100 so that we can have unique tags for newly created swipe views
        viewNew.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewNew)
        viewNew.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        viewNew.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        viewNew.heightAnchor.constraint(equalToConstant: 360).isActive = true
        viewNew.widthAnchor.constraint(equalToConstant: 240).isActive = true
        
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        viewNew.addSubview(label)
        label.leadingAnchor.constraint(equalTo: viewNew.leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: viewNew.trailingAnchor, constant: 10).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        
        viewNew.isUserInteractionEnabled = true
        let panView = UIPanGestureRecognizer(target: self, action: #selector(panView(_:)))
        viewNew.addGestureRecognizer(panView)
        
    }
    
    
    //MARK: api call
    
    func fetchData(){
        // common networking function is called. And we'll get back a model if call and convestion is success otherwise we'll get error flag true and an error msg.
        viewLoader.isHidden = false
        BaseNetworking.fetch { (model, err, errMsg) in
            if !err{
                if !(model?.data?.isEmpty ?? false)
                {
                    self.totalCards = model?.data?.count ?? 0
                    self.lblCounter.text = "Showing \(self.totalCards) out of \(self.totalCards)"
                    self.lastSwipeViewtag = (self.totalCards + 100) //adding an arbitary number 100 so that we can have unique tags for newly created swipe views. Here we are setting lastSwipeViewtag to the latest page's tag.
                    for i in 0...(self.totalCards - 1){
                        self.createSwipableView(text: model?.data?[i].text ?? "", tag: i)
                    }
                    
                }
                self.viewLoader.isHidden = true
            }
            else{
                print("some error occured ===>>>", errMsg ?? "")
                self.viewLoader.isHidden = true
            }
        }
    }
}

