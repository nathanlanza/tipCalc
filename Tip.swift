import CoreData


public class Tip: NSManagedObject {
    @NSManaged var date: Date
    @NSManaged var bill: Double
    @NSManaged var tipPercentage: Double
    
    var cellString: String {
        return "Bill: \(bill), Tip: \(bill * tipPercentage)"
    }
}

extension Tip: ManagedObjectType {
    public static var entityName: String {
        return "Tip"
    }
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
}
