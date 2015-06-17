//
//  EntryHTMLEditorViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/05.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import ZSSRichTextEditor

class EntryHTMLEditorViewController: BaseViewController, UITextViewDelegate, AddAssetDelegate {
    var sourceView: ZSSTextView!

    var object: EntryTextAreaItem!
    var blog: Blog!
    var entry: BaseEntry!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = object.label

        // Do any additional setup after loading the view.
        self.sourceView = ZSSTextView(frame: self.view.bounds)
        self.sourceView.autocapitalizationType = UITextAutocapitalizationType.None
        self.sourceView.autocorrectionType = UITextAutocorrectionType.No
        //self.sourceView.font = UIFont.systemFontOfSize(16.0)
        self.sourceView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.sourceView.autoresizesSubviews = true
        self.sourceView.delegate = self
        self.view.addSubview(self.sourceView)
        
        self.sourceView.text = object.text
        self.sourceView.selectedRange = NSRange()

        let toolBar = UIToolbar(frame: CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0))
        let cameraButton = UIBarButtonItem(image: UIImage(named: "btn_camera"), left: true, target: self, action: "cameraButtonPushed:")
        let flexibleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var previewButton = UIBarButtonItem(image: UIImage(named: "btn_preview"), style: UIBarButtonItemStyle.Plain, target: self, action: "previewButtonPushed:")
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonPushed:")
        toolBar.items = [cameraButton, flexibleButton, previewButton, doneButton]
        self.sourceView.inputAccessoryView = toolBar
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveButtonPushed:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_arw"), left: true, target: self, action: "backButtonPushed:")

        self.sourceView.becomeFirstResponder()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
    
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration: NSTimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        
        var insets = self.sourceView.contentInset
        insets.bottom += keyboardFrame.size.height
        UIView.animateWithDuration(duration, animations:
            {_ in
                self.sourceView.contentInset = insets;
            }
        )
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration: NSTimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        
        var insets = self.sourceView.contentInset
        insets.bottom = 0
        UIView.animateWithDuration(duration, animations:
            {_ in
                self.sourceView.contentInset = insets;
            }
        )
    }
    
    @IBAction func saveButtonPushed(sender: UIBarButtonItem) {
        object.text = sourceView.text
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func doneButtonPushed(sender: UIBarButtonItem) {
        self.sourceView.resignFirstResponder()
    }
    
    private func showAssetSelector() {
        let storyboard: UIStoryboard = UIStoryboard(name: "ImageSelector", bundle: nil)
        let nav = storyboard.instantiateInitialViewController() as! UINavigationController
        let vc = nav.topViewController as! ImageSelectorTableViewController
        vc.blog = blog
        vc.delegate = self
        vc.showAlign = true
        vc.object = EntryImageItem()
        vc.entry = entry
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonPushed(sender: UIBarButtonItem) {
        self.showAssetSelector()
    }
    
    func AddAssetDone(controller: AddAssetTableViewController, asset: Asset) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let vc = controller as! ImageSelectorTableViewController
        let item = vc.object
        item.asset = asset
        let align = controller.imageAlign
        
        self.sourceView.replaceRange(self.sourceView.selectedTextRange!, withText: asset.imageHTML(align))
    }
    
    @IBAction func backButtonPushed(sender: UIBarButtonItem) {
        if self.sourceView.text == object.text {
            self.navigationController?.popViewControllerAnimated(true)
            return
        }
        
        Utils.confrimSave(self)
    }
    
    @IBAction func previewButtonPushed(sender: UIBarButtonItem) {
        let vc = PreviewViewController()
        let nav = UINavigationController(rootViewController: vc)

        var html = "<!DOCTYPE html><html><head><title>Preview</title><meta name=\"viewport\" content=\"width=device-width,initial-scale=1\"></head><body>"
        
        html += self.sourceView.text
        
        html += "</body></html>"

        vc.html = html
        self.presentViewController(nav, animated: true, completion: nil)
    }

}
