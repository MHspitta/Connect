//
//  ConnectViewController.swift
//  Connect
//
//  Created by Michael Hu on 07-06-18.
//  Copyright © 2018 Michael Hu. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var thumbImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Functions
    
    // Function to swipe
    @IBAction func SwipeCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        // Calculate how much the view is dragged and add that to the center
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        // Change the color and image of thumb
        if xFromCenter > 0 {
            thumbImage.image = #imageLiteral(resourceName: "thumbs-up-hand-symbol_318-41939")
            thumbImage.tintColor = UIColor.green
        } else {
            thumbImage.image = #imageLiteral(resourceName: "thumbs-down-512")
            thumbImage.tintColor = UIColor.red
        }
        
        // Change the intensity of the thumb color
        thumbImage.alpha = abs(xFromCenter) / view.center.x
        
        // Restore view to center after gesture ended
        if sender.state == UIGestureRecognizerState.ended {
            
            if card.center.x < 75 {
                
                // Move off to the left side
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                })
                return
                
            } else if card.center.x > (view.frame.width - 75 ) {
                
                // Move off to the right side
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                })
                return
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                card.center = self.view.center
                self.thumbImage.alpha = 0
            })
        }
    }
    @IBAction func reset(_ sender: UIButton) {
        resetCard()
    }
    
    // Function to reset the card
    func resetCard() {
        UIView.animate(withDuration: 0.2, animations: {
            self.card.center = self.view.center
            self.thumbImage.alpha = 0
            self.card.alpha = 1
        })
    }
}
