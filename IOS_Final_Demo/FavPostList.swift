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
    
    func actionSheet(url: URL) {
//        guard let data = URL(string: urlStr) else { return }
        let data = url;
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
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
                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onEnded({ value in
                                if value.translation.width > 0 {  // right
                                    actionSheet(url: makeDcardURL(postData: fevPosts.posts[idx]))
                                }
                        }))
                }
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
