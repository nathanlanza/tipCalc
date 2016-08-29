import UIKit
import CoreData

class HistoryTableViewController: UITableViewController {
    
    let context = CoreData.shared.context
    var frc: NSFetchedResultsController<Tip>
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        try! frc.performFetch()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        let request = Tip.request
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try frc.performFetch()
        } catch {
            print(error)
            fatalError("??")
        }
        super.init(coder: aDecoder)
        frc.delegate = self
        
        frc.fetchedObjects?.forEach { object in
            let interval = 60 * 60 * 24 * Lets.amountOfDaysToKeep
            let olderThan = object.date.compare(Date().addingTimeInterval(-interval))
            if olderThan == .orderedAscending {
                context.perform {
                    self.context.delete(object)
                }
            }
        }
        context.perform {
            try! self.context.save()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 43
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = frc.sections else { print(#function, "frc didn't exist"); return 0 }
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sec = frc.sections?[section] else { print(#function, "frc didn't exist"); return 0 }
        return sec.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let tipItem = frc.object(at: indexPath)
        cell.textLabel?.text = tipItem.cellString
        cell.detailTextLabel?.text = Lets.df.string(from: tipItem.date)

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "History"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tipItem = frc.object(at: indexPath)
        delegate.htvc(self, willDismissWith: tipItem)
        
    }
    
    var delegate: HistoryTableViewControllerDelegate!
}

extension HistoryTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard type == .insert, let newIndexPath = newIndexPath else { return }
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}


protocol HistoryTableViewControllerDelegate {
    func htvc(_ htvc: HistoryTableViewController, willDismissWith tipItem: Tip)
}
