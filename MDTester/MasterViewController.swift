//
//  MasterViewController.swift
//  MDTester
//
//  Created by Harlan.Howe on 3/5/15.
//  Copyright (c) 2015 Harlan.Howe. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects:Array<NSManagedObject> = []
    // create a variable to hold the saved object "scratchpad"
    var managedContext: NSManagedObjectContext?

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // grab "managedContext" a scratchpad for savable objects.
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        // write a request to get the list of all Movie entities
        let fetchRequest = NSFetchRequest(entityName: "Movie")
        
        // submit your request and store the result in the optional "fetchedResults"
        var error: NSError?
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]?
        
        // if the optional is filled, store the contents in "objects."
        if let results = fetchedResults
        {
            objects = results
        }
        else // otherwise, print an error message and leave the objects list alone.
        {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        managedContext = appDelegate.managedObjectContext!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        addMovie()
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Top)
        self.performSegueWithIdentifier("showDetail", sender: nil)
    }

    func addMovie()
    {
        // grab "managedContext" a scratchpad for savable objects.
//        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        let managedContext = appDelegate.managedObjectContext!
        
        // create a new "Movie" entity in the "managedContext" and grab the data storage portion of it (the attributes) as "movieInfo"
        let theMovie = NSEntityDescription.entityForName("Movie", inManagedObjectContext: managedContext!)
        let movieInfo = NSManagedObject(entity: theMovie!, insertIntoManagedObjectContext: managedContext!)
        
        // give the "movieInfo" some starting values.
        movieInfo.setValue("Untitled", forKey: "title")
        movieInfo.setValue(2015, forKey: "date")
        
        // add this object to the list of things to save and check to see whether anything has gone wrong....
        var error: NSError?
        let successfullySaved = managedContext!.save(&error)
        if successfullySaved == false
        {    println("Could not save \(error), \(error?.userInfo)")
        }
        
        // add this object to the list of objects.
        objects.insert(movieInfo, atIndex: 0)
        
        
    }
    
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("Segue preparing in Master.")
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = objects[indexPath.row] as NSManagedObject
                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    @IBAction func returnToMain(segue: UIStoryboardSegue)
    {
        println("returning to main view.")
        if let indexPath = tableView.indexPathForSelectedRow()
        {
            if let detailVC = segue.sourceViewController as? DetailViewController
            {
                objects[indexPath.row]=detailVC.detailItem!
            }
            println("changed item \(indexPath.row) to \(objects[indexPath.row].description).")
            tableView.reloadData()
            
            var error: NSError?
            let successfullySaved = managedContext!.save(&error)
            if successfullySaved == false
            {    println("Could not save \(error), \(error?.userInfo)")
            }
            
        }
        
        
        
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = objects[indexPath.row]
        cell.textLabel!.text = object.valueForKey("title") as String?
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

