//
//  CurrencyModel.swift
//  Lab 3
//
//  Created by loaner on 10/18/23.
//

import UIKit

// A singleton class to handle the currency. This is used by both the view cotroller and the game scene
// to let the game know how many balls the user has to play with
class CurrencyModel: NSObject {
    
    // MARK: =====Class Variables=====
    static let shared = CurrencyModel(currency: 0)
    var currency:Float
    
    
    
    // MARK: =====Initializing=====
    private init(currency: Float)
    {
        self.currency = currency
    }
    
    
    
    // MARK: =====Currency Handling Methods=====
    func setCurrency(x:Float) { currency = x }
    func getCurrency() -> Float { return currency }
}
