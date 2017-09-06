//
//  MainViewController.swift
//  VideoPlayer
//
//  Created by yuling on 2017/9/6.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MainViewController: UIViewController, UISearchBarDelegate {

    fileprivate var myContext = 0

    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var playerController: AVPlayerViewController?
    var timer: Timer? = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.urlsearchBar.delegate = self

        self.urlsearchBar.addObserver(
            self,
            forKeyPath: #keyPath(Url.url),
            options: .new,
            context: nil
        )

        playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)

        muteButton.addTarget(self, action: #selector(muteVideo), for: .touchUpInside)

        view.addSubview(urlsearchBar)

        view.addSubview(bottomView)

        bottomView.addSubview(playButton)

        bottomView.addSubview(muteButton)

        setupUrlSearchBar()

        setupPlayButton()

        setupMuteButton()

        setupBottomView()

    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if context == &myContext {

            if let newValue = change?[NSKeyValueChangeKey.newKey], keyPath == "status" {

                print("kvo status \(newValue)")

            } else if let newValue = change?[NSKeyValueChangeKey.newKey], keyPath == "rate" {

                guard
                    let rate: Float = newValue as? CFloat
                    else { return }

                print("kvo rate \(rate)")

            }

        } else {

            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)

        }
    }

    func muteVideo() {

        if muteButton.titleLabel?.text == "Mute" {

            player?.isMuted = true

            muteButton.setTitle("Unmute", for: .normal)

        } else {

            player?.isMuted = false

            muteButton.setTitle("Mute", for: .normal)

        }

    }

    func playVideo() {

        if playButton.titleLabel?.text == "Pause" {

            player?.pause()

            playButton.setTitle("Play", for: .normal)

        } else {

            player?.play()

            playButton.setTitle("Pause", for: .normal)

        }
    }

    func addObserver() {

        if let player = self.player {

            player.addObserver(
                self,
                forKeyPath: "rate",
                options: .new,
                context: &myContext
            )

            player.addObserver(
                self,
                forKeyPath: "status",
                options: .new,
                context: &myContext
            )

        }

    }

    func removeObserver() {

        if let player = self.player {

            player.removeObserver(self, forKeyPath: "rate")

            player.removeObserver(self, forKeyPath: "status")

        }

    }

    func itemStatus() {

        var endTime: Double = 0.0

        var likelyToKeepUp: Bool?

        var butterFull: Bool?

        var butterEmpty: Bool?

        if let playerItem = self.playerItem {

            endTime = CMTimeGetSeconds(playerItem.forwardPlaybackEndTime)

            likelyToKeepUp = playerItem.isPlaybackLikelyToKeepUp

            butterFull = playerItem.isPlaybackBufferFull

            butterEmpty = playerItem.isPlaybackBufferEmpty

        }

    }

//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//
//        setAVPlayerController()
//
//    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        setAVPlayerController()

    }

    func setAVPlayerController() {

        self.removeObserver()

        guard
            let videoURL = URL(string: urlsearchBar.text!)
            else { return }

        self.playerItem = AVPlayerItem(url: videoURL)

        self.player = AVPlayer(playerItem: self.playerItem)

        self.player?.actionAtItemEnd = AVPlayerActionAtItemEnd.none

        self.addObserver()

        self.playerController = AVPlayerViewController()

        self.playerController?.player = self.player

        self.playerController?.view.frame = CGRect(x: 0, y: 80, width: view.frame.width, height: view.frame.height * 0.7)

        self.playerController?.view.backgroundColor = .clear

        self.playerController?.showsPlaybackControls = false

        self.addChildViewController(playerController!)

        self.view.addSubview((playerController?.view)!)

        playerController?.didMove(toParentViewController: self)

        self.timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(MainViewController.itemStatus),
            userInfo: nil,
            repeats: true
        )

        self.player?.play()

        playButton.setTitle("Pause", for: .normal)

    }

    let urlsearchBar: UISearchBar = {

        let searchBar = UISearchBar()

        searchBar.placeholder = "Enter URL of video"

        searchBar.barTintColor = UIColor(red: 8.0/255.0, green: 21.0/255.0, blue: 35.0/255.0, alpha: 1)

        searchBar.translatesAutoresizingMaskIntoConstraints = false

        return searchBar

    }()

    let bottomView: UIView = {

        let view = UIView()

        view.backgroundColor = .black

        view.translatesAutoresizingMaskIntoConstraints = false

        return view

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

        urlsearchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 22).isActive = true

        urlsearchBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        urlsearchBar.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    func setupBottomView() {

        bottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        bottomView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        bottomView.heightAnchor.constraint(equalToConstant: 44).isActive = true

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
