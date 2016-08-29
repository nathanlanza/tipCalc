import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tipPercentageField: UITextField! {
        didSet {
            tipPercentageField.text = "\(Int(Lets.tipPercentage * 100))"
            tipPercentageField.addTarget(self, action: #selector(tipPercentageChanged), for: UIControlEvents.editingChanged)
        }
    }
    func tipPercentageChanged() {
        guard let string = tipPercentageField.text, let tipPercentage = Double(string) else { return }
        Lets.tipPercentage = tipPercentage / 100
    }

    @IBOutlet weak var daysToKeepHistoryField: UITextField! {
        didSet {
            daysToKeepHistoryField.text = "\(Int(Lets.amountOfDaysToKeep))"
            daysToKeepHistoryField.addTarget(self, action: #selector(daysToKeepHistoryChanged), for: UIControlEvents.editingChanged)
        }
    }

    func daysToKeepHistoryChanged() {
        guard let string = daysToKeepHistoryField.text, let daysToKeepHistory = Double(string) else { return }
        Lets.amountOfDaysToKeep = daysToKeepHistory
    }
    

}
