//
//  Character.swift
//  PayBox-Assignment
//
//  Created by Yam Ben Ari on 29/08/2023.
//

import Foundation

struct Section {
  var name: String
  var items: [Details]
  var collapsed: Bool
    
  init(name: String, items: [Details], collapsed: Bool = true) {
    self.name = name
    self.items = items
    self.collapsed = collapsed
  }
}

struct Details {
    let title: String
    let icon: String
    let description: String
}

struct Character: Decodable {
    let id: Int?
    let name: String?
    let status: String?
    let image: String?
    let location: Location
    let origin: Location
}

struct Location : Decodable {
    let name: String?
    let url: String?
}

struct LocationData: Decodable {
    let name: String?
    let type: String?
    let dimension: String?
}
