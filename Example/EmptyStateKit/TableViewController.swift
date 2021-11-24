//
//  TableViewController.swift
//  StateView
//
//  Created by Alberto Aznar de los Ríos on 27/05/2019.
//  Copyright © 2019 Alberto Aznar de los Ríos. All rights reserved.
//

import UIKit
import EmptyStateKit

class TableViewController: UITableViewController {

    struct Item {
        let title: String
        let description: String
        let state: TableState
    }
    
    var items = [Item]()
    var selected = TableState.noNotifications
    
    override func viewDidLoad() {
      super.viewDidLoad()
      view.emptyState.prepareTableCollectionViews()

      fetchData()
    }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    view.emptyState.clear()
  }
    
  @IBAction func didRefresh(_ sender: UIRefreshControl) {
    refreshControl?.endRefreshing()
  }

  deinit {
    print("Test memory deinit TableControler")
  }
}

extension TableViewController {
    
    private func fetchData() {
//      let test = SimpleEmptyState.noBox
//      let view = SimpleEmptyStateView(state: test).configure(MainState.noInternet)
//
//      let name = SimpleEmptyStateView.nibName
//      let nameOr = OriginalEmptyStateView.nibName
//
//       let working =  test.viewClass.init(owner: nil).configure(test)
//
//      let truc: EmptyStateProtocol = test
//      let failure =  truc.viewClass.init(owner: nil).configure(test)

//      let bidule = testType.init(owner: nil)

        items = [
            Item(title: "No results", description: "Top image / Center position / Center text", state: .noSearch),
            Item(title: "The box is empty", description: "Bottom image / Center position / Center text", state: .noBox),
            Item(title: "No collections", description: "Top image / Top position / Left text", state: .noTags),
            Item(title: "The cart is empty", description: "Top image / Top position / Center text", state: .noCart),
            Item(title: "Not logged In", description: "Top image / Top position / Right text", state: .noProfile),
            Item(title: "No favorites", description: "Top image / Bottom position / Center text", state: .noFavorites),
            Item(title: "Where are you?", description: "Top image / Bottom position / Left text", state: .noLocation),
            Item(title: "We’re Sorry", description: "Gradient background", state: .noInternet),
            Item(title: "No income", description: "Cover image + margins / Gradient background", state: .noIncome),
            Item(title: "Ask friend!", description: "Cover image / Gradient background", state: .inviteFriend)
        ]
        tableView.reloadData()
    }
}

extension TableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if items.count == 0 {
            view.emptyState.show(selected)
            
        } else {
            view.emptyState.hide()
        }
        
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text = item.title
        cell.descriptionLabel.text = item.description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        // Configure empty state format
        view.emptyState.format = item.state.format
        view.emptyState.delegate = self
        
        selected = item.state
        items = [Item]()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension TableViewController: EmptyStateDelegate {
    
  func emptyState(emptyState: EmptyState, didPressButton button: UIButton, state: Any?) {
//    if let state = state as? TableState {
//      guard case .noTags = state else {
//        return print("test")
//      }
//
//      print("truc")
//    }

    fetchData()
  }

}
