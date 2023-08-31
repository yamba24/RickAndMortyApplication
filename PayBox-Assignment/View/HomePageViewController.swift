//
//  HomePageViewController.swift
//  PayBox-Assignment
//
//  Created by Yam Ben Ari on 29/08/2023.
//

import Foundation
import UIKit
import SkeletonView

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    private var homePageViewModel : HomePageViewModel! = HomePageViewModel()
    private let totalCount = 25
    private let minId = 1
    private let maxId = 827
    private var isShimmeringState = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupTableView()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !homePageViewModel.getIsFirstLoad() { return }
        fetchData()
    }
    
    private func setupTableView() {
        tableView.isSkeletonable = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CharacterTableViewCell", bundle: nil), forCellReuseIdentifier: "CharacterTableViewCell")
    }
    
    private func generateRandomArray(count: Int, range: Range<Int>) -> [Int] {
        var numbers = Set<Int>()
        while numbers.count < count {
            let num = Int.random(in: range)
            numbers.insert(num)
        }
        return Array(numbers)
    }
    
    func fetchData() {
        homePageViewModel.setIsFirstLoad()
        let idsList = generateRandomArray(count: totalCount, range: minId..<maxId)
        Service.shared.getAllCharacterData(ids: idsList) { result in
            switch result {
            case .success(let characters):
                self.homePageViewModel.updateCharacterList(with: characters)
                self.isShimmeringState = false
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBAction func shuffleButtonTapped(_ sender: Any) {
        isShimmeringState = true
        tableView.reloadData()
        fetchData()
    }
}

extension HomePageViewController: SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShimmeringState ? 10 : homePageViewModel.getNumberOfCharacters()

    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CharacterTableViewCell"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterTableViewCell", for: indexPath) as! CharacterTableViewCell
        if isShimmeringState {
            cell.applySkeletonView()
        } else {
            cell.removeSkeletonView()
            let characterList = homePageViewModel.getCharacterList()
            let character = characterList[indexPath.row]
            cell.setCell(name: character.name, status: character.status, url: character.image)
        }
        return cell
    }
    
}

extension HomePageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isShimmeringState { return }
        
        let selectedItem = homePageViewModel.getCharacterList()[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsCharacterViewController") as? DetailsCharacterViewController {
            detailsVC.selectedCharacter = selectedItem
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}
