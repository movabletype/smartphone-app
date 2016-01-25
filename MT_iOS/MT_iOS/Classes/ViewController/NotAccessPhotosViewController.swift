//
//  NotAccessPhotosViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2016/01/25.
//  Copyright © 2016年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class NotAccessPhotosViewController: UIViewController {
    @IBOutlet weak var text1Label: UILabel!
    @IBOutlet weak var text2Label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_close"), left: true, target: self, action: "closeButtonPushed:")
        
        text1Label.text = NSLocalizedString("This app does not have access to your photos or videos.", comment: "This app does not have access to your photos or videos.")
        text2Label.text = NSLocalizedString("You can enable access in Privacy Settings.", comment: "You can enable access in Privacy Settings.")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func closeButtonPushed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
