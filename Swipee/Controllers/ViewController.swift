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
        
        //0.61 is in radian which equals 35 degrees. since transformation angle accept value in radians only.
        // we want the view to rotate about 0.61 at the right most and left most point. But at the middel of the screen(width/2) it should have rotation angle to 0 and when the drag increases the rotation angle should increase to 0.61.
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
        
        let cardView = sender.view ?? UIView() // the view the gesture is attached to. set by adding the recognizer to a UIView using the addGestureRecognizer: method
        
        let point = sender.translation(in: view) // how far your finger has moved when you swipe
        
        let xFromCenter = cardView.center.x - view.center.x // to identify the amount of movement of cardView in x direction relative to it's parent view. So, that we can detect it's movement direction is left or right.
        
        cardView.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y) // making new center for the cardview relative to it's parent view and the point upto we dragged.It will allow to move the card around the screen.
        
        cardView.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor) // tilt a card to a certain degree. Here it's increasing and decreasing the tilt angle based on the position from X center .
        
        if sender.state == UIGestureRecognizer.State.ended{ // detect we have done dragging
            
            //animate the card off the screen if it passes a certain point. Assuming 75 points here. So, if it's get 75 points left or right we will continue animating off the screen right or left.
            if cardView.center.x < 75 {
                // move to left side of the screen
                UIView.animate(withDuration: 0.3, animations: {
                    
                    cardView.center = CGPoint(x: cardView.center.x - 200, y: cardView.center.y + 75) // sending the card to further left in x direction by 200 points after it crosses 75 points to the left
                    //adding 75 point to y gives a little fall effect downwards
                    
                    cardView.alpha = 0
                    
                }) { (_) in
                    
                    self.lastSwipeViewtag = cardView.tag
                    
                    DispatchQueue.main.async {
                        self.lblCounter.text = "Showing page \(self.lastSwipeViewtag - 100) out of \(self.totalCards)"
                    }
                }
                
                return // so the resetCard code don't get called
            }
            else if cardView.center.x > (view.frame.width - 75) { //to detect 75 to the right side of the screen
                // move to right side of the screen
                UIView.animate(withDuration: 0.3, animations: {
                    
                    cardView.center = CGPoint(x: cardView.center.x + 200, y: cardView.center.y + 75)// sending the card to further right in x direction by 200 points after it crosses 75 points to the right
                    //adding 75 point to y gives a little fall effect downwards
                    
                    cardView.alpha = 0
                }) { (_) in
                    
                    self.lastSwipeViewtag = cardView.tag
                    
                    DispatchQueue.main.async {
                        self.lblCounter.text = "Showing page \(self.lastSwipeViewtag - 100) out of \(self.totalCards)"
                    }
                }
                
                return // so the resetCard code don't get called
            }
            
            let viewToReset = view.viewWithTag(cardView.tag) ?? UIView()
            resetCard(cardView: viewToReset) // reset to main position if the cardView doesn't go left or right by 75 points or more
        }
    }
    
    
    func resetCard(cardView : UIView){
        UIView.animate(withDuration: 0.3, animations: {
            cardView.center = self.viewBasecard.center // resets cardview center to where it belonged
            cardView.alpha = 1
            cardView.transform = .identity // resets the tilt angle for cardView
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
                    self.lblCounter.text = "Showing page \(self.totalCards) out of \(self.totalCards)"
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

