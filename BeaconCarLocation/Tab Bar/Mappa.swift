//
//  Mappa.swift
//  BeaconCarLocation
//
//  Created by Mek on 03/03/18.
//  Copyright © 2018 Mek. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class Mappa: UIViewController
{
    static let shared = Mappa()
    
    var latitudine: CLLocationDegrees?
    {
        didSet
        {
            addPosizione()
            
        }
    }
    var longitudine: CLLocationDegrees?
    {
        didSet
        {
            activity.stopAnimating()
            greyView.alpha = 0
            addPosizione()
        }
    }
  
    lazy var mappa: MKMapView = {
        let mappa = MKMapView()
        mappa.mapType = MKMapType.standard
        mappa.isZoomEnabled = true
        mappa.isScrollEnabled = true
        mappa.frame = view.frame
        mappa.showsUserLocation = true
        return mappa
    }()
    
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
    
    override func viewDidAppear(_ animated: Bool)
    {
        debugPrint(DataManager.shared.array)
        coordinateBeacon()
    }

    override func viewDidLoad()
    {
        view.addSubview(mappa)
        greyView.frame = view.frame
        view.addSubview(greyView)
        view.addSubview(activity)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(addPosizione))
        navigationItem.title = NSLocalizedString("MAPPA", comment: "")
        
    }
    
    @objc func coordinateBeacon()
    {
        activity.startAnimating()
        greyView.alpha = 0.5
        DispatchQueue.global().async
        {
            
            let usersReferences = Firebase.coordinate()
            
            usersReferences.child("Latitudine").observe(.value) { (snapshot) in
                let coordLat = snapshot.value
                self.latitudine = coordLat as? CLLocationDegrees
                
            }
            
            usersReferences.child("Longitudine").observe(.value) { (snapshot) in
                let coordLong = snapshot.value
                self.longitudine = coordLong as? CLLocationDegrees
                
            }
        }
    }
    
    @objc func addPosizione()
    {
        if (self.latitudine != nil && self.longitudine != nil)
        {
            if (self.latitudine != 0 && self.longitudine != 0)
            {
                let annotation = mappa.annotations
                if (annotation.count > 1)
                {
                    mappa.removeAnnotations(annotation)
                }
                let coordinateFisse = CLLocationCoordinate2D(latitude: self.latitudine!, longitude: self.longitudine!)
                let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
                let region : MKCoordinateRegion = MKCoordinateRegionMake(coordinateFisse, span)
                mappa.setRegion(region, animated: true)
                
                let location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.latitudine!, self.longitudine!)
                let point = MKPointAnnotation()
                
                point.coordinate = location
                point.title = NSLocalizedString("MC", comment: "")
                mappa.addAnnotation(point)
            }
            else
            {
                let annotation = self.mappa.annotations
                if (annotation.count > 0)
                {
                    self.mappa.removeAnnotations(annotation)
                }
            }
            
        }
        else
        {
            
            return
        }
    }
  
}
