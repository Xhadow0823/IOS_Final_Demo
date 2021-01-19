//
//  AppView.swift
//  IOS_Final
//
//  Created by 翁星宇 on 2021/1/8.
//

import SwiftUI

struct AppView: View {
    @StateObject var profileData = ProfileData()
    @StateObject var fevPosts = FevPosts()
    
//    @Environment(\.managedObjectContext) private var viewContext
//    LPost
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \LPost.id, ascending: true)],
//        animation: .default)
//    private var offlinePosts: FetchedResults<LPost>

    var body: some View {
        TabView{
            PersonalPage()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("個人")
                }
            PostList()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Dcard 星座文章")
                }
            FavPostList()
                .tabItem {
                    Image(systemName: "heart")
                    Text("收藏")
                }
            Setting()
                .tabItem {
                    Image(systemName: "figure.wave.circle")
                    Text("個人設定")
                }
        }
        .accentColor(.purple)
        .environmentObject(profileData)
        .environmentObject(fevPosts)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
