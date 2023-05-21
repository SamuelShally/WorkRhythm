//
//  webFeedback.swift
//  IntervalsApp
//
//  Created by Samuel Shally  on 6/23/21.
//

import Foundation
import SwiftUI
import WebKit

struct Webview : UIViewRepresentable
{
//    typealias UIViewType = WKWebView
    
    var url : String
        
    func makeUIView(context: Context) -> WKWebView
    {

        guard let feedbackURL = URL(string: self.url) else{
            
            return WKWebView()
        }
        
        let request = URLRequest(url: feedbackURL)
        
        let webView = WKWebView()
        
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context)
    {
        
    }

}
