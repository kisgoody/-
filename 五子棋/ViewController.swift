//
//  ViewController.swift
//  五子棋
//
//  Created by EDF on 16/12/6.
//  Copyright © 2016年 EDF. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation


class ViewController: UIViewController,CheckerListener {
    @IBOutlet weak var checkerBg: 棋盘!
    var pieceDownAV,bgMusice:AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        initAVAudioPlayer()
        checkerBg.setOnCheckerListener(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    // 实例化音效
    func initAVAudioPlayer(){
       
        self.pieceDownAV = createMusic("098","wav")
        self.bgMusice = createMusic("bg_music","mp3")
        self.bgMusice.play()
    }
    
    func createMusic(name: String,_ type: String) -> AVAudioPlayer{
        var aVAudioPlayer: AVAudioPlayer?
        do{
            try aVAudioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType: type)!))
    
            }catch let error as NSError{
                print(error.localizedDescription)
        }
    
    return aVAudioPlayer!
    }

    func pieceDown(){
         self.pieceDownAV.play()
    }
    func pieceMoveStart(){
        
    }
    func pieceMoveEnd(){
        
    }
    func gameOver(wine: Int){//黑子：0，白子：1
        let str = wine == 0 ? "黑子":"白子"
        let controller = UIAlertController(title: "gamerOver", message: "\(str)获胜", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "确定", style: .Default) { (action: UIAlertAction) -> Void in
            controller.dismissViewControllerAnimated(true, completion: nil)
            self.checkerBg.reStart()
            
        }
        controller.addAction(ok)
//        controller.showViewController(self, sender: nil)
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    deinit{
    bgMusice.stop()
    }
    
}

