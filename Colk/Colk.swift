//
//  Colk.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public final class Colk: NSObject {
    public weak var collectionView: UICollectionView?
    public var sections: [Section] = []
    public var didMoveItem: ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)?
    public var indexTitles: ((UICollectionView) -> [String])?
    public var indexTitle: ((_ collectionView: UICollectionView, _ title: String, _ index: Int) -> IndexPath)?
    
    func itemFor(indexPath: IndexPath) -> Item {
        return sections[indexPath.section].items[indexPath.item]
    }
}

extension Colk {
    public func add(section: Section) -> Self {
        sections.append(section)
        return self
    }
    public func add(sections: [Section]) -> Self {
        self.sections.append(contentsOf: sections)
        return self
    }
    
    public func create(section closure: (SectionImpl) -> Void) -> Self {
        return add(section: SectionImpl() { closure($0) } )
    }
    public func create<E>(for elements: [E], sections closure: (E, SectionImpl) -> Void) -> Self {
        let sections = elements.map { (element) in
            SectionImpl() { section in
                closure(element, section)
            }
        }
        
        return add(sections: sections)
    }
    public func create(with count: UInt, sections closure: ((UInt, Section) -> Void)) -> Self {
        return create(for: [UInt](0..<count), sections: closure)
    }
}

