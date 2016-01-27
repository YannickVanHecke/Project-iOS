//
//  String.swift
//  GentseFeesten
//
//  Created by Yannick Van Hecke on 27/01/16.
//  Copyright © 2016 Yannick Van Hecke. All rights reserved.
//
// Source: http://svanimpe.be/blog/html-decoding.html
import Foundation

extension String {
    
    mutating func decodeHtmlCharacterReferences() {
        var decodedString = ""
        var reference = ""
        var inReference = false
        for character in self.characters {
            if inReference {
                reference.append(character)
                if character == ";" {
                    inReference = false
                    if let entity = entities[reference] {
                        decodedString.appendContentsOf(entity)
                    } else if reference.hasPrefix("&#x") {
                        let start = reference.startIndex.advancedBy(3)
                        let end = reference.endIndex.predecessor()
                        if let codePoint = Int(reference.substringWithRange(start..<end), radix: 16) {
                            decodedString.append(Character(UnicodeScalar(codePoint)))
                        }
                    } else if reference.hasPrefix("&#") {
                        let start = reference.startIndex.advancedBy(2)
                        let end = reference.endIndex.predecessor()
                        if let codePoint = Int(reference.substringWithRange(start..<end)) {
                            decodedString.append(Character(UnicodeScalar(codePoint)))
                        }
                    }
                }
            } else if character == "&" {
                reference = "&"
                inReference = true
            } else {
                decodedString.append(character)
            }
        }
        self = decodedString
    }
}

private let entities: [String: String] = {
    let fileName = NSBundle.mainBundle().pathForResource("entities", ofType: "json")!
    let fileData = NSData(contentsOfFile: fileName)!
    return try! NSJSONSerialization.JSONObjectWithData(fileData, options: NSJSONReadingOptions()) as! [String: String]
}()