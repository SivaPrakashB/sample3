//
//  phoneNumber.swift
//  NaradPosts
//
//  Created by Narayan on 2/28/18.
//  Copyright © 2018 Narayan. All rights reserved.
//

import Foundation

class Main{
    var noOfTimes:Int
   
    init(noOfTimes:Int)
    {
    self.noOfTimes=noOfTimes
    }
   
}
var mainInstance=Main(noOfTimes: 0)

class BookMarkIDS
{
    var bookmark:String
    init(bookmark:String)
    {
        self.bookmark=bookmark
    }
   
}
var bookMarkInstance=BookMarkIDS(bookmark: "")
class KasKhabareIDS
{
    var kasKhabare:String
    init(kasKhabare:String)
    {
        self.kasKhabare=kasKhabare
    }
    
}
var kasKhabareInstance=KasKhabareIDS(kasKhabare: "000")
