//
//  DetailViewController.swift
//  MDTester
//
//  Created by Harlan.Howe on 3/5/15.
//  Copyright (c) 2015 Harlan.Howe. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var yearStepper: UIStepper!
    @IBOutlet weak var yearLabel: UILabel!
    


    var detailItem: Movie? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Movie = self.detailItem {
            if let tempTitleField = titleField
            {
                tempTitleField.text = detail.title
            }
            if let tempYearStepper = yearStepper
            {
                tempYearStepper.value = Double(detail.date)
            
                if let tempYearLabel = yearLabel
                {
                    tempYearLabel.text = "\(Int(tempYearStepper.value))"
                }
            }
        }
    }

    
    @IBAction func yearStepperChanged(sender: AnyObject) {
        yearLabel.text = "\(Int(yearStepper.value))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("Preparing to head back: \(segue.identifier)")
        if let detail = detailItem
        {
            if let tempTitleField = titleField
            {
                detail.title = tempTitleField.text
            }
            if let tempYearStepper = yearStepper
            {
                detail.date = Int16(tempYearStepper.value)
            }
        }
    }
}

