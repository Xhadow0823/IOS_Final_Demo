//
//  FavPostList.swift
//  IOS_Final_Demo
//
//  Created by 翁星宇 on 2021/1/11.
//

import SwiftUI

struct FavPostList: View {
    @EnvironmentObject var fevPosts: FevPosts
//    @ObservedObject var fevPosts: FevPosts = FevPosts()
    
    
    @State private var target: String = ""
    var filtedFevPosts: [Post] {
        return fevPosts.posts.filter({target.isEmpty ? true : $0.title.contains(target)})
    }
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("🔍尋找對象", text: $target)
                    .padding(7)
                    .border(Color.black)
                    .padding()
                List(fevPosts.posts.indices, id: \.self){
                    (idx) in
                    PostRow(postData: fevPosts.posts[idx])
                }
//                List{
//                    ForEach(filtedFevPosts.indices){
//                        (idx) in
//                        PostRow(postData: filtedFevPosts[idx])
//                    }
//                }
            }
            .navigationTitle("收藏文章")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct FavPostList_Previews: PreviewProvider {
    static var previews: some View {
        FavPostList()
    }
}
