//
//  ViewController.swift
//  Todoey
//
//  Created by Akhil Khanna on 7/1/18.
//  Copyright © 2018 Akhil Khanna. All rights reserved.
//

import UIKit
import CoreData
class ToDoListViewController: UITableViewController{
    // changed from UIViewController to uitableviewcontroller because on our inital app load up, the user is looking at a table view controller instead of a regular view controller
    var itemArray = [Errand]()//NSManagedObject represents a single object
    var saveItemArray = [Errand]()
    var selectedCategory : Category?{
        didSet{
            loadItems()
            
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext//singleton that is shared amongst all classes and its used to tap into the lazy variable persistantStore inside of app delegate and it holds all of ur data
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadItems()
        tableView.reloadData()
    }
    func loadItems(with fetchRequest : NSFetchRequest<Errand> = Errand.fetchRequest(), predicate : NSPredicate? = nil){
       // let fetchRequest : NSFetchRequest<Errand> = Errand.fetchRequest()//you need to specify of data type of output
        //fetchRequest.returnsObjectsAsFaults = false
//        let categoryPredicate = NSPredicate(format: "parent.name MATCHES %@", selectedCategory!.title!)
//        if let additionalPredicate = predicate {
//            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
//            fetchRequest.predicate = compoundPredicate
//        }else{
//            fetchRequest.predicate = categoryPredicate
//        }
        do {
            //let fetchedResults = try context.fetch(fetchRequest)
            itemArray = try  context.fetch(fetchRequest) as! [ Errand]
        } catch {
            print(error)
        }
        var tempArray = [Errand]()
        for item in itemArray{
            if item.parent == selectedCategory! {
                tempArray.append(item)
            }
        }
        itemArray = tempArray
        tableView.reloadData()
    }
    @IBAction func goToAddController(_ sender: Any) {
        let alert = UIAlertController(title: "What do you have to do?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        var textFieldData = UITextField()
        alert.addAction(UIAlertAction(title: "Enter", style: .default, handler: { (alertAction) in
            //let textfieldData = alert.textFields![0].text
            if textFieldData.text != ""{
                let errand = Errand(context: self.context)
                errand.done = false
                errand.message = textFieldData.text!
                errand.parent = self.selectedCategory
                self.itemArray.append(errand)
                do
                {
                    try self.context.save()
                }
                catch{
                    print(error)
                }
            }
            self.tableView.reloadData()
        }))
        alert.addTextField { (textfield) in
            textfield.placeholder = "Add a future event"
            textFieldData = textfield
        }
        self.present(alert, animated: true, completion: nil)
        tableView.reloadData()
    
    
    
    //        if let item = defaults.array(forKey: "saveItemArray") as? [Errand] {
    //            itemArray = item
    //        }       // Do any additional setup after loading the view, typically from a nib.
    //let gesture = UITapGestureRecognizer(target: self, action: Selector?:userTappedTable)
}
var index = 0
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        do
        {
            try context.save()
        }
        catch{
            print(error)
        }
   
    //first your making a cell using cellforRowAt and then after u made that cell if u click on it this method happens. however, in this method we are changing the specific cell objects done value to true/false and then we need to retrigger the cellforrowat method so it can change that specific cell and create a checkmark or get rid of it. so we reload data as we did below.
    tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].message
    //we are now checking each cells done property which is why we dont have a check bug anymore. before we kept dequeuing reusable cells so random todoey items kept on getting checked because we were reusing the same cells.
    //value = condition ? valueiftrue : valueiffalse
    cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
   
    return cell
    }
}
//MARK: - search bar methods
extension ToDoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Errand> = Errand.fetchRequest()
        let predicate = NSPredicate(format: "message CONTAINS[cd] %@", searchBar.text!)//structured our query
        request.predicate = predicate// add our query to our request
        let sortDescripor = NSSortDescriptor(key: "message", ascending: true)//sorts the data that we get back from the data base in either ascending or descending
        request.sortDescriptors = [sortDescripor]//sort descriptors except an array since it is plural because it is like akhils or lebrons that means there are multiple lebrons which is liek an array
        do{
            itemArray = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
        //ns predicate cheat sheet
        //saveItemArray = itemArray
        //        let x = searchBar.text
        //        let string = x?.lowercased()
        //        var count = 0
        //        if(string!.count == 0) {
        //            return
        //        }
        //
        //
        //        for items in itemArray{
        //            if((items.message!.range(of: string!)) == nil){
        //                context.delete(items)
        //                itemArray.remove(at: count)
        //                count-=1
        //                do
        //                {
        //                    try context.save()
        //                }
        //                catch{
        //                    print(error)
        //                }
        //                tableView.reloadData()
        //            }
        //            count+=1
        //        }
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text!.count == 0){
            loadItems()
        }
    }
}



