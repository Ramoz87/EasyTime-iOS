//
//  AddTimeViewModel.swift
//  EasyTime
//
//  Created by Mobexs on 1/12/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

protocol AddTimeViewModelDelegate {

}

class AddTimeViewModel: BaseViewModel {

    var hours: String = "" {

        didSet {

            //TODO: Update hours
        }
    }
    var minutes: String = "" {

        didSet {

            //TODO: Update minutes
        }
    }
}
