//
//  MyDwView.swift
//  Desigwin
//
//  Created by kuroisi on 2022/01/27.
//

import SwiftUI
import UIKit

struct MyDwView: View {
    //@Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var context
    @State private var isSaveAlert = false
    @State private var isFavorite = false
    @ObservedObject var myDwModel:MyDwModel
    @ObservedObject var mydw:Mydw
    @State private var isMydw: Bool = false
    @State private var isShowActivity = false
    @State private var isEdit = false
    @State var txt = ""
    @FocusState var focus:Bool
    
    var body: some View {
        
        //CoreDataに保存されたデータを表示
        VStack(spacing: 12) {
            if mydw.img?.count ?? 0 != 0 {
                Image(uiImage: UIImage(data: mydw.img ?? Data.init())!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.size.width * 0.44)
                    .cornerRadius(4)
                    .padding(.bottom, 8)
            }
            //Text(mydw.wrappedDate, formatter: itemFormatter)
            /*Text(mydw.wrappedName)
                .font(.caption2)
                .fontWeight(.bold)
                .padding(.bottom, 10)*/
        }
        .shadow(color: .gray.opacity(0.2), radius: 4)
        .onTapGesture {
            self.txt = mydw.wrappedTxt
            self.isMydw = true
            self.isFavorite = mydw.wrappedIsFav
        }
        .sheet(isPresented: self.$isMydw) {
            ZStack(alignment: .bottom) {
                Color.white
                    .ignoresSafeArea()
                
                
                /*Button(action: {
                    //閉じる処理
                    self.presentationMode.wrappedValue.dismiss()

                }, label: {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.white)
                })
                .padding(10)
                .frame(
                    width: UIScreen.main.bounds.size.width,
                    alignment: .trailing
                )*/
                
                VStack(spacing: 8) {
                    HStack(alignment: .center) {
                        Text("必殺技 " + mydw.wrappedName).font(.headline)
                            .foregroundColor(.black)
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                            .padding(.leading, 20)
                        Spacer()
                        Button("閉じる", action: {
                            self.isMydw = false
                        })
                            .buttonStyle(.bordered)
                            .padding(.top, 20)
                            .padding(.trailing, 10)
                    }
                    
                    ScrollView {
                        ScrollViewReader { scrollValue in
                            VStack(spacing: 8) {
                                HStack {
                                    Text("どんな必殺技？").font(.headline)
                                    Spacer()

                                    /*Button(action: {
                                        isEdit = true
                                    }) {
                                        Image(systemName: "pencil.circle.fill")
                                            .font(.system(size: 28))
                                            .foregroundColor(.white)
                                    }*/
                                    
                                    Button("保存", action: {
                                        UIApplication.shared.closeKeyboard()
                                        //myDwModel.editItem(item: mydw)
                                        myDwModel.txt = self.txt
                                        myDwModel.writeData(context: context)
                                        isSaveAlert = true
                                    })
                                        .buttonStyle(.bordered)
                                        //.foregroundColor(.white)
                                        .alert(isPresented: $isSaveAlert) {
                                            Alert(
                                                title: Text("保存しました"),
                                                message: Text(""),
                                                dismissButton: .default(Text("OK"), action: {
                                                    isSaveAlert = false
                                                }))
                                        }
                                }
                                .frame(
                                    width: UIScreen.main.bounds.size.width * 0.9
                                )
                                
                                
                                TextEditor(text: $txt)
                                    .padding(5)
                                    .background(Color(red: 230/255, green: 230/255, blue: 230/255, opacity: 1))
                                    .cornerRadius(8)
                                    .frame(
                                        width: UIScreen.main.bounds.size.width * 0.9,
                                        height: 150,
                                        alignment: .leading
                                    )
                                
                                    
                  
                                /*Text("デザインの必殺技とは、デザインをするときに使うデザインの必殺技とは、デザインをするときに使うデザインの必殺技とは、デザインをするときに使う")
                                    .frame(
                                        width: UIScreen.main.bounds.size.width * 0.9,
                                        alignment: .leading
                                    )
                                    .padding(10)*/

                            }
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                            
                            
                            
                            //VStack {
                                Image(uiImage: UIImage(data: mydw.img ?? Data.init())!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(
                                        width: UIScreen.main.bounds.size.width * 0.92,
                                        height: UIScreen.main.bounds.size.height * 0.92
                                    )
                                    .cornerRadius(4)
                                    .padding(.top, 20)
                                    .padding(.bottom, 80)
                                    .shadow(color: .gray.opacity(0.2), radius: 4)
                            
                                                                
                            //}
                        }
                        
                        
                    }
                    .frame(
                        width: UIScreen.main.bounds.size.width
                    )
                    .background(Color(red: 247/255, green: 247/255, blue: 247/255, opacity: 1))
                    
                }
               
                
                HStack {
                    HStack() {
                        //お気に入り
                        FavoriteButton(isFavorite: $isFavorite, onTapped: {
                            myDwModel.isFav = self.isFavorite
                            //print(self.isFavorite)
                            myDwModel.writeData(context: context)
                        })
                       
                    }
                    .padding(.leading, 0)
                    .padding(.bottom, 15)
                    
                    Spacer()
                    //シェア
                    Button(action: {
                        isShowActivity = true
                        //let text = "#デザインの必殺技 \n\r" + mydw.wrappedName
                        //sharePost(shareText: text, shareImage: Image(uiImage: UIImage(data: mydw.img ?? Data.init())!), shareUrl: "")
                    }) {
                        VStack {
                            Image("bt-share")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .shadow(color: .black.opacity(0.3), radius: 2)
                            Text("シェア").font(.caption2)
                                .bold()
                                .accentColor(.black)
                        }
                        .padding(.bottom, 15)
                    }
                    .sheet(isPresented: $isShowActivity) {
                        let shareText = "#デザインの必殺技 \n「" + mydw.wrappedName + "」 \n\n" + self.txt
                        ActivityView(shareItems: [UIImage(data: mydw.img ?? Data.init())!, shareText])
                    }
                }
                .frame(width: UIScreen.main.bounds.size.width * 0.9, height: 50)
            }
            .onTapGesture(count: 1) {
                UIApplication.shared.closeKeyboard()
            }
            .onAppear {
                //print("表示")
                myDwModel.editItem(item: mydw)
            }
        }
        
        //カード長押しで編集と削除のボタンを表示
        .contextMenu {
                /*Button(action: {
                    myDwModel.editItem(item: mydw)
                    
                }) {
                    Label("必殺技の名前を変える", systemImage: "pencil")
                       
                }*/
            
                Button(action: {
                    context.delete(mydw)
                    try! context.save()
                }) {
                    Label("必殺技を忘れる", systemImage: "trash")
                       Image(systemName: "trash")
                }
         }
    }
    //日付表示のフォーマット
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
}
