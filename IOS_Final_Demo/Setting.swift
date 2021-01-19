//
//  Setting.swift
//  IOS_Final_test
//
//  Created by 翁星宇 on 2021/1/7.
//

import SwiftUI
import WidgetKit

struct Setting: View {
    @EnvironmentObject var profileData: ProfileData
//    @ObservedObject var profileData: ProfileData = ProfileData()
    
    @EnvironmentObject var fevPosts: FevPosts
    
    @State private var select = 0;
    @State private var showSelectPhoto = false;
    @State private var selectImage: UIImage?
    
    @State private var showAlert = false;
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    if let imageData = profileData.data?.image{
                        Image(uiImage: UIImage(data: imageData)!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .mask(Circle())
                    }else{
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .onTapGesture(count: 1, perform: {
                                showSelectPhoto = true
                            })
                    }
                    Spacer()
                    VStack{
                        Text("星座").bold()
                        Text("\(horoscopeName[select])\n")
                        Text("已儲存\(fevPosts.posts.count)則貼文")
                    }
                    Spacer()
                }
                
                Picker("星座", selection: $select) {
                    ForEach(horoscopeName.indices){
                        (idx) in
                        Text(horoscopeName[idx])
                    }
                }.onChange(of: select, perform: { value in
                    print("set2")
                    profileData.data?.horo = select
                })
                HStack {
                    Spacer()
                    Button(" 更新頭像 ") {
                        showSelectPhoto = true
                    }.padding(5).border(Color.black)
                    Spacer()
                    Button("更新Widget") {
                        WidgetCenter.shared.reloadAllTimelines()
                        showAlert = true
                    }.padding(5).border(Color.black)
                    Spacer()
                }
                .alert(isPresented: $showAlert){
                    return Alert(title: Text("成功！"))
                }
                Spacer()
            }.padding(.horizontal, 30)
            .sheet(isPresented: $showSelectPhoto){
                ImagePickerController(selectImage: $selectImage, showSelectPhoto: $showSelectPhoto)
            }
            .onChange(of: selectImage, perform: { value in
                profileData.data?.image = selectImage?.pngData()
                print("Image set!")
            })
            .onAppear{
                if let data = profileData.data{
                    print("set")
                    select = data.horo
                }else{
                    print("YES")
                    profileData.data = Profile(horo: select)
                }
            }
            .navigationTitle("個人設定")
        }
    }
}

struct Setting_Previews: PreviewProvider {
    static var previews: some View {
        Setting()
    }
}
