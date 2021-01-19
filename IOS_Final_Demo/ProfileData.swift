//
//  ProfileData.swift
//  IOS_Final_Demo
//
//  Created by 翁星宇 on 2021/1/11.
//

import Foundation
import SwiftUI

struct Profile : Codable{
    var image: Data?;
    var horo: Int;  // 0~11, API 用要記得+1
}

class ProfileData: ObservableObject{
    @Published var data: Profile?
    @AppStorage("profileData") var profileData: Data?
    
    init(){
        if let profileData = profileData {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(Profile.self, from: profileData) {
                data = decodedData
            }
        }
    }
}
