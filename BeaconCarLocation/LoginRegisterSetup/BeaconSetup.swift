//
//  ViewController.swift
//  BeaconCarLocation
//
//  Created by Mek on 03/03/18.
//  Copyright © 2018 Mek. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseAuth
import UserNotifications

class BeaconSetup: UIViewController, CLLocationManagerDelegate
{
    var locationManager: CLLocationManager = CLLocationManager()
    
    var model: Model?
    var uuid: String?
    {
        didSet
        {
            guard let UUID = uuid else { return }
            
            DataManager.shared.array.insert(UUID, at: 1)
            debugPrint(UUID)
            debugPrint(DataManager.shared.array[1])
        }
    }
    
    var major: String?
    {
        didSet
        {
            guard let MAJOR = major else { return }
            debugPrint(MAJOR)
            DataManager.shared.array.insert(MAJOR, at: 2)
        }
    }
    
    
    
    var minor: String?
    {
        didSet
        {
            guard let MINOR = minor else
            {
                activity.stopAnimating()
                greyView.alpha = 0
                return
                
            }
            activity.stopAnimating()
            greyView.alpha = 0
            DataManager.shared.array.insert(MINOR, at: 3)
            assegnoValori()
            debugPrint(DataManager.shared.array.count)
            if (DataManager.shared.array.count == 4)
            {
                ceckData()
            }
            
        }
    }
    


