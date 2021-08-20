//
//  PetModel.swift
//  PetSupportApp
//
//  Created by Enam on 8/8/21.
//  Copyright © 2021 Jun K. All rights reserved.
//
import UIKit
import Foundation

final class PetViewModel {
    var petList: [PetModel] {
        get {
            var list: [PetModel] = []
            list.append(PetModel(petName: "Nahla", petImages: ["pet1","pet2","pet4","pet5"], petCollectionType: "NEW"))
            list.append(PetModel(petName: "Holly", petImages: ["pet1","pet2","pet4"], petCollectionType: "NEW"))
            list.append(PetModel(petName: "Terry", petImages: ["pet1","pet2","pet4"], petCollectionType: "OLD"))
            list.append(PetModel(petName: "Bingo", petImages: ["pet1","pet2","pet4"], petCollectionType: "OLD"))
            return list
        }
    }
    
    var searchList: [SearchModel] {
        get {
            var list: [SearchModel] = []
            list.append(SearchModel(headerName: "Recent searches", isRecent: true, searchItems: ["Affenpinscher","Bingo"]))
            
            list.append(SearchModel(headerName: "Top breeds", isRecent: false, searchItems: ["Affenpinscher","Afgan Hound","Airedale Terrier","Akbash","Akita","Bingo","Akita3","Akita4"]))
            
            return list
        }
    }
    
    var breedList: [BreedModel] {
        get {
            var list: [BreedModel] = []
            list.append(BreedModel(petName: "Affenpinscher", petImage: "pet1", isSelected: false))
            list.append(BreedModel(petName: "Afgan Hound", petImage: "pet2", isSelected: false))
            list.append(BreedModel(petName: "Airedale Terrier", petImage: "pet4", isSelected: false))
            list.append(BreedModel(petName: "Akbash", petImage: "pet1", isSelected: false))
            list.append(BreedModel(petName: "Akita", petImage: "pet5", isSelected: false))
            list.append(BreedModel(petName: "Akita2", petImage: "pet4", isSelected: false))
            list.append(BreedModel(petName: "Akita3", petImage: "pet2", isSelected: false))

            return list
        }
    }
    
    var colorList: [ColorModel] {
        get {
            var list: [ColorModel] = []
            list.append(ColorModel(colorName: "Apricot/Beige", color: UIColor.orange, isSelected: false))
            list.append(ColorModel(colorName: "Dark Gray", color: UIColor.darkGray, isSelected: false))
            list.append(ColorModel(colorName: "Blue", color: UIColor.blue, isSelected: false))
            list.append(ColorModel(colorName: "Black", color: UIColor.black, isSelected: false))
            list.append(ColorModel(colorName: "Link", color: UIColor.link, isSelected: false))
            list.append(ColorModel(colorName: "Yellow", color: UIColor.yellow, isSelected: false))
            list.append(ColorModel(colorName: "Green", color: UIColor.green, isSelected: false))
            list.append(ColorModel(colorName: "Gray", color: UIColor.gray, isSelected: false))

            return list
        }
    }
    
    var shelterList: [ShelterModel] {
        get {
            var list: [ShelterModel] = []
            list.append(ShelterModel.init(shelterName: "Fetch & ReleashDog Rescue ", shelterDistance: "1 mi eawy", isSelected: false))
            list.append(ShelterModel.init(shelterName: "International Paws Toronto", shelterDistance: "3 mi eawy", isSelected: false))
            list.append(ShelterModel.init(shelterName: "Peel Animal Rescue Society", shelterDistance: "5 mi eawy", isSelected: false))
            list.append(ShelterModel.init(shelterName: "Home Sweet Home", shelterDistance: "3 mi eawy", isSelected: false))
            list.append(ShelterModel.init(shelterName: "DIBS Rescue", shelterDistance: "5 mi eawy", isSelected: false))

            return list
        }
    }
    
