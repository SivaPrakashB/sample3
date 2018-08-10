//
//  UltravisualLayout.swift
//  ExpandingCollectionView
//
//  Created by Vamshi Krishna on 30/04/17.
//  Copyright © 2017 VamshiKrishna. All rights reserved.
//

import Foundation
import UIKit

/* The heights are declared as constants outside of the class so they can be easily referenced elsewhere */
struct UltravisualLayoutConstants {
    struct Cell {
        /* The height of the non-featured cell */
        static let standardHeight: CGFloat = 100
        /* The height of the first visible cell */
        static let featuredHeight: CGFloat = 280
    }
}

class UltravisualLayout:UICollectionViewLayout{
    //////////////
    var contentWidth:CGFloat!
    var contentHeight:CGFloat!
    var yOffset:CGFloat = 0
    
    var maxAlpha:CGFloat = 1
    var minAlpha:CGFloat = 0.5
    
    var widthOffset:CGFloat = 35
    var heightOffset:CGFloat = 35
    
    //var cache = [UICollectionViewLayoutAttributes]()
    
    var itemWidth:CGFloat{
        return (collectionView?.bounds.width)!
    }
    var itemHeight:CGFloat{
        return (collectionView?.bounds.height)!
    }
    var collectionViewHeight:CGFloat{
        return (collectionView?.bounds.height)!
    }
    var currentItemIndex:Int{
        return max(0, Int(collectionView!.contentOffset.y / collectionViewHeight))
    }
    var nextItemBecomeCurrentPercentage:CGFloat{
        return (collectionView!.contentOffset.y / (collectionViewHeight)) - CGFloat(currentItemIndex)
    }
    //////////////////////////
    // MARK: Properties and Variables
    
    /* The amount the user needs to scroll before the featured cell changes */
    var dragOffset:CGFloat{
        return (collectionView?.bounds.height)!
    }
    
    var cache = [UICollectionViewLayoutAttributes]()
    
    /* Returns the item index of the currently featured cell */
    var featuredItemIndex: Int {
        get {
            /* Use max to make sure the featureItemIndex is never < 0 */
            return max(0, Int(collectionView!.contentOffset.y / dragOffset))
        }
    }
    
    /* Returns a value between 0 and 1 that represents how close the next cell is to becoming the featured cell */
    var nextItemPercentageOffset: CGFloat {
        get {
            return (collectionView!.contentOffset.y / dragOffset) - CGFloat(featuredItemIndex)
        }
    }
   
    /* Returns the width of the collection view */
    var width: CGFloat {
        get {
            return collectionView!.bounds.width
        }
    }
    
    /* Returns the height of the collection view */
    var height: CGFloat {
        get {
            return collectionView!.bounds.height
        }
    }
    
    /* Returns the number of items in the collection view */
    var numberOfItems: Int {
        get {
            return collectionView!.numberOfItems(inSection: 0)
        }
    }
    
    // MARK: UICollectionViewLayout
    
    /* Return the size of all the content in the collection view */
    
   override var collectionViewContentSize: CGSize{
        let contentHeight = (CGFloat(numberOfItems) * dragOffset) + (height - dragOffset)
        return CGSize(width: width, height: contentHeight)
    }

 
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
        yOffset = 0
        
        for item in 0 ..< numberOfItems{
            
            let indexPath = IndexPath(item: item, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath )
            attribute.zIndex = -indexPath.row
            
            if (indexPath.item == currentItemIndex+1) && (indexPath.item < numberOfItems){
                
                attribute.alpha = minAlpha + max((maxAlpha-minAlpha) * nextItemBecomeCurrentPercentage, 0)
                let width = itemWidth - widthOffset + (widthOffset * nextItemBecomeCurrentPercentage)
                let height = itemHeight - heightOffset + (heightOffset * nextItemBecomeCurrentPercentage)
                
                let deltaWidth =  width/itemWidth
                let deltaHeight = height/itemHeight
                
                attribute.frame = CGRect(x: 0, y: yOffset, width: itemWidth, height: itemHeight)
                
                attribute.transform = CGAffineTransform(scaleX: deltaWidth, y: deltaHeight)
                
                attribute.center.y = (collectionView?.center.y)! +  (collectionView?.contentOffset.y)!
                attribute.center.x = (collectionView?.center.x)! + (collectionView?.contentOffset.x)!
                yOffset += collectionViewHeight*3
                
            }else{
                attribute.frame = CGRect(x: 0, y: yOffset, width: itemWidth, height: itemHeight)
                attribute.center.y = (collectionView?.center.y)! + yOffset
                attribute.center.x = (collectionView?.center.x)!
                yOffset += collectionViewHeight*3
            }
            cache.append(attribute)
        }
    }
    
    
    
    
    
    //Return the size of ContentView
   /* func collectionViewContentSize() -> CGSize {
        contentWidth = (collectionView?.bounds.width)!
        contentHeight = CGFloat(numberOfItems) * (collectionView?.bounds.height)!
        return CGSize(width: contentWidth, height: contentHeight)
        
    }*/
    /* Return all attributes in the cache whose frame intersects with the rect passed to the method */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    /* Return true so that the layout is continuously invalidated as the user scrolls */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let itemIndex = round(proposedContentOffset.y / dragOffset)
        let yOffset = itemIndex * dragOffset
        return CGPoint(x: 0, y: yOffset)
    }
}
class UltravisualLayout12: UICollectionViewLayout {
    
