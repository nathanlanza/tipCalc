import UIKit

class TipViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tg = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tg)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tipPercentLabel.text = Lets.tipPercentageString
        billField.becomeFirstResponder()
    }
    
    func didTap() {
        billField.resignFirstResponder()
    }
    
    var context = CoreData.shared.context
    var tipItem: Tip? {
        didSet {
            guard let tipItem = self.tipItem else { return }
            
            print("hello")
            self.tipPercentage = tipItem.tipPercentage
            self.bill = tipItem.bill
            billField.text = "\(bill)"
        }
    }
    
    var tipPercentage: Double {
        get { return Lets.tipPercentage }
        set {
            Lets.tipPercentage = newValue
            tipPercentLabel.text = Lets.tipPercentageString
            billOrTipPercentageWasSet()
            guard let tipItem = tipItem else { return }
            context.perform {
                tipItem.tipPercentage = self.tipPercentage
                do {
                    try self.context.save()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    var bill = 0.0 {
        didSet {
            billOrTipPercentageWasSet()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        createNewTipItem()
    }
    
    func billOrTipPercentageWasSet() {
        tip = bill * tipPercentage
        totalBill = tip + bill
        billPerTwo = totalBill / 2
        billPerThree = totalBill / 3
        billPerFour = totalBill / 4
    }
    
    var tip = 0.0 { didSet { tipLabel.text = "\(tip)" } }
    var totalBill = 0.0 { didSet { totalLabel.text = "\(totalBill)" } }
    var billPerTwo = 0.0 { didSet { twoSplitLabel.text = "\(billPerTwo)" } }
    var billPerThree = 0.0 { didSet { threeSplitLabel.text = "\(billPerThree)" } }
    var billPerFour = 0.0 { didSet { fourSplitLabel.text = "\(billPerFour)" } }
    
    @IBOutlet weak var billField: UITextField! {
        didSet {
            billField.addTarget(self, action: #selector(update), for: UIControlEvents.editingChanged)
            billField.delegate = self
        }
    }
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipPercentLabel: UILabel! { didSet { tipPercentLabel.text = Lets.tipPercentageString } }
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var twoSplitLabel: UILabel!
    @IBOutlet weak var threeSplitLabel: UILabel!
    @IBOutlet weak var fourSplitLabel: UILabel!
    
    
    func update() {
        guard let billString = billField.text, let bill = Double(billString) else { return }
        self.bill = bill
    }
    
    func createNewTipItem() {
        guard tipItem?.bill != bill || tipItem?.tipPercentage != tipPercentage, bill != 0 else { return }
        self.context.perform {
            let tipItem = Tip(context: self.context)
            tipItem.date = Date()
            tipItem.bill = self.bill
            tipItem.tipPercentage = self.tipPercentage
            do {
                try self.context.save()
                self.tipItem = tipItem
            } catch {
                print(error)
            }
        }
    }
}

extension TipViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        createNewTipItem()
        
    }
}

extension TipViewController: UIPopoverPresentationControllerDelegate, HistoryTableViewControllerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "showHistory" else { return }
        let htvc = segue.destination as! HistoryTableViewController
        let ppc = htvc.popoverPresentationController
        ppc?.delegate = self
        let bbi = sender! as! UIBarButtonItem
        ppc?.barButtonItem = bbi
        
        let count = CGFloat((htvc.frc.fetchedObjects?.count)!)
        let height = 25 + 44 * max(min(count,10),4)
        print(count,height)
        htvc.preferredContentSize = CGSize(width: 200, height: height)
        htvc.modalTransitionStyle = .coverVertical
        htvc.modalPresentationStyle = .popover
        //htvc.isModalInPopover = true
        
        htvc.delegate = self
    }
    
    func htvc(_ htvc: HistoryTableViewController, willDismissWith tipItem: Tip) {
        self.tipItem = tipItem
        htvc.dismiss(animated: true)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
