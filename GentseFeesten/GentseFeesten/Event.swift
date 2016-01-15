import Foundation
import UIKit
import MapKit

class Event {
    var activiteit_id: String = ""
    var titel: String = ""
    var datum: String = ""
    var startuur: String = ""
    var einduur: String = ""
    var straat: String = ""
    var postcode: String = ""
    var gemeente: String = ""
    var longitude: String = ""
    var latitude: String = ""
    var description: String = ""
    var omschrijving: String = ""
    var prijsadk: String = ""
    var prijsvvk: String = ""
    // Source: http://www.techotopia.com/index.php/An_Example_Swift_iOS_8_MKMapItem_Application
    var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(0.0), longitude: CLLocationDegrees(0.0))
    // http://stackoverflow.com/questions/27908219/parsing-json-date-to-swift
    
    init(){}
    
    init(activiteit_id: String, titel: String, omschrijving: String, datum: String, startuur: String, einduur: String, straat: String, postcode: String, gemeente: String, longitude: String, latitude: String, prijsadk: String, prijsvvk: String)
    {
        self.activiteit_id = activiteit_id
        self.titel = titel
        // na 45 tekens op nieuwe regel beginnen
        self.omschrijving = omschrijving
        self.datum = datum
        self.description = ""
        self.startuur = startuur
        self.einduur = einduur
        self.straat = straat
        self.postcode = postcode
        self.gemeente = gemeente
        self.longitude = longitude
        self.latitude = latitude
        self.prijsadk = prijsadk
        self.prijsvvk = prijsvvk
        if self.latitude != "" && self.longitude != ""{
            var long = Double(self.longitude)
            var lat = Double(self.latitude)
            if long == Double(self.longitude)!{
                if lat == Double(self.latitude)!{
                    self.coordinates = CLLocationCoordinate2DMake(CLLocationDegrees(lat!), CLLocationDegrees(long!))
                }
            }
            // Source: http://www.techotopia.com/index.php/An_Example_Swift_iOS_8_MKMapItem_Application
            //self.coordinates = CLLocationCoordinate2D(latitude: D, longitude: <#T##CLLocationDegrees#>)
        }
    }
}

extension Event: CustomStringConvertible { }

extension Event
{
    convenience init(json: NSDictionary) throws {
        
        guard let activiteit_id = json["activiteit_id"] as? String else {
            throw Service.Error.MissingJsonProperty(name: "activiteit_id")
        }
        var datum = json["datum"] as? String
        if (datum == "false"){
            datum = ""
        }
        if (datum == nil)
        {
            datum = ""
        }
        else{
            if let datumString = datum{
                datum = Datum(unixDate: datumString).getDateOrTimeFromUnixDate(true, getTime: false)
            }
        }
        guard let titel = json["titel"] as? String else {
            throw Service.Error.MissingJsonProperty(name: "titel")
        }
        var omschrijving = json["omschrijving"] as? String
        omschrijving = omschrijving?.stringByReplacingOccurrencesOfString("<p>", withString: "").stringByReplacingOccurrencesOfString("</p>", withString: "").stringByReplacingOccurrencesOfString("&quot;", withString: "'").stringByReplacingOccurrencesOfString("&amp;", withString: "&").stringByReplacingOccurrencesOfString("&nbsp;", withString: " ").stringByReplacingOccurrencesOfString("&rsquo;", withString: "'").stringByReplacingOccurrencesOfString("&#39;", withString: "'").stringByReplacingOccurrencesOfString("&ldquo;", withString: "'").stringByReplacingOccurrencesOfString("rdquo;", withString: "'").stringByReplacingOccurrencesOfString("lsquo;", withString: "'").stringByReplacingOccurrencesOfString("rsquo;", withString: "'").stringByReplacingOccurrencesOfString("!&euro;", withString: "€").stringByReplacingOccurrencesOfString("&copy!", withString: "©").stringByReplacingOccurrencesOfString("<br/>", withString: "\n")
        if (omschrijving == "false")
        {
            omschrijving = ""
        }
        if (omschrijving == nil){
            omschrijving = ""
        }
        var startuur = json["startuur"] as? String
        if (startuur == "false")
        {
            startuur = ""
        }
        if (startuur == nil){
            startuur = ""
        }
        
        var einduur = json["einduur"] as? String
        if (einduur == "false")
        {
            einduur = ""
        }
        if (einduur == nil){
            einduur = ""
        }
        var straat = json["straat"] as? String
        if (straat == "false")
        {
            straat = ""
        }
        if (straat == nil){
            straat = ""
        }
        var postcode = json["postcode"] as? String
        if (postcode == "false")
        {
            postcode = ""
        }
        if (postcode == nil){
            postcode = ""
        }
        var gemeente = json["gemeente"] as? String
        if (gemeente == "false")
        {
            gemeente = ""
        }
        if (gemeente == nil){
            gemeente = ""
        }
        var longitude = json["longitude"] as? String
        if (longitude == "false")
        {
            longitude = ""
        }
        if (longitude == nil){
            longitude = ""
        }
        var latitude = json["latitude"] as? String
        if (latitude == "false")
        {
            latitude = ""
        }
        if (latitude == nil){
            latitude = ""
        }
        
        var prijsVvk = json["prijs_vvk"]!.description as String
        
        if (prijsVvk == "false")
        {
            prijsVvk = "nvt"
        }
        if (prijsVvk == ""){
            prijsVvk = "nvt"
        }
        
        
        var prijsAdk = json["prijs"]!.description
        if (prijsAdk == "false")
        {
            prijsAdk = ""
        }
        else{
            if Double(prijsAdk) == 0.0{
                prijsAdk = "gratis"
            }
            else{
                prijsAdk = "€ \(prijsAdk)"
            }
        }
        
        if prijsVvk < prijsAdk{
            if prijsVvk == "0"{
                prijsVvk = "nvt"
            }
            else{
                prijsVvk = "€ \(prijsVvk)"
            }
        }
        
        
        let prijs = "Prijs vvk: \(prijsVvk) - Prijs adk: \(prijsAdk)"
            

        self.init(activiteit_id: activiteit_id, titel: titel, omschrijving: omschrijving!, datum: datum!, startuur: startuur!, einduur: einduur!, straat: straat!, postcode: postcode!, gemeente: gemeente!, longitude: longitude!, latitude: latitude!, prijsadk: prijsAdk, prijsvvk: prijsVvk)
    }
    
    }
