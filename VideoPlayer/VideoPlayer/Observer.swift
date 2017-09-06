//
//  Observer.swift
//  VideoPlayer
//
//  Created by yuling on 2017/9/6.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class Observer: NSObject {

    var url: Url

    init(url: Url) {

        self.url = url

        super.init()

    }

}
