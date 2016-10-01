# tipCalc
Tip calculator for CodePath

- implemented TabViewController and SettingsViewController
- pushed code to GitHub
- added README.md to the rep with GIF walkthrough

Extra features:
- Utilizes Core Data to remember previous bills. User can select the amount of days they wish to keep the tip/bill in their history.
- Uses NSFetchedResultsController and it's delegate to facilitate data management. 
- History is shown in a UITableViewController subclass in a popover presentation.
- UI is themed up to the limits of my non-artistic self.
- The UITextField for the bill is the firstResponder upon app launch so that the keyboard is shown immediately.
- App shows the dollar values for splitting the bill multiple ways.
- Locale support for currency symbols.

<img src="http://i.imgur.com/kfyPe3A.gif">
