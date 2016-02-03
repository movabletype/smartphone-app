//
//  EntryMarkdownEditorViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2016/02/03.
//  Copyright © 2016年 Six Apart, Ltd. All rights reserved.
//

import UIKit

class EntryMarkdownEditorViewController: EntryHTMLEditorViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let toolBar = UIToolbar(frame: CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0))
        let modeLabel = UILabel()
        modeLabel.text = "Markdown"
        modeLabel.sizeToFit()
        let modeButton = UIBarButtonItem(customView: modeLabel)
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let previewButton = UIBarButtonItem(image: UIImage(named: "btn_preview"), style: UIBarButtonItemStyle.Plain, target: self, action: "previewButtonPushed:")
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonPushed:")
        
        toolBar.items = [modeButton, flexibleButton, previewButton, doneButton]

        self.sourceView.inputAccessoryView = toolBar
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

    @IBAction override func previewButtonPushed(sender: UIBarButtonItem) {
        let vc = PreviewViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        var html = "<!DOCTYPE html><html><head><title>Preview</title><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"></head><body>"
        
        //TODO:Markdownフォーマット
        html += "# Markdown"
        html += self.sourceView.text
        
        html += "</body></html>"
        
        vc.html = html
        self.presentViewController(nav, animated: true, completion: nil)
    }
}
