//
//  HomePageViewModel.swift
//  PayBox-Assignment
//
//  Created by Yam Ben Ari on 29/08/2023.
//

import Foundation

class HomePageViewModel {
    private var characterList: [Character] = []
    private var isFirstLoad = true
    
    func updateCharacterList(with characters: [Character]) {
        characterList = characters
    }
    
    func getCharacterList() -> [Character] {
        return characterList
    }
    
    func getNumberOfCharacters() -> Int {
        return characterList.count
    }
    
    func getIsFirstLoad() -> Bool {
        return isFirstLoad
    }
    
    func setIsFirstLoad() {
        isFirstLoad = false
    }
}
