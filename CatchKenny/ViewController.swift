//
//  ViewController.swift
//  CatchKenny
//
//  Created by Enes Eray on 2.02.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var timer: Timer!
    
    var imageView: UIImageView!
    
    var score = 0
    var timerCounter = 10

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        startTimer()
        
        let defaults = UserDefaults.standard
        let currentScore = defaults.integer(forKey: "highScore")
        highScoreLabel.text = "High Score: \(currentScore)"
    }
    
    func startTimer() {
        timerCounter = 10
        timerLabel.text = String(timerCounter)
        score = 0
        scoreLabel.text = "Score: \(score)"
        
        timer = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc func fireTimer() {
        if timerCounter >= 0 {
            timerLabel.text = String(timerCounter)
            timerCounter -= 1

            if imageView != nil {
                imageView.removeFromSuperview()
            }

            let screenSize: CGRect = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height

            let randomX = CGFloat.random(in: 0..<screenHeight)
            let randomY = CGFloat.random(in: 0..<screenWidth)

            imageView = UIImageView(frame:CGRectMake(randomX, randomY, 100, 150));
            imageView.image = UIImage(named: "kenny")
            self.view.addSubview(imageView)

            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
        } else {
            timer.invalidate()
            
            let defaults = UserDefaults.standard
            
            let currentScore = defaults.integer(forKey: "highScore")
            if currentScore < score {
                defaults.set(score, forKey: "highScore")
                highScoreLabel.text = "High Score: \(score)"
            }
            
            let alert = UIAlertController(title: "Time's Up", message: "Do you want to play again?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Replay", style: .default, handler: { _ in
                self.startTimer()
            }))
            present(alert, animated: true)
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
}
