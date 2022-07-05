//
//  DetailViewController.swift
//  GitHubTest
//
//  Created by Dmitro Pechenenko on 16.06.2022.
//

import UIKit
import CoreData

class DetailRepositoryViewController: UIViewController, ViewCoordinator {

    var viewModel: DetailRepositoryViewModel?
    var coordinator: Coordiantor?
    var labelLogin: UILabel!
    var labelURL: UILabel!
    var labelType: UILabel!
    var labelNodeID: UILabel!
    var labelAvatarUrl: UILabel!
    var labelEventsUrl: UILabel!
    var labelFollowersUrl: UILabel!
    var labelFollowingUrl: UILabel!
    var labelGistsUrl: UILabel!
    var labelReceivedEventsUrl: UILabel!
    var labelReposUrl: UILabel!
    var labelStarredUrl: UILabel!
    var labelSubscriptionsUrl: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLabel()
        viewModel?.link.bind { details in
            self.labelLogin.text = details?.login
            self.labelURL.text = details?.html_url
            self.labelType.text = details?.type
            self.labelNodeID.text = details?.node_id
            self.labelAvatarUrl.text = details?.avatar_url
            self.labelEventsUrl.text = details?.events_url
            self.labelFollowersUrl.text = details?.followers_url
        }
    }

    private func setupUI() {
        title = "Detail"
        view.backgroundColor = .white
    }

    private func setupLabel() {
        labelLogin = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        labelLogin.center = CGPoint(x: 130, y: 120)
        labelLogin.textAlignment = .left
        labelLogin.text = ""
            self.view.addSubview(labelLogin)

        labelURL = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        labelURL.center = CGPoint(x: 130, y: 140)
        labelURL.textAlignment = .left
        labelURL.text = ""
            self.view.addSubview(labelURL)

        labelType = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        labelType.center = CGPoint(x: 130, y: 160)
        labelType.textAlignment = .left
        labelType.text = ""
            self.view.addSubview(labelType)

        labelNodeID = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        labelNodeID.center = CGPoint(x: 130, y: 180)
        labelNodeID.textAlignment = .left
        labelNodeID.text = ""
            self.view.addSubview(labelNodeID)

        labelAvatarUrl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        labelAvatarUrl.center = CGPoint(x: 130, y: 200)
        labelAvatarUrl.textAlignment = .left
        labelAvatarUrl.text = ""
            self.view.addSubview(labelAvatarUrl)

        labelEventsUrl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        labelEventsUrl.center = CGPoint(x: 130, y: 220)
        labelEventsUrl.textAlignment = .left
        labelEventsUrl.text = ""
            self.view.addSubview(labelEventsUrl)

        labelFollowersUrl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        labelFollowersUrl.center = CGPoint(x: 130, y: 240)
        labelFollowersUrl.textAlignment = .left
        labelFollowersUrl.text = ""
            self.view.addSubview(labelFollowersUrl)

        labelLogin.text = viewModel?.link.value?.login
        labelURL.text = viewModel?.link.value?.html_url
        labelType.text = viewModel?.link.value?.type
        labelNodeID.text = viewModel?.link.value?.node_id
        labelAvatarUrl.text = viewModel?.link.value?.avatar_url
        labelEventsUrl.text = viewModel?.link.value?.events_url
        labelFollowersUrl.text = viewModel?.link.value?.followers_url
    }
}
