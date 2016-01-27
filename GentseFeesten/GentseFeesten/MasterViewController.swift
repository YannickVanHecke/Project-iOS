//
//  MasterViewController.swift
//  GentseFeesten
//
//  Created by Yannick Van Hecke on 12/01/16.
//  Copyright © 2016 Yannick Van Hecke. All rights reserved.
//

import UIKit
import SystemConfiguration

class MasterViewController: UITableViewController, UISplitViewControllerDelegate, UIAlertViewDelegate {

    var detailViewController: DetailViewController? = nil
    var events = [Event]()
    var eventsDictionary = [String: [Event]]()
    
    var currentTask = NSURLSessionTask()
    var sectionCounter = 0
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        /* Turn off the default generated constraints. */
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let c1 = NSLayoutConstraint(item: activityIndicator, attribute: .CenterX, relatedBy: .Equal, toItem: tableView, attribute: .CenterX, multiplier: 1, constant: 0)
        let c2 = NSLayoutConstraint(item: activityIndicator, attribute: .CenterY, relatedBy: .Equal, toItem: tableView, attribute: .CenterY, multiplier: 1, constant: 0)
        tableView.addSubview(activityIndicator)
        tableView.addConstraints([c1, c2])
        activityIndicator.startAnimating()
        if let _ = errorView{
        errorView.translatesAutoresizingMaskIntoConstraints = false
        }
        //let c3 = NSLayoutConstraint(item: errorView, attribute: .CenterX, relatedBy: .Equal, toItem: tableView, attribute: .CenterX, multiplier: 1, constant: 0)
        //let c4 = NSLayoutConstraint(item: errorView, attribute: .CenterY, relatedBy: .Equal, toItem: tableView, attribute: .CenterY, multiplier: 1, constant: 0)
        //let c5 = NSLayoutConstraint(item: errorView, attribute: .Width, relatedBy: .Equal, toItem: tableView, attribute: .Width, multiplier: 1, constant: -16)
        //let c6 = NSLayoutConstraint(item: errorView, attribute: .Height, relatedBy: .Equal, toItem: tableView, attribute: .Height, multiplier: 1, constant: 0)
        if let _ = errorView{
            tableView.addSubview(errorView)
            errorView.hidden = true
        }
        
        //tableView.addConstraints([c3, c4, c5, c6])
        
        
        // Do any additional setup after loading the view, typically from a nib.
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        // voorbeeldproject chamilo
        
        currentTask = Service.service.createFetchTask{
            
            [unowned self] result in switch result{
            case .Success(let eventsSucces):
                self.events = eventsSucces
                var assigment = self.events.sort{$0.titel < $1.titel}
                
                self.events = assigment
                // sorteren
                //var eventsSorted = [Event]()
                //eventsSorted = self.events.sort({ $0.datum < $1.datum})
                //self.events = eventsSorted
                
                
                // Array van Events omzetten naar Dictionary met key datum en value lijst van events.
                var index = 0
                var lengte = self.events.count - 1
                for index in 0...lengte{
                    var eventsForDate = [Event]()
                    var datum = self.events[index].datum
                    
                    for event in self.events{
                        if event.datum == datum{
                            eventsForDate.append(event)
                        }
                    }
                    
                    
                    self.eventsDictionary[datum] = eventsForDate
                }
                let keysSorted = Array(self.eventsDictionary.keys).sort(){$0 < $1}
                var dictionaryOrdered = [String: [Event]]()
                for key in keysSorted{
                    dictionaryOrdered[key] = self.eventsDictionary[key]
                }
                
                self.eventsDictionary = dictionaryOrdered
                
                // Source : http://stackoverflow.com/questions/33317083/swift-sort-dictionary-by-keys-or-by-values-and-return-ordered-array-of-keys?rq=1
                typealias DictSorter = ((String,[Event]),(String,[Event])) -> Bool
                let alphaAtoZ: DictSorter = { $0.0 < $1.0 }
                let listSelector: (String,[Event])->String = { $0.0 }
                
                let sortedDictionary = self.eventsDictionary.sort(alphaAtoZ).map(listSelector)
                
                self.tableView.reloadData()
                activityIndicator.stopAnimating()
            case .Failure(let error):
                if (self.isConnectedToNetwork() == false){
                    self.showPopupMessage("Mobiele data uitgeschakeld", message: "Schakel mobiel data in of gebruik Wi-Fi voor gegevenstoegang. Probeer hierna de applicatie terug op te starten")
                }
                else
                {
                    self.showPopupMessage("Geen verbinding mogelijk", message: "Momenteel kan er geen verbinding gemaakt worden met het dataplatform van de stad Gent. Probeer later eens opnieuw.")
                }
                activityIndicator.stopAnimating()
            }
            
        }
        currentTask.resume()
    }

    // Source: http://stackoverflow.com/questions/30743408/check-for-internet-connection-in-swift-2-ios-9
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   func insertNewevent(sender: AnyObject) {
    /*    events.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)*/
    }
    
    func showPopupMessage(title: String, message: String) -> Void{
        let alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "ok")
        alertView.show()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let section = indexPath.section
                let row = indexPath.row
                let key = Array(eventsDictionary.keys).sort()[section]
                let event = self.eventsDictionary[key]![row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = event
                controller.navigationItem.title = event.titel
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return eventsDictionary.keys.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(eventsDictionary.keys).sort()[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(eventsDictionary.keys).sort()[section]
        return (self.eventsDictionary[key]?.count)!
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let section = indexPath.section
        let row = indexPath.row
        let key = Array(eventsDictionary.keys).sort()[section]
        let event = self.eventsDictionary[key]![row]
        cell.textLabel!.text = event.titel
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            events.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
    
}

