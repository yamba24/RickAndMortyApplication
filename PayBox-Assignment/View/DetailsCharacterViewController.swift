//
//  DetailsCharacterViewController.swift
//  PayBox-Assignment
//
//  Created by Yam Ben Ari on 29/08/2023.
//

import Foundation
import UIKit
import Kingfisher
import SkeletonView

struct Labels {
    static let nameLabel = "Name"
    static let dimensionLabel = "Dimension"
    static let typeLabel = "Type"
}

struct Icons {
    static let nameIcon = "name"
    static let dimensionIcon = "asteroid"
    static let typeIcon = "rocket"
}

class DetailsCharacterViewController: UIViewController {

    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterStatus: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var detailsTableView: UITableView!
    
    var selectedCharacter: Character!
    private var detailsCharacterPageViewModel = DetailsCharacterViewModel()
    private var dataSource: [Section] = []
    private let dispatchGroup = DispatchGroup()
    
    var isShimmeringState = true
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isShimmeringState = true
        fetchLocationAndOriginData()
    }
    
    func fetchLocationAndOriginData() {
        dispatchGroup.enter()
        fetchLocationData()
        
        dispatchGroup.enter()
        fetchOriginData()
        
        dispatchGroup.notify(queue: .main) {
            self.isShimmeringState = false
            self.detailsTableView.reloadData()
        }
    }

    func fetchLocationData() {
        guard let locationUrl = selectedCharacter.location.url, !locationUrl.isEmpty else {
            setEmpty(text: "No Location Found")
            dispatchGroup.leave()
            return
        }
        
        Service.shared.getLocationCharacterData(url: locationUrl) { result in
            defer {
                self.dispatchGroup.leave()
            }
            
            switch result {
            case .success(let locationData):
                self.detailsCharacterPageViewModel.updateLocationData(with: locationData)
                self.setLocationDataSource()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setEmpty(text: String) {
        let section = Section(name: text, items: [])
        dataSource.append(section)
    }

    func fetchOriginData() {
        guard let originUrl = selectedCharacter.origin.url, !originUrl.isEmpty else {
            setEmpty(text: "No Origin Found")
            dispatchGroup.leave()
            return
        }
        
        Service.shared.getLocationCharacterData(url: originUrl) { result in
            defer {
                self.dispatchGroup.leave()
            }
            
            switch result {
            case .success(let originData):
                self.detailsCharacterPageViewModel.updateOriginData(with: originData)
                self.setOriginDataSource()
            case .failure(let error):
                print(error)
            }
        }
    }


    func setData() {
        if let name = selectedCharacter.name,
           let image = selectedCharacter.image,
           let status = selectedCharacter.status {
            characterImage.kf.setImage(with: URL(string: image))
            characterName.text = name
            characterStatus.text = status
        }
    }
    
    func setLocationDataSource() {
        guard let locationData = detailsCharacterPageViewModel.getLocationData(),
              let dimension = locationData.dimension,
              let type = locationData.type,
              let name = locationData.name else { return }

        var details = [Details(title: Labels.nameLabel, icon: Icons.nameIcon, description: name)]
        details.append(Details(title: Labels.typeLabel, icon: Icons.typeIcon, description: type))
        details.append(Details(title: Labels.dimensionLabel, icon: Icons.dimensionIcon, description: dimension))
        let section = Section(name: "Location", items: details)
        dataSource.append(section)
    }
    
    func setOriginDataSource() {
        guard let originData = detailsCharacterPageViewModel.getOriginData(),
              let dimension = originData.dimension,
              let type = originData.type,
              let name = originData.name else { return }

        var details = [Details(title: Labels.nameLabel, icon: Icons.nameIcon, description: name)]
        details.append(Details(title: Labels.typeLabel, icon: Icons.typeIcon, description: type))
        details.append(Details(title: Labels.dimensionLabel, icon: Icons.dimensionIcon, description: dimension))
        let section = Section(name: "Origin", items: details)
        dataSource.append(section)
    }
    
    func setupUI() {
        characterImage.layer.cornerRadius = 20.0
        characterName.numberOfLines = 0
        characterStatus.numberOfLines = 0
        
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        
        detailsTableView.register(UINib(nibName: "DetailsCharacterTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailsCharacterTableViewCell")
        
        detailsTableView.register(UINib(nibName: "HeaderDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderDetailsTableViewCell")
    }
}

extension DetailsCharacterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShimmeringState || !dataSource[section].collapsed ? 1 : dataSource[section].items.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isShimmeringState ? 2 : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderDetailsTableViewCell", for: indexPath) as! HeaderDetailsTableViewCell
            if isShimmeringState {
                cell.applyShimmering()
            } else {
                cell.removeShimmering()
                let emptyState = dataSource[indexPath.section].items.isEmpty
                cell.setCell(emptyState: emptyState, collapse: dataSource[indexPath.section].collapsed, header: dataSource[indexPath.section].name)
            }
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCharacterTableViewCell", for: indexPath) as! DetailsCharacterTableViewCell
            let item = dataSource[indexPath.section].items[indexPath.row - 1]
            cell.setCell(icon: item.icon, title: item.title, description: item.description)
            return cell
        }
    }
}

extension DetailsCharacterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isShimmeringState || dataSource[indexPath.section].items.isEmpty || indexPath.row > 0 {
            return
        }
        
        dataSource[indexPath.section].collapsed = !dataSource[indexPath.section].collapsed
        UIView.animate(withDuration: 0.3) {
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
        }
    }
}
