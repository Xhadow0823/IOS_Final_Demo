//
//  FevPost.swift
//  IOS_Final_Demo
//
//  Created by 翁星宇 on 2021/1/20.
//

import Foundation
import SwiftUI

class FevPosts: ObservableObject{
    @Published var posts = [Post]()
    @AppStorage("fevPosts") var fevPosts: Data?
    
    init(){
        if let fevPosts = fevPosts {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode([Post].self, from: fevPosts) {
                posts = decodedData
            }
        }
    }
}
