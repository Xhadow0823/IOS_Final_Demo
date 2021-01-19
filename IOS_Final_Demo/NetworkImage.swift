//
//  NetworkImage.swift
//  IOS_Bonus_randomPic
//
//  Created by 翁星宇 on 2020/12/16.
//

import SwiftUI

struct NetworkImage: View {
    var urlStr: String
    @State private var image = Image(systemName: "photo")
    @State private var downloadImageOk = false
    
    func downLoad() {
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                print("downloading...")
                if let data = data,
                   let uiImage = UIImage(data: data) {
                    image = Image(uiImage: uiImage)
                    downloadImageOk = true
                }
            }.resume()
        }
    }
    
    var body: some View {
        image
            .resizable()
            .onAppear {
                if downloadImageOk == false {
                    downLoad()
                }
            }
            .onTapGesture {
                if downloadImageOk == true{
                    downLoad()
                }
            }
    }
}

struct NetworkImage_Previews: PreviewProvider {
    static var previews: some View {
        NetworkImage(urlStr: "https://loremflickr.com/320/240")
    }
}
