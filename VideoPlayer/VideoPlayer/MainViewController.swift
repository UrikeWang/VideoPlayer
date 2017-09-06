//
//  MainViewController.swift
//  VideoPlayer
//
//  Created by yuling on 2017/9/6.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import CoreMedia
import MediaPlayer

class MainViewController: UIViewController {

    var url: String = ""

    fileprivate var myContext = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.urlsearchBar.delegate = self

        let videoUrl = URL(string: "\(urlsearchBar.text)")

        self.urlsearchBar.addObserver(
            self,
            forKeyPath: #keyPath(Url.url),
            options: .new,
            context: nil
        )

        view.addSubview(urlsearchBar)

        view.addSubview(playButton)

        view.addSubview(muteButton)

        setupUrlSearchBar()

        setupPlayButton()

        setupMuteButton()

    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if context == &myContext {
            if let newValue = change?[NSKeyValueChangeKey.newKey], keyPath == "status" {
                print("kvo status \(newValue)")
            } else if let newValue = change?[NSKeyValueChangeKey.newKey], keyPath == "rate" {

                //swiftlint:disable force_cast
                let rate: Float = CFloat(newValue as! NSNumber)
                print("kvo rate \(rate)")
                //                if rate == 0.0 // Playback stopped
                //                else if rate == 1.0 // Normal playback
                //                else if rate == -1.0 { // Reverse playback
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    let urlsearchBar: UISearchBar = {

        let searchBar = UISearchBar()

        searchBar.placeholder = "Enter URL of video"

        searchBar.translatesAutoresizingMaskIntoConstraints = false

        return searchBar

    }()

    let playButton: UIButton = {

        let button = UIButton()

        button.setTitle("Play", for: .normal)

        button.tintColor = .white

        button.backgroundColor = .black

        button.translatesAutoresizingMaskIntoConstraints = false

        return button

    }()

    let muteButton: UIButton = {

        let button = UIButton()

        button.setTitle("Mute", for: .normal)

        button.tintColor = .white

        button.backgroundColor = .black

        button.translatesAutoresizingMaskIntoConstraints = false

        return button

    }()

    func setupUrlSearchBar() {

        urlsearchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        urlsearchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true

        urlsearchBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        urlsearchBar.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    func setupPlayButton() {

        playButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true

        playButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        playButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true

        playButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

    }

    func setupMuteButton() {

        muteButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        muteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        muteButton.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true

        muteButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

    }

}

extension MainViewController: UISearchBarDelegate {

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

    }

}
