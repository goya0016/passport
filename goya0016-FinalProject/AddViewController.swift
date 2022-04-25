//
//  AddViewController.swift
//  goya0016-FinalProject
//
//  Created by Nipun Goyal on 2020-12-14.
//

import UIKit
import CoreLocation

class AddViewController: UIViewController, CLLocationManagerDelegate {
    
    //created location manager object
    var myLocationManager = CLLocationManager()
    
    //connected the outlets and buttons to the code
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var ddescription: UITextView!
    @IBOutlet weak var arrivalDate: UIDatePicker!
    @IBOutlet weak var departureDate: UIDatePicker!
    
    //created variables
    var longitude:Any?
    var latitude:Any?
    
    var jsonString:String?
    var stringnew:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myLocationManager.delegate = self
        myLocationManager.requestWhenInUseAuthorization()
    }
  
    @IBAction func saveData(_ sender: Any) {
        
        //get the latitude and longitude
        if let location = myLocationManager.location {
           latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
     
        //checking if the text field is not empty
        if location.text != nil {
            //formatting the date using the correct format
            let formatting = DateFormatter()
            formatting.timeZone = .current
            formatting.dateFormat = "yyyy-MM-dd HH:mm"
            
            
            //let arrival = setDate(formatedDateString: arrivalDate.date.description)
//            print(arrival)
//            let departure = formatting.date(from: departureDate.date.description)
            
            //creating the json dictionary object
            let jsonData:[String:Any] = [
                "title":location.text!,
                "description":ddescription.text!,
                "longitude":longitude as Any,
                "latitude":latitude as Any,
                "arrival": "\(formatting.string(from: arrivalDate.date))",
                "departure":"\(formatting.string(from: departureDate.date))"]
            
            do{
                //doing the seialization of the json object
                let json :Data? = try JSONSerialization.data(withJSONObject: jsonData, options: [])
                jsonString = String(data:json!,encoding: .utf8)
                stringnew = (jsonString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!
            }catch{
                print("error")
            }
         //doing the fetch request
            if let url: URL = URL(string: "http://lenczes.edumedia.ca/mad9137/final_api/passport/create/?data="+stringnew){
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
                
            }
        }
            }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Switch on the state of the authorization to decide what to do.
        switch(CLLocationManager.authorizationStatus()) {
        case .restricted, .notDetermined, .denied :
            // If the user has not allowed access stop all updating.
            myLocationManager.stopUpdatingLocation()
        case .authorizedWhenInUse,  .authorizedAlways :
            // If the user has allowed access start updating the location of the device.
            myLocationManager.startUpdatingLocation()
        @unknown default:
            // Manage any future states to be exhaustive.
            location.text = "ERROR: Unable to access Location Manager"
        }
    }
    
    
    
    func requestTask(serverData:Data?,serverResponse:URLResponse?,serverError:Error?)->Void{
        //checking if there is no server error
        if serverError != nil{
            self.backHome(respondString:"",error: serverError!.localizedDescription)
        }else{
            //modifying the data as String and sending it to the next function
            let result = String(data:serverData!,encoding: .utf8)!
            self.backHome(respondString: result as String, error: nil)
        }
    }
    
    //
    func backHome(respondString: String, error: String?){
        if(error != nil){
            print("Error:" + error!)
        }else{
            //checking if the object was successfully created on the server without error
            DispatchQueue.main.async {
                //navigating back to the main page
                self.navigationController?.popToRootViewController(animated: true)
            }
        

        }
}
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    /*
    // MARK: - Navigation

     @IBOutlet weak var location: UITextField!
     @IBOutlet weak var description: UITextView!
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
