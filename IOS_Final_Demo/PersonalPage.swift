//
//  PersonalPage.swift
//  IOS_Final_test
//
//  Created by 翁星宇 on 2021/1/6.
//

import SwiftUI

struct PersonalPage: View {
    @EnvironmentObject var profileData: ProfileData
//    @ObservedObject var profileData: ProfileData = ProfileData()
    
    @State private var now = -1;
    private let strURL = "http://api.63code.com/fortune_today/api.php?fortune="
    @State private var horoscope63: Horoscope63?
    
    func fetch(){
        let url = URL(string: strURL + String(now+1))
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: urlRequest) {
            (data, response,error) in
            if let data = data {
                do {
                    horoscope63 = try JSONDecoder().decode(Horoscope63.self, from: data)
                    print(horoscope63!)
                } catch {
                    print("error")
                }
            }else {
                print("error")
            }
        }.resume()
    }
    
    var body: some View {
        NavigationView{
            VStack{
                if let imageData = profileData.data?.image{
                    Image(uiImage: UIImage(data: imageData)!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .mask(Circle())
                        .onTapGesture(count: 1, perform: {
                            fetch()
                        })
                }else{
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .onTapGesture(count: 1, perform: {
                            fetch()
                        })
                }
                if now >= 0 && now <= 11{
                    Text(horoscopeName[now]).bold()
                }else{
//                    Text("now is \(now)")
                    Text("請前往設定選擇星座!!").bold()
                }
                HStack{
                    VStack{
                        Text("健康指數\(now)").bold()
                        if let horoscope63 = horoscope63 {
                            Text(horoscope63.health_index)
                        }else{
                            Text("69%")
                        }
                    }
                    VStack{
                        Text("商談指數").bold()
                        if let horoscope63 = horoscope63 {
                            Text(horoscope63.discuss_index)
                        }else{
                            Text("69%")
                        }
                    }
                }
                HStack{
                    VStack{
                        Text("幸運顏色").bold()
                        if let horoscope63 = horoscope63 {
                            Text(horoscope63.lucky_color)
                        }else{
                            Text("小粉紅")
                        }
                    }
                    VStack{
                        Text("幸運數字").bold()
                        if let horoscope63 = horoscope63 {
                            Text(horoscope63.lucky_numbers)
                        }else{
                            Text("69")
                        }
                    }
                }
            
                Form{
                    Section(header: Text("運勢短評").bold()){
                        if let horoscope63 = horoscope63 {
                            Text(horoscope63.comments)
                        }else{
                            Text("想法落实到行动。")
                        }
                    }
                    
                    Section(header: Text("愛情運勢").bold()){
                        if let horoscope63 = horoscope63 {
                            Text(horoscope63.love)
                        }else{
                            Text("单身的有望和心上人互通心意，很适合表白或是约会。恋爱中的会收获到来自恋人的甜言蜜语，让你甜到心坎里去。")
                        }
                    }
                    Section(header: Text("事業運勢").bold()){
                        if let horoscope63 = horoscope63 {
                            Text(horoscope63.academic)
                        }else{
                            Text("工作方面你的好奇心比较旺盛，会主动提出疑问，能够得到前辈为你解疑答惑，有丰厚的收获，而且也能得到不错的表现。")
                        }
                    }
                    Section(header: Text("財富運勢").bold()){
                        if let horoscope63 = horoscope63 {
                            Text(horoscope63.wealth_luck)
                        }else{
                            Text("求财只能保持中规中矩的进账情况，收入基本保持平衡，进账都是零散的小财，都用于日常的花销，就没多少剩余了。")
                        }
                    }
                    Section(header: Text("健康運勢").bold()){
                        if let horoscope63 = horoscope63 {
                            Text(horoscope63.health_luck)
                        }else{
                            Text("尽量避免出远门的决定，容易出现水土不服的情况，而且现在疫情比较反复，还是尽量减少到处跑动比较好。")
                        }
                    }
                }  // Form end
            }  // VStack end
            .onAppear{
                if let data = profileData.data{
                    now = data.horo
                    fetch()
                }else{
                    now = 69
                }
            }
            .navigationTitle("個人星座運勢")
        }  // NavigationView end
    }
}

struct PersonalPage_Previews: PreviewProvider {
    static var previews: some View {
        PersonalPage()
    }
}
