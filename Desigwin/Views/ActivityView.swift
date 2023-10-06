//
//  ActivityView.swift
//  Desigwin
//
//  Created by kuroisi on 2022/01/28.
//

import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    let shareItems: [Any]
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIActivityViewController(
            activityItems: shareItems,
            applicationActivities: nil
        )
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<ActivityView>) {
        //なし
    }
}
