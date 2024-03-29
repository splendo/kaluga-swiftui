//
//  NavigationDemoView.swift
//  KalugaSwiftUI
//
//  Created by Carmelo Gallo on 25/01/2022.
//

import SwiftUI

struct NavigationDemoView: View {
    
    @ObservedObject var fullscreen = ObjectRoutingState<Bool>()
    @ObservedObject var sheet = ObjectRoutingState<Bool>()

    var body: some View {
        if #available(iOS 15.0, *) {
            contentView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.red)
        } else {
            Color.red
                .ignoresSafeArea(.all)
                .overlay(
                    contentView
                )
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 32) {
            Button {
                fullscreen.show(true)
            } label: {
                Text("Fullscreen")
                    .font(.title)
                    .foregroundColor(.white)
            }
            
            Button {
                fullscreen.show(true)
            } label: {
                Text("Sheet")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
        .navigation(state: fullscreen, type: .fullscreen) {
            Fullscreen().environmentObject(fullscreen)
        }
        .navigation(state: sheet, type: .sheet) {
            Sheet().environmentObject(sheet)
        }
    }
}

struct Fullscreen: View {
    
    @EnvironmentObject var fullscreen: ObjectRoutingState<Bool>

    var body: some View {
        if #available(iOS 15.0, *) {
            contentView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.yellow)
        } else {
            Color.yellow
                .ignoresSafeArea(.all)
                .overlay(
                    contentView
                )
        }
    }
    
    private var contentView: some View {
        ZStack {
            Button {
                fullscreen.close()
            } label: {
                Text("Dismiss")
                    .font(.title)
                    .foregroundColor(.green)
            }
        }
    }
}

struct Sheet: View {
    
    @EnvironmentObject var sheet: ObjectRoutingState<Bool>
    
    var body: some View {
        if #available(iOS 15.0, *) {
            contentView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.green)
        } else {
            Color.green
                .ignoresSafeArea(.all)
                .overlay(
                    contentView
                )
        }
    }
    
    private var contentView: some View {
        ZStack {
            Button {
                sheet.close()
            } label: {
                Text("Dismiss")
                    .font(.title)
                    .foregroundColor(.red)
            }
        }
    }
}
