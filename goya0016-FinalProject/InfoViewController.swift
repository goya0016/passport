//
//  InfoViewController.swift
//  goya0016-FinalProject
//
//  Created by Nipun Goyal on 2020-12-14.
//

import UIKit

class InfoViewController: UIViewController {

    //created variable to hold data from previous view controller
    var jsonString:[String:Any]?
    //created variable to hold fetched data
    var fetchedData : [String:Any]?
    
    //connecting the outlet to the code
    @IBOutlet weak var showDetails: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(jsonString!["id"]!)
        let url: URL = URL(string: "http://lenczes.edumedia.ca/mad9137/final_api/passport/read/?id=\(jsonString!["id"]!)")!
        print(url)
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
        // Tell the task to run
        myTask.resume()
        // Do any additional setup after loading the view.
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
                    fetchedData =  try JSONSerialization.jsonObject(with: mydata, options: []) as? [String:Any]
                   print("Data: "+respondString)
                }catch let convertError{
//                        catch if there is any error
                    print(convertError.localizedDescription)
                }
            }}
    //checking if the array is not empty
            if let array = fetchedData {
                print(array)
                //continuing the function
             DispatchQueue.main.async() {
                //displaying the data in the text view
                self.showDetails.text = " ID: \(self.fetchedData!["id"]!) \n Title: \(self.fetchedData!["title"]!) \n Description: \(self.fetchedData!["description"]!) \n Longitude: \(self.fetchedData!["longitude"]!) \n Latitude: \(self.fetchedData!["latitude"]!) \n Arrival: \(self.fetchedData!["arrival"]!) \n Departure: \(self.fetchedData!["departure"]!) "
             }
             }
         else{
             print("jsonDictionary equals nil becasue converting JSON data has failed.")
         }
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
