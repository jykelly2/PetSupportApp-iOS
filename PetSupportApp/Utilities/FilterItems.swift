//
//  FilterItems.swift
//  PetSupportApp
//
//  Created by Enam on 8/14/21.
//  Copyright © 2021 Jun K. All rights reserved.
//

import UIKit

class FilterItems: NSObject {
    static let shared   : FilterItems        = FilterItems()
    var filterItemArray       : [FilterMenu] = []

    func addItem(_ item:String){
        let items = filterItemArray.filter { $0.title == item}
        if items.count == 0 {
            filterItemArray.append(FilterMenu(title: item, modalMenu: .Filter))
        }
        print("filterItemArray:\(filterItemArray.count) \(item)")
    }
    
    func removeItem(_ item:String){
            filterItemArray = filterItemArray.filter { $0.title != item}
        print("filterItemArray:\(filterItemArray.count) \(item)")
    }
    
    func isAlreadyItemSelected(_ item:String)->Bool{
        let items = filterItemArray.filter { $0.title != item}
        if items.count > 0 {
            return true
        }
        return false

    }

}
