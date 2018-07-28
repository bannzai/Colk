//
//  ViewController.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit
import Conv

enum SectionType {
    case one
    case two
    case three
    
    static var elements: [SectionType] {
        return [.one, .two, .three]
    }
    
    var backgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.3)
    }
}

class ListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var flowLayout: UICollectionViewFlowLayout? {
        return collectionView.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    var imageNames: [String] = [
        "forest",
        "moon",
        "mountain",
        "pond",
        "river",
        "road",
        "snow",
        "volcano",
        "water_fall",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\\(^o^)/"
        
        collectionView.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCollectionViewCell")
        collectionView.register(UINib(nibName: "ListCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ListCollectionReusableView")

        flowLayout?.sectionInset = .zero
        flowLayout?.minimumLineSpacing = 0
        flowLayout?.minimumInteritemSpacing = 0

        collectionView
            .define(
                
                // Initalize Conv
                Conv()
                    
                    // Create sections for count of elements.
                    .create(for: SectionType.elements) { (sectionType, section) in
                        // In closure passed each element from elements and configuration for section.
                        
                        // Section has creating section header or footer method.
                        // `create header or footer` method to use generics and convert automaticary each datasource and delegate method.(e.g SectionHeaderFooter<ListCollectionReusableView>)
                        section.create(.header, headerOrFooter: { (header: SectionHeaderFooter<ListCollectionReusableView>) in
                            
                            // Setting each property and wrapped datasource or delegate method
                            header.reusableIdentifier = "ListCollectionReusableView"
                            header.size = CGSize(width: UIScreen.main.bounds.width, height: 50)
                            header.configureView { view, _ in
                                // `view` was converted to ListCollectionReusableView
                                
                                view.nameLabel.text = "\(sectionType)".uppercased()
                                view.nameLabel.textColor = .white
                                view.backgroundColor = sectionType.backgroundColor
                            }
                        })
                        
                        // Section has creating items for count of elements.
                        // `create item` method to use generics type and convert automaticary to each datasource and delegate method. (e.g Item<ListCollectionViewCell>)
                        section.create(for: viewModels(section: sectionType), items: { (viewModel, item: Item<ListCollectionViewCell>) in
                            // In closure passed each element from elements and configuration for section.
                            
                            // Setting each property and wrapped datasource or delegate method
                            item.reusableIdentifier = "ListCollectionViewCell"
                            item.sizeFor({ _ -> CGSize in
                                let gridCount: CGFloat = 3
                                let edge = floor((UIScreen.main.bounds.width - (gridCount - 1)) / gridCount)
                                let size = CGSize(width: edge, height: edge)
                                return size
                            })
                            
                            item.configureCell { (cell, info) in
                                
                                // cell was converted to ListCollectionViewCell
                                cell.setup(with: viewModel)
                            }
                            
                            item.didSelect { [weak self] (item) in
                                let viewController = DetailViewController(imageName: viewModel.imageName)
                                self?.navigationController?.pushViewController(viewController, animated: true)
                            }
                        })
                }
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .black
    }
}

extension ListViewController {
    func viewModels(section: SectionType) -> [ItemViewModel] {
        func stub(count: UInt) -> [ItemViewModel] {
            return imageNames
                .map { ItemViewModel(imageName: $0, image: UIImage(named: $0)!) }
        }
        switch section {
        case .one:
            return stub(count: 10)
        case .two:
            return stub(count: 10)
        case .three:
            return stub(count: 10)
        }
    }
}

