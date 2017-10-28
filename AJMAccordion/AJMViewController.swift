//
//  ViewController.swift
//  AJMAccordion
//
//  Created by TheKairuz on 28/10/17.
//  Copyright © 2017 TheKairuz. All rights reserved.
//

import UIKit

struct Writer {
    let name : String
    let books : [String]
}

class AJMViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 19, bottom: 0, right: 19)
        }
    }

    var writers : [ Writer ] = []
    var lastSelectedWriter = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up collectionview
        self.view.backgroundColor = UIColor.lightGray
        self.collectionView.backgroundColor = UIColor.lightGray
        
        let headerNib = UINib(nibName: "CustomCollectionViewHeader", bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CustomCollectionViewHeader")
        
        let contentNib = UINib(nibName: "ContentCollectionViewCell", bundle: nil)
        collectionView.register(contentNib, forCellWithReuseIdentifier: "ContentCollectionViewCell")
        
        // preparing data

        writers.append(Writer(name: "John", books: []))
        writers.append(Writer(name: "Fred", books: []))
        writers.append(Writer(name: "Luke", books: []))
    }


}

extension AJMViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return writers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return writers[section].books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as! ContentCollectionViewCell
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CustomCollectionViewHeader", for: indexPath) as! CustomCollectionViewHeader
        header.delegate = self
        header.index = indexPath.section
        header.layer.borderColor = (UIColor.lightGray).cgColor
        header.layer.borderWidth = CGFloat(1.0)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

extension AJMViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width : collectionView.contentSize.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width : collectionView.contentSize.width, height: 60)
    }

}

extension AJMViewController : CustomCollectionViewHeaderDelegate {
    
    func customCollectionViewHeader(sender: CustomCollectionViewHeader, didTap flag: Bool) {
    
        let sectionIndex = sender.index
        
        if lastSelectedWriter == -1 {
            
            // open Tab
            open(index: sectionIndex, completion: { (status) in
                self.lastSelectedWriter = sectionIndex

            })
            
            
        } else {
            
            if collectionView!.numberOfItems(inSection: lastSelectedWriter) > 0 {
                
                // Close Tab 
                close(completion: { (status) in
                   
                    // and then open a new tab if necessary
                    
                    if self.collectionView!.numberOfItems(inSection: sectionIndex) == 0 && self.lastSelectedWriter != sectionIndex {
                        self.open(index: sectionIndex, completion: { (status) in
                            self.lastSelectedWriter = sectionIndex
                        })
                        
                        
                    }

                })
                
            } else {
                
               // Open
                open(index: sectionIndex, completion: { (status) in
                     self.lastSelectedWriter = sectionIndex
                })
            }
            
        }
        
    }
    
    
    func open(index : Int, completion:@escaping (_ status : Bool) ->()) {
        
        collectionView?.performBatchUpdates({ [weak self] in
            
            guard let strongSelf = self else { return }
            
            let writer = strongSelf.writers[index]
            let newWriter = Writer(name: writer.name, books: ["Libro 1", "Libro 2", "Libro 3"])
            strongSelf.writers[index] = newWriter
        
            strongSelf.collectionView?.reloadSections(NSIndexSet(index: index) as IndexSet)
            
            }, completion: { (status) in
                completion(status)
        })
    }
    
    func close(completion:((_ status : Bool) ->())?) {
        
        collectionView?.performBatchUpdates({ [weak self] in
            
            guard let strongSelf = self else { return }
            
            let temp = strongSelf.writers
            
            var indexPathsToRemove : [IndexPath] = []
            
            for (index, writer) in temp.enumerated() {
                
                if writer.books.count > 0 {
                    
                    if let numberOfCells = strongSelf.collectionView?.numberOfItems(inSection: index) {
                        for row in 0..<numberOfCells {
                            indexPathsToRemove.append(IndexPath(row: row, section: index))
                        }
                    }
                    strongSelf.writers[index] = Writer(name: writer.name, books: [])
                }
            
            }
            
            if !indexPathsToRemove.isEmpty {
                strongSelf.collectionView?.deleteItems(at: indexPathsToRemove)
            }
            
            }, completion: { (status) in
                completion?(status)
        })
        
    }

}























