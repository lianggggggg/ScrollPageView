//
//  ViewController.swift
//  ScrollPageView
//
//  Created by MrLiang on 2018/3/28.
//  Copyright © 2018年 MrLiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getColorRGBA(color: UIColor.red)
        
        ScrollPageSegmentView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40), titles: [], configuration: ScrollPageViewConfiguration()) { (xx, x) in
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnClick(_ sender: UIButton) {
        
        imageView.tintColor = UIColor.red
        
        
        
    }
    
    func getColorRGBA(color:UIColor) -> [CGFloat]{
        
        let numOfcomponents = color.cgColor.numberOfComponents
        
        var returnArr:[CGFloat] = []
        
        if numOfcomponents == 4 {
            var components = color.cgColor.components
            
            returnArr = NSArray.init(objects: components![0],components![1],components![2],components![3]) as! [CGFloat]
        }
        
        return returnArr
    }
    
}

