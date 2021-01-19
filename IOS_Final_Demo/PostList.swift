//
//  PostList.swift
//  IOS_Final_test
//
//  Created by 翁星宇 on 2020/12/30.
//

import SwiftUI

struct PostList: View {
//    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \LPost.id, ascending: true)],
//        animation: .default)
//    private var offlinePosts: FetchedResults<LPost>
    
    
    @EnvironmentObject var profileData: ProfileData
//    @ObservedObject var profileData: ProfileData = ProfileData()
    
    @EnvironmentObject var fevPosts: FevPosts
//    @ObservedObject var fevPosts: FevPosts = FevPosts()
    
    
    @State private var posts: [Post] = [Post]()
    @State private var select: Int = 0;
    @State private var showAlert = false;
    @State private var useDefaultHoro = true;

    func fetch(){
        print("hi")
        if let url = URL(string: makeURL(horo: select)){
            URLSession.shared.dataTask(with: url) {
                (data, response,error) in
                if let data = data {
                    do {
                        posts = try JSONDecoder().decode([Post].self, from: data)
//                        print(posts)
                    } catch {
                        print("error")
                    }
                }else {
                    print("error")
                }
            }.resume()
        }
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
                Picker("星座", selection: $select) {
                    ForEach(horoscopeName.indices){
                        (idx) in
                        Text(horoscopeName[idx])
                    }
                }
                .onChange(of: select, perform: { value in
//                    useDefaultHoro = false;
                    fetch()
                })
                .onAppear{
                    if let horo = profileData.data?.horo{
                        if useDefaultHoro{
                            select = horo
//                            print("the horo is \(horo) now")
                        }
                    }
                    fetch()
                }
                .frame(height: 82)
                
                List(posts.indices, id: \.self){
                    (idx) in
        //            ForEach((posts.indices)){
        //                (idx) in
        //                PostRow(postData: posts[idx])
        //            }
                    PostRow(postData: posts[idx])
//                        .onLongPressGesture {
////                            let newOfflinePost = LPost(context: viewContext)
////                            newOfflinePost.id = Int32(posts[idx].id)
////                            newOfflinePost.title = posts[idx].title
////                            newOfflinePost.forumAlias = posts[idx].forumAlias
////                            newOfflinePost.excerpt = posts[idx].excerpt
//                        }
                        .onLongPressGesture {
                            fevPosts.posts.insert(posts[idx], at: 0)
                            showAlert = true;
                        }
                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                .onEnded({ value in
                                if value.translation.width > 0 {  // right
                                    actionSheet(url: makeDcardURL(postData: posts[idx]))
                                }
                        }))
                        .alert(isPresented: $showAlert) { () -> Alert in
                            return Alert(title: Text("已加到最愛！"))
                        }
                    if posts.count == 0 {
                        Text("No data!!")
                    }
                }.onAppear{
//                    fetch()
                }
            }
            .navigationTitle("Dcard \(horoscopeName[select])文章")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PostList_Previews: PreviewProvider {
    static var previews: some View {
        PostList()
    }
}

// func make url
// with percent encoding

func makeURL(horo: Int) -> String {
    let horoStr: String = horoscopeName[horo]
    let encoded = horoStr.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    return "https://www.dcard.tw/service/api/v2/search/posts?limit=15&query=\( encoded!)&field=topics&sort=like"
}
