//
//  DetailsCharacterViewModel.swift
//  PayBox-Assignment
//
//  Created by Yam Ben Ari on 29/08/2023.
//

import Foundation

class DetailsCharacterViewModel {
    private var locationData: LocationData?
    private var originData: LocationData?
    
    func updateLocationData(with locationData: LocationData) {
        self.locationData = locationData
    }
    
    func updateOriginData(with originData: LocationData) {
        self.originData = originData
    }
    
    func getLocationData() -> LocationData? {
        return locationData
    }
    
    func getOriginData() -> LocationData? {
        return originData
    }
}
