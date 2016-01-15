//
//  DetailViewController.swift
//  GentseFeesten
//
//  Created by Yannick Van Hecke on 12/01/16.
//  Copyright © 2016 Yannick Van Hecke. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailBeschrijvingLabel: UILabel! // portrait
    @IBOutlet weak var detailBeschrijvingLabelCopie: UILabel! // landscape
    @IBOutlet weak var detailLocationMap: MKMapView!
    @IBOutlet weak var detailDatumStartuurEinduurLabel: UILabel!
    @IBOutlet weak var detailAdresLabel: UILabel!
    @IBOutlet weak var detailPrijsVVK: UILabel!
    @IBOutlet weak var detailPrijsADK: UILabel!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var detailItem: Event? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    // Source : http://stackoverflow.com/questions/30063986/swift-directions-to-selected-annotation-from-current-location-in-maps
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!,
        calloutAccessoryControlTapped control: UIControl!) {
            
            let selectedLoc = view.annotation
            
            print("Annotation '\(detailItem!.titel)' has been selected")
            
            let currentLocMapItem = MKMapItem.mapItemForCurrentLocation()
            
            let selectedPlacemark = MKPlacemark(coordinate: (detailItem?.coordinates)!, addressDictionary: nil)
            let selectedMapItem = MKMapItem(placemark: selectedPlacemark)
            
            let mapItems = [selectedMapItem, currentLocMapItem]
            
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            
            MKMapItem.openMapsWithItems(mapItems, launchOptions:launchOptions)
            print("MKMapItem.openMapsWithItems(mapItems, launchOptions:launchOptions)")
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            
            if let _ = self.detailLocationMap{
                // begin voorbeeldproject parkinglots
                let center = CLLocationCoordinate2D(latitude: Double(detail.latitude)!, longitude: Double(detail.longitude)!)
                let visibleRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
                detailLocationMap.region = visibleRegion
                let annotation = MKPointAnnotation()
                annotation.coordinate = center
                
                detailLocationMap.addAnnotation(annotation)
              //  detailLocationMapCopie.addAnnotation(annotation)
                // eind voorbeeldproject parkinglots
            }
            if let labeluur = self.detailDatumStartuurEinduurLabel{
                labeluur.text = "Wanneer: \(detail.datum)\(detail.startuur) - \(detail.einduur)"
            }
            if let labeladress = self.detailAdresLabel{
                if (detail.straat != "" && detail.postcode != "" && detail.gemeente != ""){
                    labeladress.text = "Waar: \(detail.straat), \(detail.postcode) \(detail.gemeente)"
                }
                else{
                    labeladress.text = "Geen adres gevonden "
                }
                
            }
            if let labelBeschrijving = self.detailBeschrijvingLabel {
                print("-- \(detail.omschrijving)")
                labelBeschrijving.text = detail.omschrijving
            }
            if let labelBeschrijving = self.detailBeschrijvingLabelCopie {
                print(detail.omschrijving)
                labelBeschrijving.text = detail.omschrijving
            }
            if let labelADK = self.detailPrijsADK{
                labelADK.text = "VVK: \(detail.prijsvvk) ADK: \(detail.prijsadk)"
            }
            if let labelVVK = self.detailPrijsVVK{
                labelVVK.text = "VVK: \(detail.prijsvvk) ADK: \(detail.prijsadk)"
            }
        
                        if let back = self.backButton{
                back.title = "Eventementen"
            }
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

