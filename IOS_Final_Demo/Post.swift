//
//  Post.swift
//  IOS_Final_test
//
//  Created by 翁星宇 on 2020/12/30.
//

import Foundation

struct Post: Codable {
    let id: Int
    let title: String
    let excerpt: String
    let forumAlias: String
}

struct PostDetail: Codable {
    let media: [Media]?
}
struct Media: Codable {
    let url: String
}

struct Horoscope63: Codable {
    let fortune: String

    let health_index: String
    let discuss_index: String
    let lucky_color: String
    let lucky_numbers: String

    let comments: String
    let love: String
    let academic: String
    let wealth_luck: String
    let health_luck: String
}

struct Personal {
    let name: String
    let horoscopeIdx: Int
    
    // profile photo
}

let horoscopeName: [String] = [  // 0~11
    "牡羊",
    "金牛座",
    "雙子",
    "巨蟹座",
    "獅子",
    "處女座",
    "天秤座",
    "天蠍",
    "射手座",
    "摩羯座",
    "水瓶座",
    "雙魚"
]
