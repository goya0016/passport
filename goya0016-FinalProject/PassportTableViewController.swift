//
//  PassportTableViewController.swift
//  goya0016-FinalProject
//
//  Created by Nipun Goyal on 2020-12-14.
//

import UIKit

class PassportTableViewController: UITableViewController {

    //created the variable to hold the json data from server
    var fetchedData : [String:[[String:Any]]]?
    
    
    @IBAction func addNew(_ sender: Any) {
        //telling the button to unwind the segue
        performSegue(withIdentifier: "showAddView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    override func viewWillAppear(_ animated: Bool) {
//        self.tableView.reloadData();
        if let myUrl: URL = URL(string: "http://lenczes.edumedia.ca/mad9137/final_api/passport/read/") {
            // Create the request object passing it the url object
            var myURLRequest: URLRequest = URLRequest(url: myUrl)
            // Create authentication credentials as a string converted to utf8 encoded data
            let authString = "goya0016"
            if let utf8String = authString.data(using: String.Encoding.utf8) {
                // Convert the unicode data to base 64 bit encoded string
                let base64String = utf8String.base64EncodedString(options: .init(rawValue: 0))
                // Add the header key "Authorization" with the value of "Basic:" added before our converted data
                myURLRequest.addValue("Basic_" +  base64String, forHTTPHeaderField: "my-authentication")
            }
            // Create the URLSession object that will be used to make the requests
            let mySession: URLSession = URLSession.shared
            // Create a task from the session by passing in your request, and the callback handler
            let myTask = mySession.dataTask(with: myURLRequest, completionHandler: requestTask )
            // Tell the task to run
            myTask.resume()
        }
    }
    func requestTask(serverData:Data?,serverResponse:URLResponse?,serverError:Error?)->Void{
        //checking if there is no server error
        if serverError != nil{
            self.myDataDisplay(respondString:"",error: serverError!.localizedDescription)
        }else{
            //modifying the data as String and sending it to the next function
            let result = String(data:serverData!,encoding: .utf8)!
            self.myDataDisplay(respondString: result as String, error: nil)
        }
    }
    
    func myDataDisplay(respondString:String,error: String?){
        //checking for any server eerrors
        if(error != nil){
            print("Error:" + error!)
        }else{
            
            if let mydata:Data=respondString.data(using: String.Encoding.utf8){
                //using the do catch method to be on safe side
                do{
                    //parsing out json with jsonSerialisation
                    fetchedData =  try JSONSerialization.jsonObject(with: mydata, options: []) as? [String:[[String:Any]]]
//                   print("Data: "+respondString)
                }catch let convertError{
//                        catch if there is any error
                    print(convertError.localizedDescription)
                }
            }
    }
    //checking if the array is not empty
            if let array = fetchedData {
                print(array)
                //continuing the function
             DispatchQueue.main.async() {
                //reloading the data in the table with the reloadData
                self.tableView.reloadData();
//                tableView.deleteRows(at: [indexPath], with: .fade)
             }
             }
         else{
             print("jsonDictionary equals nil becasue converting JSON data has failed.")
         }
        }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return number of rows as the count of array
        return fetchedData?["locations"]?.count ?? 1
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        // Configure the cell...
        //setting the text label of each cell with the title from fetched data
        cell.textLabel?.text = fetchedData?["locations"]?[indexPath.row]["title"] as? String
        
        return cell
    }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInfoview"{
            //getting a copy of next view
            let nextViewController = segue.destination as? InfoViewController
            //getting the index for the selcted item
            let indexPathRow = tableView.indexPathForSelectedRow?.row
            //set the next view controllers variable with the same element as selected and passing the data
            nextViewController?.jsonString = fetchedData?["locations"]?[indexPathRow!]
        }
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //getting the is
            let id = fetchedData?["locations"]?[indexPath.row]["id"] as! Int
                //removing item from fetched data
            fetchedData?["locations"]?.remove(at:indexPath.row)
            //removing element from the ui
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            //doing the fetch and deletion from server
            if let url: URL = URL(string: "http://lenczes.edumedia.ca/mad9137/final_api/passport/delete/?id=\(id)"){
                var myURLRequest: URLRequest = URLRequest(url: url)
                // Create authentication credentials as a string converted to utf8 encoded data
                let authString = "goya0016"
                if let utf8String = authString.data(using: String.Encoding.utf8) {
                    // Convert the unicode data to base 64 bit encoded string
                    let base64String = utf8String.base64EncodedString(options: .init(rawValue: 0))
                    // Add the header key "Authorization" with the value of "Basic:" added before our converted data
                    myURLRequest.addValue("Basic_" +  base64String, forHTTPHeaderField: "my-authentication")
                }
                // Create the URLSession object that will be used to make the requests
                let mySession: URLSession = URLSession.shared
                // Create a task from the session by passing in your request, and the callback handler
                let myTask = mySession.dataTask(with: myURLRequest, completionHandler: requestTask )
                //running this function to reload the data and do the fetch again
                viewWillAppear(true)
                // Tell the task to run
                myTask.resume()
//                tableView.reloadData()
       
            // Delete the row from the data source
           
            
                
            }
            
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
