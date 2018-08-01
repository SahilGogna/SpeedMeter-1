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
import AVFoundation

class ViewController: UIViewController, SpeedNotifierDelegate, SpeedManagerDelegate {
    
    @IBOutlet weak var speedLabel: LTMorphingLabel!
    @IBOutlet weak var kmHLabel: UILabel!
    @IBOutlet weak var notificationInfoLabel: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    var player: AVAudioPlayer?

    var popupController:CNPPopupController?
    
    let splashView = RevealingSplashView(iconImage: UIImage (named: "Icon-3x")!, iconInitialSize: CGSize (width: 70, height: 70), backgroundColor: UIColor.white)
    let speedManager = SpeedManager()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        speedManager.delegate = self
        SpeedNotifier.sharedNotifier().delegate = self
        
        speedLabel.morphingEffect = .evaporate
        
        self.view.addSubview(splashView)
        //splashView.duration = 0.9
        splashView.animationType = .heartBeat
        splashView.startAnimation()
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
            self.splashView.finishHeartBeatAnimation()
        }
        
        // Information : Hızı arkaplanda kontrol ederek gerekli değişiklikler yapılıyor. (BackgroundColor vs...)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
                if CLLocationManager.locationServicesEnabled() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                        if (self.speedLabel.text == "- - -") {
                            // skip;
                        }
                        else {
                            if (Int(self.speedLabel.text)! > 120) {
                                print("kırmızı")
                                self.kmHLabel.textColor = UIColor.white
                                self.speedLabel.textColor = UIColor.white
                                self.notificationInfoLabel.textColor = UIColor.white
                                self.view.backgroundColor = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)
                            }
                            else {
                                print("yeşil")
                                self.kmHLabel.textColor = UIColor.white
                                self.speedLabel.textColor = UIColor.white
                                self.notificationInfoLabel.textColor = UIColor.darkText
                                self.view.backgroundColor = UIColor(red:0.37, green:0.73, blue:0.49, alpha:1.0)
                            }
                        }
                    })
                }
            }
        })
        
        // Information :  Arkaplanda 2 saniye beklettikten sonra kodu çalıştırıyor. Ve diğer uyg. çakışmıyor !!
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            if CLLocationManager.locationServicesEnabled() {
                print("Konum Açık !")
            }
            else {
                
                self.kmHLabel.isHidden = true
                self.speedLabel.isHidden = true
                self.notificationSwitch.isHidden = true
                self.notificationInfoLabel.isHidden = true
                
                self.lottieAnimation()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
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
    
    // TODO : Hız aşımı anında bidirim methodu
    
    func buttonPressed(){
        
        if CLLocationManager.locationServicesEnabled() {
            //
        }
        else {
            
            let alertControllerOpenLocation = UIAlertController(title: "Dikkat", message: "Konumu Açmalısın!", preferredStyle: .alert)
            
            if CLLocationManager.locationServicesEnabled() {
                
                self.dismiss(animated: true, completion: nil)
                //DispatchQueue
            }
            else {
                
                let okActionLocation = UIAlertAction(title: "TAMAM", style: .default) { (okLocation) in
                    
                    let locUrl = "App-Prefs:root=Privacy&path=LOCATION_SERVICES"
                    if let url = URL (string: "\(locUrl)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                
                alertControllerOpenLocation.addAction(okActionLocation)
                self.present(alertControllerOpenLocation, animated: true, completion: nil)
            }
        }
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
        button.addTarget(self, action: #selector(ViewController.buttonPressed), for: .touchUpInside)
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
        
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { (pinJump) in
            if CLLocationManager.locationServicesEnabled() {
                print("Animasyon kontrol başarılı !")
                animationView.stop()
                animationView.isHidden = true
                
                self.kmHLabel.isHidden = false
                self.speedLabel.isHidden = false
                self.notificationSwitch.isHidden = false
                self.notificationInfoLabel.isHidden = false
                
                let alertController = UIAlertController(title: "Dikkat", message: "Özelliklerin verimli çalışması için uygulamayı yeniden başlatmalısın!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "TAMAM", style: .default) { (ok) in
                    exit(0)
                }
                let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel) { (cancel) in
                    print("Cancel")
                }
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
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