    var contentWidth:CGFloat!
    var contentHeight:CGFloat!
    
    var yOffset:CGFloat = 0
    
    var maxAlpha:CGFloat = 1
    var minAlpha:CGFloat = 0
    
    var widthOffset:CGFloat = 35
    var heightOffset:CGFloat = 35
    
    var cache = [UICollectionViewLayoutAttributes]()
    
    var itemWidth:CGFloat{
        return (collectionView?.bounds.width)!
    }
    var itemHeight:CGFloat{
        return (collectionView?.bounds.height)!
    }
    var collectionViewHeight:CGFloat{
        return (collectionView?.bounds.height)!
    }
    
    
    var numberOfItems:Int{
      
            return collectionView!.numberOfItems(inSection: 0)
     
    }
    
    
 var dragOffset:CGFloat{
        return (collectionView?.bounds.height)!
    }
    var currentItemIndex:Int{
        return max(0, Int(collectionView!.contentOffset.y / collectionViewHeight))
    }
    
    var nextItemBecomeCurrentPercentage:CGFloat{
        return (collectionView!.contentOffset.y / (collectionViewHeight)) - CGFloat(currentItemIndex)
    }
   
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
        yOffset = 0
        
        for item in 0 ..< numberOfItems{
            
            let indexPath = IndexPath(item: item, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath )
            attribute.zIndex = -indexPath.row
            
            if (indexPath.item == currentItemIndex+1) && (indexPath.item < numberOfItems){
                
                attribute.alpha = minAlpha + max((maxAlpha-minAlpha) * nextItemBecomeCurrentPercentage, 0)
                let width = itemWidth - widthOffset + (widthOffset * nextItemBecomeCurrentPercentage)
                let height = itemHeight - heightOffset + (heightOffset * nextItemBecomeCurrentPercentage)
                
                let deltaWidth =  width/itemWidth
                let deltaHeight = height/itemHeight
               
                attribute.frame = CGRect(x: 0, y: yOffset, width: itemWidth, height: itemHeight)
                
                attribute.transform = CGAffineTransform(scaleX: deltaWidth, y: deltaHeight)
                
                attribute.center.y = (collectionView?.center.y)! +  (collectionView?.contentOffset.y)!
                attribute.center.x = (collectionView?.center.x)! + (collectionView?.contentOffset.x)!
                yOffset += (collectionViewHeight)
                
            }else{
                attribute.frame = CGRect(x: 0, y: yOffset, width: itemWidth, height: itemHeight)
                attribute.center.y = (collectionView?.center.y)! + yOffset
                attribute.center.x = (collectionView?.center.x)!
                yOffset += (collectionViewHeight)
            }
            cache.append(attribute)
        }
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var a=30
        print("\(cache[indexPath.row])bvsp")
        return cache[indexPath.row]
    }
   
    override var collectionViewContentSize: CGSize{
         contentWidth = (collectionView?.bounds.width)!
        contentHeight = CGFloat(numberOfItems) * (collectionView?.bounds.height)!
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    //Return Attributes  whose frame lies in the Visible Rect
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
    for attribute in cache{
            if attribute.frame.intersects(rect){
                layoutAttributes.append(attribute)
            }
        }
        
 
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
 
   
 
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        print(dragOffset)
collectionView
        let itemIndex = round(proposedContentOffset.y / (dragOffset))
        let yOffset = itemIndex * (collectionView?.bounds.height)!
        return CGPoint(x: 0, y:CGFloat(yOffset))
    }
    
    
    
    
    
   
    
    
    
    
    
    
    
  

}
extension String {
    /// Converts HTML string to a `NSAttributedString`
    
    var htmlAttributedString: NSAttributedString? {
        return try? NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    }
    
}
