//
//  ViewController.swift
//  DataProvider
//
//  Created by Giovane Possebon on 04/25/2019.
//  Copyright (c) 2019 Giovane Possebon. All rights reserved.
//

import UIKit
import DataProvider

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TimelineProvider(id: 0).getTimeline { timeline, error in
            print(timeline)
        }
    }

}

