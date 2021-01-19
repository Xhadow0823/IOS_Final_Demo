//
//  widget_final.swift
//  widget_final
//
//  Created by 翁星宇 on 2021/1/19.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
//    @StateObject var profileData = ProfileData()
    @State private var now = 5
    @State private var horoscope63: Horoscope63?
    
    func fetch(){
        let strURL = "http://api.63code.com/fortune_today/api.php?fortune="
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
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), horoscope63: horoscope63)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), horoscope63: horoscope63)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        if let url = URL(string: "http://api.63code.com/fortune_today/api.php?fortune="),
           let data = try? Data(contentsOf: url){
            do{
                horoscope63 = try JSONDecoder().decode(Horoscope63.self, from: data)
            } catch {
                print("error")
            }
        }else{
            print("error")
        }
        for hourOffset in 0 ..< 5 {
//            fetch()
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, horoscope63: horoscope63)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let horoscope63: Horoscope63?
}

struct widget_finalEntryView : View {
    var entry: Provider.Entry

//    @State private var horoscope63:Horoscope63?
    var body: some View {
        VStack {
            Text(entry.date, style: .time)
//            Image(systemName: "circle").resizable().scaledToFit()
            HStack{
                VStack{
                    Text("健康指數").bold().padding(.horizontal, 2).background(Color.purple).foregroundColor(.white).cornerRadius(9)
                    if let horoscope63 = entry.horoscope63 {
                        Text(horoscope63.health_index)
                    }else{
                        Text("88%").bold()
                    }
                }
                VStack{
                    Text("商談指數").bold().padding(.horizontal, 2).background(Color.purple).foregroundColor(.white).cornerRadius(9)
                    if let horoscope63 = entry.horoscope63 {
                        Text(horoscope63.discuss_index)
                    }else{
                        Text("93%").bold()
                    }
                }
            }  // end HStack
            HStack{
                VStack{
                    Text("幸運顏色").bold().padding(.horizontal, 2).background(Color.purple).foregroundColor(.white).cornerRadius(9)
                    if let horoscope63 = entry.horoscope63 {
                        Text(horoscope63.lucky_color)
                    }else{
                        Text("紅色").bold()
                    }
                }
                VStack{
                    Text("幸運數字").bold().padding(.horizontal, 2).background(Color.purple).foregroundColor(.white).cornerRadius(9)
                    if let horoscope63 = entry.horoscope63 {
                        Text(horoscope63.lucky_numbers)
                    }else{
                        Text("5").bold()
                    }
                }
            }  // end HStack
        }  // end VStack
    }
}

@main
struct widget_final: Widget {
    let kind: String = "widget_final"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            widget_finalEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct widget_final_Previews: PreviewProvider {
    
    static var previews: some View {
        widget_finalEntryView(entry: SimpleEntry(date: Date(), horoscope63: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct Horoscope63: Codable {
    let fortune: String

    let health_index: String
    let discuss_index: String
    let lucky_color: String
    let lucky_numbers: String
}