    override func viewDidAppear(_ animated: Bool)
    {
        print("Prova\(DataManager.shared.array[0])")
        ceckLogged()
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.prefersLargeTitles = false
        view.isUserInteractionEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("SALVA", comment: ""), style: .plain, target: self, action: #selector(handleSave))
        navigationItem.hidesBackButton = true
        view.backgroundColor = UIColor(r: 69, g: 99, b: 162)
        navigationController?.navigationBar.tintColor = UIColor(r: 69, g: 99, b: 162)
        self.tabBarController?.tabBar.isHidden = true
        view.addSubview(inputContainerView)
        view.addSubview(errorInput)
        
        greyView.frame = view.frame
        view.addSubview(greyView)
        view.addSubview(activity)
        
        constrainsLabelSave()
        constrainsInputContainerView()
        tastiera()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways)
        {
            locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        locationManager.allowsBackgroundLocationUpdates = true
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in }
        
 
    }
    
    
    var greyView: UIView = {
        var greyView = UIView()
        greyView.backgroundColor = .black
        greyView.alpha = 0
        return greyView
    }()
    
    lazy var activity: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.center = view.center
        activity.color = UIColor.white
        activity.hidesWhenStopped = true
        return activity
    }()
 
    let errorInput: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("CTC", comment: "")
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var uuidTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "UUID"
        textField.adjustsFontSizeToFitWidth = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var majorValueTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Major Value"
        textField.keyboardType = UIKeyboardType.numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
        }() {
        didSet {
            print("CIAONE")
        }
    }
    
    lazy var minorValueTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Minor Value"
        textField.keyboardType = UIKeyboardType.numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        return textField
    }()
    
    lazy var uuidSeparatoreView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var majorSeparatoreView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    func constrainsLabelSave()
    {
        errorInput.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorInput.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 30).isActive = true
        errorInput.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        errorInput.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func constrainsInputContainerView()
    {
        //Constrains: x, y, width, height
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        inputContainerView.addSubview(uuidTextField)
        uuidTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        uuidTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        uuidTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        uuidTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        inputContainerView.addSubview(uuidSeparatoreView)
        uuidSeparatoreView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        uuidSeparatoreView.topAnchor.constraint(equalTo: uuidTextField.bottomAnchor).isActive = true
        uuidSeparatoreView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        uuidSeparatoreView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputContainerView.addSubview(majorValueTextField)
        majorValueTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        majorValueTextField.topAnchor.constraint(equalTo: uuidTextField.bottomAnchor).isActive = true
        majorValueTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        majorValueTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        inputContainerView.addSubview(majorSeparatoreView)
        majorSeparatoreView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        majorSeparatoreView.topAnchor.constraint(equalTo: majorValueTextField.bottomAnchor).isActive = true
        majorSeparatoreView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        majorSeparatoreView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        inputContainerView.addSubview(minorValueTextField)
        minorValueTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        minorValueTextField.topAnchor.constraint(equalTo: majorValueTextField.bottomAnchor).isActive = true
        minorValueTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        minorValueTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true

    }
    
    func tastiera() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.uuidTextField.inputAccessoryView = keyboardToolbar
        self.majorValueTextField.inputAccessoryView = keyboardToolbar
        self.minorValueTextField.inputAccessoryView = keyboardToolbar
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange()
    {
        debugPrint("YESSSSS")
    }
    
    
    @objc func handleSave()
    {
        if (uuidTextField.text?.isEmpty == true || majorValueTextField.text?.isEmpty == true || minorValueTextField.text?.isEmpty == true)
        {
            self.errorInput.alpha = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
            {
                UIView.animate(withDuration: TimeInterval(0.5), animations: { self.errorInput.alpha = 0})
            }
        }
        else
        {
            let datiBeacon = Model(uuid: uuidTextField.text!, majorValue: majorValueTextField.text!, minorValue: minorValueTextField.text!)
//            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let usersReferences = Firebase.beaconSettings()
            let values = ["uuid": datiBeacon.uuid, "major value": datiBeacon.majorValue, "minor value": datiBeacon.minorValue ]
            usersReferences.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if (error != nil)
                {
                    debugPrint(error!)
                }
                DataManager.shared.array = [Firebase.uidUser(), datiBeacon.uuid, datiBeacon.majorValue, datiBeacon.minorValue]
                DataManager.shared.salva()
                self.rangeBeacons()
                self.present(TabBarController(), animated: true, completion: nil)
            })
        }
        
        
    }
    func ceckLogged()
    {
        if Auth.auth().currentUser?.uid == nil
        {
            self.present(LoginRegisterController(), animated: false, completion: nil)
        }
        else
        {
            
            if (Auth.auth().currentUser?.uid == DataManager.shared.array[0] && DataManager.shared.array.count == 4 )
            {
                uuidTextField.text = DataManager.shared.array[1]
                majorValueTextField.text = DataManager.shared.array[2]
                minorValueTextField.text = DataManager.shared.array[3]
                ceckData()
            }
            else
            {
                self.activity.startAnimating()
                self.greyView.alpha = 0.5
                
                
                DispatchQueue.global().sync
                    {
                        
                        let usersReferences = Firebase.beaconSettings()
                        
                        usersReferences.child("uuid").observe(.value) { (snapshot) in
                            let coordLat = snapshot.value
                            self.uuid = coordLat as? String
                            
                        }
        
                        usersReferences.child("major value").observe(.value) { (snapshot) in
                            let coordLat = snapshot.value
                            self.major = coordLat as? String
                            
                        }
                        
                        usersReferences.child("minor value").observe(.value) { (snapshot) in
                            let coordLat = snapshot.value
                            self.minor = coordLat as? String
                            
                        }
                        
                        
                }

            }
        }
    }
    
    func assegnoValori()
    {
        self.uuidTextField.text = self.uuid
        self.majorValueTextField.text = self.major
        self.minorValueTextField.text = self.minor
        DataManager.shared.array[0] = Firebase.uidUser()
    }
    
    
    @objc func keyboardWillShow(sender: NSNotification)
    {
        self.view.frame.origin.y = -115
        
    }
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func ceckData()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            if (self.uuidTextField.text?.isEmpty != true && self.majorValueTextField.text?.isEmpty != true && self.minorValueTextField.text?.isEmpty != true && DataManager.shared.present == 0)
            {
                self.view.isUserInteractionEnabled = false
                DataManager.shared.present = 0
                self.handleSave()
            }
            else
            {
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    var newLocation: CLLocationCoordinate2D?
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]
        newLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
    {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("WE", comment: "")
        content.body = NSLocalizedString("IN", comment: "")
        content.sound = .default()
        let request = UNNotificationRequest(identifier: "Beacon", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        locationManager.startUpdatingLocation()
        
        let usersReferences = Firebase.coordinate()
        let values = ["Latitudine": Double(0), "Longitudine": Double(0)]
        usersReferences.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if (error != nil)
            {
                debugPrint(error!)
            }
            
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
    {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("GO", comment: "")
        content.body = NSLocalizedString("OUT", comment: "")
        content.sound = .default()
        let request = UNNotificationRequest(identifier: "Beacon", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        locationManager.stopUpdatingLocation()
        
        if (self.newLocation != nil)
        {
            let usersReferences = Firebase.coordinate()
            let values = ["Latitudine": Double((self.newLocation?.latitude)!), "Longitudine": Double((self.newLocation?.longitude)!)]
            usersReferences.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if (error != nil)
                {
                    debugPrint(error!)
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        rangeBeacons()
    }
    
    func rangeBeacons()
    {
        if (DataManager.shared.array.count == 4)
        {
            guard let codice: UUID = UUID(uuidString: String(DataManager.shared.array[1])) else { return }
            guard let major: CLBeaconMajorValue = CLBeaconMajorValue(DataManager.shared.array[2]) else { return }
            guard let minor: CLBeaconMinorValue = CLBeaconMinorValue(DataManager.shared.array[3]) else { return }
            if (codice.uuidString.isEmpty == false && major >= 0 && minor >= 0)
            {
                debugPrint(codice, major , minor)
                let region = CLBeaconRegion(proximityUUID: codice, major: CLBeaconMajorValue(major), minor: CLBeaconMinorValue(minor) , identifier: "Beacon")
                region.notifyOnEntry = true
                region.notifyEntryStateOnDisplay = true
                region.notifyOnExit = true
                locationManager.startRangingBeacons(in: region)
                locationManager.startMonitoring(for: region)
            }
        }
    }

    
   

}
