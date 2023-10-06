//
//  MyDwModel.swift
//  Desigwin
//
//  Created by kuroisi on 2022/01/27.
//

import Foundation
import SwiftUI
import CoreData

class MyDwModel : ObservableObject{
    @Published var date = Date()
    @Published var id = UUID()
    @Published var img: Data = Data.init()
    @Published var name = ""
    @Published var txt = ""
    @Published var isFav = false

    @Published var isNewData = false
    @Published var updateItem : Mydw!
    
    func writeData(context: NSManagedObjectContext){
        //データが新規か編集かで処理を分ける
        if updateItem != nil {
            
            updateItem.date = date
            updateItem.img = img
            updateItem.name = name
            updateItem.txt = txt
            updateItem.isFav = isFav
            
            try! context.save()
            
            /*updateItem = nil
            isNewData.toggle()
            
            date = Date()
            img = Data.init()
            name = ""
            txt = ""
            isFav = false*/
 
            return
        }
        //データ新規作成
        let newMydw = Mydw(context: context)
        newMydw.date = date
        newMydw.id = UUID()
        newMydw.img = img
        newMydw.name = name
        newMydw.txt = txt
        newMydw.isFav = isFav
        
        do{
            try context.save()
            
            isNewData.toggle()
            
            date = Date()
            img = Data.init()
            name = ""
            txt = ""
            isFav = false
        }
        catch {
            print(error.localizedDescription)
            
        }
    }
    //編集の時は既存データを利用する
    func editItem(item: Mydw){
        updateItem = item
        
        date = item.wrappedDate
        id = item.wrappedId
        img = item.wrappedImg
        name = item.wrappedName
        txt = item.wrappedTxt
        isFav = item.wrappedIsFav

        isNewData.toggle()
    }
}
