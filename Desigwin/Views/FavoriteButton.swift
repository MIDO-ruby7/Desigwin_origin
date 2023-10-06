//
//  FavoriteButton.swift
//  Desigwin
//
//  Created by kuroisi on 2022/02/01.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isFavorite: Bool
    private var onTapped: (() -> Void)?
    
    init(isFavorite: Binding<Bool>, onTapped: (() -> Void)? = nil) {
        self._isFavorite = isFavorite
        self.onTapped = onTapped
    }
    
    var body: some View {
        configureFavoriteImage()
    }
    
    private func configureFavoriteImage() -> AnyView {
        var imageName = "heart_nav"
        if self.$isFavorite.wrappedValue {
            imageName = "heart_nav_ac"
        }
        
        return AnyView(
            /*Image(systemName: imageName)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .onTapGesture {
                    self.$isFavorite.wrappedValue.toggle()
                    self.onTapped?()
                }*/
            
            VStack {
                Image(imageName)
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .shadow(color: .black.opacity(0.3), radius: 2)
                    .onTapGesture {
                        self.$isFavorite.wrappedValue.toggle()
                        self.onTapped?()
                    }
                Text("お気に入り").font(.caption2)
                    .bold()
                    .accentColor(.black)
            }
                
            
        )
    }
}

