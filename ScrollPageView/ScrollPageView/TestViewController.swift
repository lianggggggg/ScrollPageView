//
//  TestViewController.swift
//  ScrollPageView
//
//  Created by MrLiang on 2018/4/2.
//  Copyright © 2018年 MrLiang. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    
    var scrollPage:ScrollPageView?
    
    let configuration:[ScrollPageViewOption] = [
        .isShowCover(true),
        .segmentHeight(60),
        .isScaleTitleView(true),
        .scrollLineColor(.red)
    ]
    
    var controllers:[UIViewController] = [{let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Test2ViewController")
        vc.view.backgroundColor = .red
        return vc
        }(),{let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Test2ViewController")
            vc.view.backgroundColor = .green
            return vc
        }(),{let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Test2ViewController")
            vc.view.backgroundColor = .black
            return vc
        }(),{let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Test2ViewController")
            vc.view.backgroundColor = .yellow
            return vc
        }(),{let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Test2ViewController")
            vc.view.backgroundColor = .brown
            return vc
        }(),{let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Test2ViewController")
            vc.view.backgroundColor = .white
            return vc
        }(),{let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Test2ViewController")
            vc.view.backgroundColor = .gray
            return vc
        }()]
    var titles = ["1","2","3","4","5","6","7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scrollPage = ScrollPageView.init(frame: CGRect.init(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64))
        scrollPage?.configScrollPageView(parentViewController: self, viewControllers: controllers, pageMenuOptions: configuration)
        self.view.addSubview(scrollPage!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
