//
//  ViewController.swift
//  SpeedMeter
//
//  Created by Mustafa GUNES on 29.05.2018.
//  Copyright © 2018 Mustafa GUNES. All rights reserved.
//

import UIKit
import Lottie
import LTMorphingLabel
import CNPPopupController
import RevealingSplashView

class ViewController: UIViewController, SpeedNotifierDelegate, SpeedManagerDelegate {
    
    @IBOutlet weak var speedLabel: LTMorphingLabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    var popupController:CNPPopupController?
    let splashView = RevealingSplashView(iconImage: UIImage (named: "Icon-3x")!, iconInitialSize: CGSize (width: 70, height: 70), backgroundColor: UIColor.white)
    
    let speedManager = SpeedManager()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        speedManager.delegate = self
        SpeedNotifier.sharedNotifier().delegate = self
        
        self.view.addSubview(splashView)
        //splashView.duration = 0.9
        splashView.animationType = .heartBeat
        splashView.startAnimation()
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
            self.splashView.finishHeartBeatAnimation()
        }
        
        // Arkaplanda 2 saniye beklettikten sonra kodu çalıştırıyor. Ve diğer uyg. çakışmıyor !!
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            if CLLocationManager.locationServicesEnabled() {
                print("Konum Açık !")
            }
            else {
                self.lottieAnimation()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                if CLLocationManager.locationServicesEnabled() {
                    print("Konum Açık PinJump!")
                }
                else {
                    self.showPopupWithStyle(CNPPopupStyle.actionSheet)
                }
            })
        })
    }
    
    
    @IBAction func toggleNotificationsSwitch(_ sender: UISwitch) {
        SpeedNotifier.sharedNotifier().shouldNotify = sender.isOn
    }
    
    func speedDidChange(_ speed: Speed) {
        speedLabel.text = String(Int(speed))
    }
    
    func notificationsStatusDidChange(_ shouldNotify: Bool) {
        notificationSwitch?.isOn = shouldNotify
    }
    
    override var prefersStatusBarHidden: Bool {
        return !UIApplication.shared.isStatusBarHidden
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }
    
    func showPopupWithStyle(_ popupStyle: CNPPopupStyle) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraphStyle.alignment = NSTextAlignment.center
        
        let title = NSAttributedString(string: "Konuma ihtiyacım var 🙏", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 24), NSParagraphStyleAttributeName: paragraphStyle])
        let lineOne = NSAttributedString(string: "You can add text and images", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18), NSParagraphStyleAttributeName: paragraphStyle])
        
        let button = CNPPopupButton.init(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Konumu AÇ", for: UIControlState())
        
        button.backgroundColor = UIColor.init(colorLiteralRed: 0.46, green: 0.8, blue: 1.0, alpha: 1.0)
        
        button.layer.cornerRadius = 4;
        button.selectionHandler = { (button) -> Void in
            self.popupController?.dismiss(animated: true)
            print("Block for button: \(String(describing: button.titleLabel?.text))")
        }
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0;
        titleLabel.attributedText = title
        
        let lineOneLabel = UILabel()
        lineOneLabel.numberOfLines = 0;
        lineOneLabel.attributedText = lineOne;
        
        let imageView = UIImageView.init(image: UIImage.init(named: "icon"))
        
        let popupController = CNPPopupController(contents:[titleLabel, lineOneLabel, imageView, button])
        popupController.theme = CNPPopupTheme.default()
        popupController.theme.popupStyle = popupStyle
        // LFL added settings for custom color and blur
        popupController.theme.maskType = CNPPopupMaskType.custom
        popupController.theme.customMaskColor = UIColor(white: 1, alpha: 0.0)
        popupController.theme.blurEffectAlpha = 0.0
        popupController.delegate = self
        self.popupController = popupController
        popupController.present(animated: true)
    }

    func lottieAnimation() {
        
        let animationView = LOTAnimationView(name: "PinJump")
        animationView.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        animationView.loopAnimation = true
        animationView.animationSpeed = 0.8
        
        // Applying UIView animation
        let minimizeTransform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        animationView.transform = minimizeTransform
        UIView.animate(withDuration: 3.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            animationView.transform = CGAffineTransform.identity
        }, completion: nil)
        
        view.addSubview(animationView)
        animationView.play()
    }
}

extension ViewController : CNPPopupControllerDelegate {
    
    func popupControllerWillDismiss(_ controller: CNPPopupController) {
        print("Popup controller will be dismissed")
    }
    
    func popupControllerDidPresent(_ controller: CNPPopupController) {
        print("Popup controller presented")
    }
}
