//
//  MyDwListView.swift
//  Desigwin
//
//  Created by kuroisi on 2022/01/27.
//

import SwiftUI
import CoreData

struct MyDwListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    @StateObject private var myDwModel = MyDwModel()
    @ObservedObject var avFoundationVM: AVFoundationVM
    @Binding var isTakePhoto: Bool
    @State private var isAbout = false
    @State private var isWebView = false
    @State private var isSearchFav = false
    @State private var favImageName = "heart_white"
    @State private var favImageNameNav = "heart_nav"
    @State private var listImageNameNav = "bt-ichiran_ac"
    @State private var creatorIcoImageName = "ico00"
    @State private var headerTxt: String = "あなたが覚えた必殺技："
    @State private var headerTxtNew: String = "あなただけのデザインの必殺技をみつけよう！"
    
    
    /*@FetchRequest(
    //データの取得方法を指定　下記は日付降順
    entity:Mydw.entity(),sortDescriptors: [NSSortDescriptor(keyPath: \Mydw.date, ascending: false)],
        animation: .default)*/

    //private var mydws: FetchedResults<Mydw>
    
    /*init() {
        //UINavigationBar.appearance().barTintColor = UIColor.blue // 背景色
        //UINavigationBar.appearance().titleTextAttributes = [ .foregroundColor: UIColor.white] // タイトル色
        UINavigationBar.appearance().tintColor = .black // backボタン色
    }*/

    var body: some View {
        let mydws = getAllData()
        
        ZStack(alignment: .top) {
            let countText: String = String(mydws.count)
        
        
        
            GeometryReader { geometry in
                    
                ScrollView {
                    if (mydws.count > 0) {
                        VStack {
                            
                            //キャラ
                            /*Image(creatorIcoImageName)
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 70, height: 70, alignment: .center)
                                .padding(.bottom, 5)*/
                            Text(headerTxt + "全" + countText + "種類")
                                .font(.headline)
                        }.frame(width: UIScreen.main.bounds.size.width, alignment: .center)
                            .padding(.top, 120)
                            .padding(.bottom, 15)
                        
                        
                        //Section(header: Text(headerTxt + "全" + countText + "種類")) {
                            LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 0, pinnedViews: .sectionHeaders) {
                                //データを表示する
                                ForEach(mydws) { mydws in
                                    MyDwView(myDwModel: myDwModel, mydw: mydws)
                                }
                            }
                            .frame(width: UIScreen.main.bounds.size.width * 0.94, alignment: .center)

                            
                        //}
                    } else {
                        VStack {
                            /*Image(creatorIcoImageName)
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 70, height: 70, alignment: .center)
                                .padding(.bottom, 5)*/
                                
                            Text(headerTxtNew)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }.frame(width: UIScreen.main.bounds.size.width, alignment: .center)
                            .padding(.top, 140)
                    }
                }
            }
            .statusBar(hidden: true)
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("デザインの必殺技")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(action: {
                    isAbout = true
                }) {
                    Image(systemName: "questionmark.circle")
                        //.foregroundColor(.white)
                }
                .sheet(isPresented: self.$isAbout) {
                    
                    HStack(alignment: .center) {
                        Text("ABOUT").font(.headline)
                            .foregroundColor(.black)
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                            .padding(.leading, 20)
                        Spacer()
                        Button("閉じる", action: {
                            self.isAbout = false
                        })
                            .buttonStyle(.bordered)
                            .padding(.top, 20)
                            .padding(.trailing, 10)
                    }
                    
                    //アバウト表示
                    AboutView()
                    
                    //WebView(loadUrl: "https://whats.maeda-design-room.net/")
                    //Text("アプリの説明と使い方のヘルプなどを掲載予定。更新できるようにWebサイトを表示する")
                    
                    /*Text("Ver. "+"\(version)")
                        .padding(.top, 5)
                    Text("(c) 前田デザイン室, ALL RIGHTS RESERVED.").font(.caption)*/
                }
                
               
            )

            
            //フッターボタン
            VStack {
                Spacer()
                GroupBox {
                    HStack {
                        Button(action: {
                            isTakePhoto = false
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            VStack {
                                Image("bt-big-camera_w")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .center)
                                Text("つくる").font(.caption2)
                                    .bold()
                                    .accentColor(.black)
                            }.frame(width: 70, alignment: .center)
                        }

                    
                        
                        Button(action: {
                            self.isSearchFav = false
                            favImageName = "heart_white"
                            favImageNameNav = "heart_nav"
                            listImageNameNav = "bt-ichiran_ac"
                            headerTxt = "あなたが覚えた必殺技："
                            headerTxtNew = "あなただけのデザインの必殺技をみつけよう！"
                        }) {
                            VStack {
                                Image(listImageNameNav)
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .center)
                                Text("リスト").font(.caption2)
                                    .bold()
                                    .accentColor(.black)
                            }.frame(width: 70, alignment: .center)
                        }
                        
                        
                 
                        Button(action: {
                            //self.$isSearchFav.wrappedValue.toggle()
                            self.isSearchFav = true
                            
                            if self.isSearchFav {
                                favImageName = "heart"
                                favImageNameNav = "heart_nav_ac"
                                listImageNameNav = "bt-ichiran"
                                headerTxt = "お気に入りの必殺技："
                                headerTxtNew = "集めた必殺技をタップして\nハートボタンでお気に入り登録しよう！"
                            } else {
                                favImageName = "heart_white"
                                favImageNameNav = "heart_nav"
                                headerTxt = "あなたが覚えた必殺技："
                                headerTxtNew = "あなただけのデザインの必殺技をみつけよう！"
                            }
                            
                            //print("お気に入り表示")
                        }) {
                            VStack {
                                Image(favImageNameNav)
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .center)
                                Text("お気に入り").font(.caption2)
                                    .bold()
                                    .accentColor(.black)
                            }.frame(width: 70, alignment: .center)
                        }

                    
                        Button(action: {
                            
                            self.isWebView = true
                        }) {
                            VStack {
                                
                                /*Image("dw100")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .center)*/
                                Image("bt-tag")
                                    .resizable()
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .foregroundColor(.gray)
                                Text("必殺技").font(.caption2)
                                    .bold()
                                    .accentColor(.black)
                            }.frame(width: 70, alignment: .center)
                        }
                           
                        
                    }
                    
                }
                .cornerRadius(32)
                .frame(width: UIScreen.main.bounds.size.width * 0.98, alignment: .center)
                //.shadow(color: .black.opacity(0.1), radius: 4)
                //.foregroundColor(.black)
                //.accentColor(.black)
                //.opacity(0.9)
            }
            
            .sheet(isPresented: self.$isWebView) {
                HStack {
                    Text("#デザインの必殺技").font(.headline)
                        .foregroundColor(.black)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        .padding(.leading, 20)
                    Spacer()
                    Button("閉じる", action: {
                        self.isWebView = false
                    })
                        .buttonStyle(.bordered)
                        .padding(.top, 20)
                        .padding(.trailing, 10)
                }
                
                /*HStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            self.isWebView = false
                        }) {
                            HStack {
                                Image(systemName: "xmark.circle")
                                Text("必殺技100").font(.caption2)
                                    .accentColor(.white)
                            }
                        }.padding(5)
                    }
                }*/
                //ハッシュタグ検索
                WebView(loadUrl: "https://twitter.com/search?q=%23%E3%83%87%E3%82%B6%E3%82%A4%E3%83%B3%E3%81%AE%E5%BF%85%E6%AE%BA%E6%8A%80&src=typed_query&f=live")
            }

        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.creatorIcoImageName = getCreatorIcoImageName(level: mydws.count)
        }
        .onDisappear {
            isTakePhoto = false
            avFoundationVM.image = nil
        }
    }
    
    func getCreatorIcoImageName(level: Int) -> String {
        var imageName = ""
        
        if (level >= 0 && level <= 2) {
            imageName = "ico00"
        } else if (level >= 3 && level <= 9) {
            imageName = "ico01"
        } else if (level >= 10 && level <= 49) {
            imageName = "ico02"
        } else if (level >= 49 && level <= 99) {
           imageName = "ico03"
        } else if (level >= 100 && level <= 999) {
            imageName = "ico04"
        } else if (level >= 1000) {
            imageName = "ico05"
        }
        
        return imageName
    }
    
    func getAllData() -> [Mydw] {
        let persistenceController = PersistenceController.shared
        let context = persistenceController.container.viewContext
        
        let request = NSFetchRequest<Mydw>(entityName: "Mydw")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Mydw.date, ascending: false)]

        //var predicate = NSPredicate(format: "img != ''")
        
        if isSearchFav {
            let predicate = NSPredicate(format: "isFav == true")
            request.predicate = predicate
            //print("お気に入り")
        }
        
        //request.predicate = predicate
        
        do {
            let mydw = try context.fetch(request)
            return mydw
        }
        catch {
            fatalError()
        }
    }
    
}
