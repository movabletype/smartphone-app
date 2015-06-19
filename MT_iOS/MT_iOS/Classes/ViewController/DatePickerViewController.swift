//
//  DatePickerViewController.swift
//  MT_iOS
//
//  Created by CHEEBOW on 2015/06/02.
//  Copyright (c) 2015年 Six Apart, Ltd. All rights reserved.
//

import UIKit

protocol DatePickerViewControllerDelegate {
    func datePickerDone(controller: DatePickerViewController, date: NSDate)
}

class DatePickerViewController: BaseViewController {
    enum DateTimeMode: Int {
        case Date = 0,
        Time,
        DateTime
    }
    
    var date: NSDate = NSDate()
    var delegate: DatePickerViewControllerDelegate?
    var initialMode: DateTimeMode = DateTimeMode.DateTime
    var navTitle = NSLocalizedString("Date", comment: "Date")
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var dateTimeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var setNowButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = Color.tableBg
        
        self.title = navTitle
        
        dateTimeSegmentedControl.setTitle(NSLocalizedString("Date", comment: "Date"), forSegmentAtIndex: 0)
        dateTimeSegmentedControl.setTitle(NSLocalizedString("Time", comment: "Time"), forSegmentAtIndex: 1)
        
        setNowButton.setTitle(NSLocalizedString("Set now", comment: "Set now"), forState: UIControlState.Normal)
        
        datePicker.date = date
        
        self.dateChanged()

        switch initialMode {
        case .Date:
            dateTimeSegmentedControl.setEnabled(true, forSegmentAtIndex: DateTimeMode.Date.rawValue)
            dateTimeSegmentedControl.setEnabled(false, forSegmentAtIndex: DateTimeMode.Time.rawValue)
            dateTimeSegmentedControl.selectedSegmentIndex = DateTimeMode.Date.rawValue
        case .Time:
            dateTimeSegmentedControl.setEnabled(false, forSegmentAtIndex: DateTimeMode.Date.rawValue)
            dateTimeSegmentedControl.setEnabled(true, forSegmentAtIndex: DateTimeMode.Time.rawValue)
            dateTimeSegmentedControl.selectedSegmentIndex = DateTimeMode.Time.rawValue
        case .DateTime:
            dateTimeSegmentedControl.setEnabled(true, forSegmentAtIndex: DateTimeMode.Date.rawValue)
            dateTimeSegmentedControl.setEnabled(true, forSegmentAtIndex: DateTimeMode.Time.rawValue)
            dateTimeSegmentedControl.selectedSegmentIndex = DateTimeMode.Date.rawValue
        }
        
        self.segmentValueChanged(dateTimeSegmentedControl)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonPushed:")
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
    
    private func dateChanged() {
        switch initialMode {
        case .Date:
            dateTimeLabel.text = Utils.mediumDateStringFromDate(datePicker.date)
        case .Time:
            dateTimeLabel.text = Utils.timeStringFromDate(datePicker.date)
        case .DateTime:
            dateTimeLabel.text = Utils.mediumDateTimeFromDate(datePicker.date)
        }
    }

    @IBAction func segmentValueChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case DateTimeMode.Date.rawValue:
            datePicker.datePickerMode = UIDatePickerMode.Date
        case DateTimeMode.Time.rawValue:
            datePicker.datePickerMode = UIDatePickerMode.Time
        default:
            break
        }
    }
    
    @IBAction func setNowButtonPushed(sender: AnyObject) {
        datePicker.date = NSDate()
        self.dateChanged()
    }
    
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
        self.dateChanged()
    }
    
    @IBAction func doneButtonPushed(sender: AnyObject) {
        self.delegate?.datePickerDone(self, date: datePicker.date)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
