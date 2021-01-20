//
//  PostRow.swift
//  IOS_Final_test
//
//  Created by 翁星宇 on 2020/12/30.
//

import SwiftUI
import Kingfisher

struct PostRow: View {
    @Environment(\.openURL) var openURL
    var postData: Post?
    
    @State private var mediaURL: String?
    
    @EnvironmentObject var fevPosts: FevPosts
//    @ObservedObject var fevPosts: FevPosts = FevPosts()
    
    @State private var showAlert = false;
    
    func fetchMediaURL() {
        if let postData = postData,
           let url = URL(string: "https://www.dcard.tw/service/api/v2/posts/\(String(postData.id))"){
            URLSession.shared.dataTask(with: url) {
                (data, response,error) in
                if let data = data {
                    do {
                        let postDetail = try JSONDecoder().decode(PostDetail.self, from: data)
//                        print(postDetail.media?.count)
                        if postDetail.media?.count ?? 0 >= 1{
                            mediaURL = (postDetail.media?[0].url)
                        }
                        
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
        HStack{
            if let mediaURL = mediaURL {
//                NetworkImage(urlStr: mediaURL)
//                    .frame(width: 80, height: 80)
//                    .scaledToFill()
//                    .clipped()
                KFImage(URL(string: mediaURL)!)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .scaledToFill()
                    .clipped()
            }else {
                Image(systemName: "circle")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .scaledToFill()
                    .clipped()
                    .onAppear{
                        fetchMediaURL()
                    }
//                    .onTapGesture(count: 1, perform: {
//                        fetchMediaURL()
//                    })
            }
            // KingFisher
            VStack(alignment: .leading){
                if let postData = postData {
                    Text(postData.title).bold()
                    Text(postData.excerpt)
                        .lineLimit(2)
//                    Link("Link", destination: makeDcardURL(postData: postData))
                }else{
                    Text("Data Error!!")
                }
            }
            .onTapGesture(count: 1, perform: {
                openURL(makeDcardURL(postData: postData!))
//                actionSheet(url: makeDcardURL(postData: postData!))
            })
            .padding(.leading, 10)
            
            Spacer()
        }.padding(.horizontal, 5)
    }
}


struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        PostRow(postData: Post(id: 235029094, title: "年終禮物", excerpt: "hello hello hello hello hello hello ----------", forumAlias: "makeup"))
            .previewLayout(.sizeThatFits)
    }
}

func makeDcardURL(postData: Post) -> URL{
    return URL(string: "https://www.dcard.tw/f/\(postData.forumAlias)/p/\(postData.id)")!
}


