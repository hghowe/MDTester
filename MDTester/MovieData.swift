//
//  MovieData.swift
//  MDTester
//
//  Created by Harlan.Howe on 3/7/15.
//  Copyright (c) 2015 Harlan.Howe. All rights reserved.
//

import Foundation

class MovieData
{
    var title = ""
    var date:Double = 2014
    
    var description: String
    {
        return "\(title):(\(Int(date)))"
    }
}