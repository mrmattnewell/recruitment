//
//  Reusable.swift
//  recruitment
//
//  Created by Pablo Martinez Piles on 06/07/2018.
//  Copyright © 2018 Iris connect. All rights reserved.
//

import UIKit


// MARK: Reusable view
protocol ReusableView {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

// MARK: Table View
extension UITableViewCell: ReusableView { }
extension UITableViewHeaderFooterView: ReusableView { }

extension UITableView {
    
    // MARK: Cell register
    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func register<T: UITableViewCell>(_: T.Type) where T: NibInstantiable {
        register(T.nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    // MARK: Header/footer register
    func register<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: NibInstantiable {
        register(T.nib, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    // MARK: Dequeue
    func dequeueCell<T: UITableViewCell>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
    
    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
            fatalError("Could not dequeue view with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return view
    }
}

// MARK: Collection View
extension UICollectionReusableView: ReusableView { }

extension UICollectionView {
    
    // MARK: Cell register
    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: NibInstantiable {
        register(T.nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    // MARK: Supplementary register
    func register<T: UICollectionReusableView>(_: T.Type, kind: String) {
        register(T.self,
                 forSupplementaryViewOfKind: kind,
                 withReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func register<T: UICollectionReusableView>(_: T.Type, kind: String) where T: NibInstantiable {
        register(T.nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    // MARK: Dequeue
    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
    
    func dequeueView<T: UICollectionReusableView>(ofKind kind: String, for indexPath: IndexPath) -> T {
        
        guard let view = dequeueReusableSupplementaryView(ofKind: kind,
                                                          withReuseIdentifier: T.defaultReuseIdentifier,
                                                          for: indexPath) as? T else {
                                                            fatalError("Could not dequeue view of kind '\(kind)' with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return view
    }
    
}
