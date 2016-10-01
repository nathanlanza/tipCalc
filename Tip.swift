import CoreData


public class Tip: NSManagedObject {
    @NSManaged var date: Date
    @NSManaged var bill: Double
    @NSManaged var tipPercentage: Double
    
    var cellString: String {
        return "Bill: " + string(from: bill) + ", Tip: " + string(from: bill * tipPercentage)
    }
    
    var nf: NumberFormatter = {
        let nf = NumberFormatter()
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        nf.minimumIntegerDigits = 1
        nf.alwaysShowsDecimalSeparator = true
        nf.locale = Locale.current
        nf.numberStyle = .currency
        return nf
    }()
    
    func string(from double: Double) -> String {
        return nf.string(from: NSNumber(value: double))!
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
