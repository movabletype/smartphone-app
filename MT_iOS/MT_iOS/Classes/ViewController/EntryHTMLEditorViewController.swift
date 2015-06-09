//
//  EntryHTMLEditorViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/05.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit
import ZSSRichTextEditor

class EntryHTMLEditorViewController: BaseViewController, UITextViewDelegate {
    var sourceView: ZSSTextView!

    var object: EntryTextAreaItem!
    
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "saveButtonPushed:")
        
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

}
