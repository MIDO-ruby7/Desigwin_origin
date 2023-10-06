//
//  flameImageView.swift
//  Desigwin
//
//  Created by kuroisi on 2022/01/25.
//

import SwiftUI

struct flameImageView: View {
    var body: some View {
        Image("Desigwin_flame02")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
            .statusBar(hidden: true)
    }
}

struct flameImageView_Previews: PreviewProvider {
    static var previews: some View {
        flameImageView()
    }
}