    var favPetList: [FavPetModel] {
        get {
            var list: [FavPetModel] = []
            list.append(FavPetModel(petName: "Sloan", petDescription: "Puppy  •   Boxer", time: "a month ago", petImage: "pet1"))
            list.append(FavPetModel(petName: "Nahla", petDescription: "Puppy  •   Boxer   ", time: "a month ago", petImage: "pet2"))
            list.append(FavPetModel(petName: "Bingo", petDescription: "Puppy  •   Boxer   ", time: "a month ago", petImage: "pet5"))
            list.append(FavPetModel(petName: "Terry", petDescription: "Puppy  •   Boxer", time: "a month ago", petImage: "pet4"))

            return list
        }
    }

    
    var favShelterList: [FavShelterModel] {
        get {
            var list: [FavShelterModel] = []
            list.append(FavShelterModel(shelterName: "Diamond In The Ruff", shelterImage: "diamondinruff"))
            list.append(FavShelterModel(shelterName: "Keller's Kats Rescue Inc.", shelterImage: "diamondinruff"))
            list.append(FavShelterModel(shelterName: "Peel Animal Rescue Society", shelterImage: "diamondinruff"))
            list.append(FavShelterModel(shelterName: "Home Sweet Home", shelterImage: "diamondinruff"))
            list.append(FavShelterModel(shelterName: "DIBS Rescue", shelterImage: "diamondinruff"))

            return list
        }
    }
    
    var scheduleList: [ScheduleListModel] {
        get {
            var list: [ScheduleListModel] = []
            list.append(ScheduleListModel(petName: "Sloan", petStatus: Pet_Status.Approved, date: "2021/06/09", petImage: "pet1"))
            list.append(ScheduleListModel(petName: "Nahla", petStatus: Pet_Status.Reviewing, date: "2021/09/09", petImage: "pet2"))
            list.append(ScheduleListModel(petName: "Bingo", petStatus: Pet_Status.InProgress, date: "2021/08/09", petImage: "pet5"))
            list.append(ScheduleListModel(petName: "Terry", petStatus: Pet_Status.Reviewing, date: "2021/11/09", petImage: "pet4"))

            return list
        }
    }

    var idealPetList: [IdealPetModel] {
        get {
            var list: [IdealPetModel] = []
            list.append(IdealPetModel(title: "Dog", icon: "pet1"))
            list.append(IdealPetModel(title: "Cat", icon: "pet1"))
            list.append(IdealPetModel(title: "Other", icon: "pet1"))

            return list
        }
    }


}

struct PetModel {
    var petName: String
    var petImages: [String]
    var petCollectionType: String
    var currentPage: Int = 0

}

struct BreedModel {
    var petName: String
    var petImage: String
    var isSelected: Bool
}

struct ColorModel {
    var colorName: String
    var color: UIColor
    var isSelected: Bool
}

struct ShelterModel {
    var shelterName: String
    var shelterDistance: String
    var isSelected: Bool
}

struct SearchModel {
    var headerName: String
    var isRecent:Bool
    var searchItems:[String]
    
}
struct ScheduleListModel {
    var petName: String
    var petStatus: Pet_Status
    var date: String
    var petImage: String
}


struct FavPetModel {
    var petName: String
    var petDescription: String
    var time: String
    var petImage: String
}

struct FavShelterModel {
    var shelterName: String
    var shelterImage: String
}

struct IdealPetModel: Codable {
    var title: String
    var icon: String
}

struct Account: Codable {
    
    var title: String
    var icon: String
    var identifier: String
}

extension Account {
    init(_ account : Dictionary<String,Any>){
        title = account["title"] as? String ?? ""
        icon = account["icon"] as? String ?? ""
        identifier = account["identifier"] as? String ?? ""
    }
}



class FilterMenu : NSObject {
    var title : String!
    var filterModalMenu : FilterModalMenu!

    init(title : String,modalMenu:FilterModalMenu){
        self.title = title
        self.filterModalMenu = modalMenu
    }
}
