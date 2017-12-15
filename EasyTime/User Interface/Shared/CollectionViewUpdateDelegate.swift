//
//  CollectionViewUpdateDelegate.swift
//  EasyTime
//
//  Created by Mobexs on 12/15/17.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

enum CollectionViewChangeType : UInt {

    case insert
    case delete
    case move
    case update
}

protocol CollectionViewUpdateDelegate: class {

    func didChangeObject(at indexPath: IndexPath?, for type: CollectionViewChangeType, newIndexPath: IndexPath?)
    func didChangeSection(at sectionIndex: Int, for type: CollectionViewChangeType)
    func didChangeCollectionView()
    func willChangeContent()
    func didChangeContent()
}
