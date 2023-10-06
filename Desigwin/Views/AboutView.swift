//
//  AboutView.swift
//  Desigwin
//
//  Created by kuroisi on 2022/01/28.
//

import SwiftUI

struct AboutView: View {
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    var body: some View {
        VStack(spacing: 8) {
            //Text("ABOUT").font(.largeTitle)
              //  .padding(.top, 20)
           
            
            List {
                Section {
                    Text("STEP1\n気になったデザインを撮影")
                    Text("STEP2\n撮影したデザインに必殺技をつけよう")
                    Text("STEP3\n必殺技を決めたら「ダブルタップ」で保存")
                    Text("STEP4\n一覧から対象の必殺技を選択して詳しいデザイン効果をつけよう")
                    Text("削除は、一覧から対象の必殺技を「長押し」するとできます")
                } header: {
                    Text("必殺技のつくり方")
                }
                
                Section {
                    Image("setsumei1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    Text("『デザインストックアプリ デザインの必殺技』では、街中の気になったデザインを撮影し、自分だけの「デザインの必殺技」をストックすることができます。\n\nそれぞれに合った必殺技名をつけることもできるので、覚えやすく、デザイン制作を行う時に思い出しやすくなる効果もあります。このアプリを活用して、自分だけの必殺技をたくさんストックしてデザインライフをエンジョイしましょう！\n\n ※ デザインの必殺技とは、「グラフィックデザインで使えば絶対に良くなるすべらない鉄板技」のことを指します。")
                        .lineSpacing(8)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        
                } header: {
                    Text("デザインの必殺技について")
                }
                
                
                
                /*Section {
                    Text("前田デザイン室　室長・前田高志の初めての著書です。\n\n「デザインはデザイナーだけのものじゃない」と語る前田室長の言葉通り、デザイン書としてだけでなくビジネス書としても注目を浴び、さまざまな人が手に取った一冊です。\n\nこの書籍をカードゲームにするということには、本を読むだけではなく、デザインをさらに身近で実践的に面白い学びとして届けたいという想いがあります。")
                    //Text("書籍『勝てるデザイン』の購入はこちら(Amazon)")
                } header: {
                    Text("書籍『勝てるデザイン』について")
                }*/
                
                Section {
                    Text("2018年3月1日に、元・任天堂デザイナー前田高志が立ち上げた「仕事とは違うデザインの楽しさ」を追求するクリエイター集団です。デザインを楽しむことで「デザイナーの閉塞感問題」を解消していきます。")
                        .lineSpacing(8)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    //Text("前田デザイン室はこちら")
                } header: {
                    Text("前田デザイン室について")
                }
                
                
                Section {
                    Text("Art direction：Maeda Takashi")
                    Text("Design：Maruta Miho")
                    Text("Program：Kuroishi")
                } header: {
                    Text("Thanks")
                }
                
                Section {
                    Text("\(version)")
                } header: {
                    Text("Version")
                }
                
            }
            Text("(c) 前田デザイン室, ALL RIGHTS RESERVED.").font(.caption)
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
