//
//  AllMealsOfCategoryViewController.swift
//  NanoIndividual
//
//  Created by Helaine Pontes on 19/08/20.
//  Copyright © 2020 Helaine Pontes. All rights reserved.
//

import UIKit

class AllMealsOfCategoryViewController: UIViewController {
    
    var category: String
    let tableView: UITableView = UITableView()
    
    var listOfMeals = [Meal]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    init(category: String) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configTableView()
        mealsRequest()
    }
    
    func mealsRequest() {
        let mealsRequest = NetworkRequest(category: category)
        mealsRequest.getMeals { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let meals):
                self.listOfMeals = meals
                createMealNewFile(data: meals)
            }
        }
        guard let saveMeals = readMealDataFromFile() else {
            print("ops")
            return
        }
        listOfMeals = saveMeals
    }
    
    func configView() {
        view.addSubview(tableView)
        self.view.insertSubview(UIView(frame: .zero), at: 0)
        view.backgroundColor = .backgroundYellow
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = category
        navigationController?.navigationBar.tintColor = .coralOrange
    }
    
    func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .backgroundYellow
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = true
        let cellNib = UINib(nibName: AllMealsOfCategoryTableViewCell.xibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: AllMealsOfCategoryTableViewCell.identifier)
        
        //Constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 132),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension AllMealsOfCategoryViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfMeals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AllMealsOfCategoryTableViewCell.identifier, for: indexPath) as? AllMealsOfCategoryTableViewCell else {
            fatalError()
        }
        
        let meal = listOfMeals[indexPath.row]
        cell.mealImageView.image = try? UIImage(withContentsOfUrl: listOfMeals[indexPath.row].strMealThumb)
        cell.mealTitle.text = meal.strMeal
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meal = listOfMeals[indexPath.row].strMeal
        navigationController?.pushViewController(MealDetailViewController(meal: meal), animated: true)
    }

}
