//
//  ContentView.swift
//  PullToSearch
//
//  Created by Coder on 01/06/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var offsetY: CGFloat = 0
    @FocusState private var isExpanded: Bool
    var body: some View {
        ScrollView(.vertical){
            DummyScrollContent()
                .offset(y: isExpanded ? -offsetY : 0)
            /// Attach this to the Root Scroll Content!
                .onGeometryChange(for: CGFloat.self) {
                    $0.frame(in: .scrollView(axis: .vertical)).minY
                } action: { newValue in
                    offsetY = newValue
                }
        }
        .overlay {
            Rectangle()
                .fill(.ultraThinMaterial)
                .background(.background.opacity(0.25))
                .ignoresSafeArea()
                .overlay {
                    ExpandedSearchView(isExpanded: isExpanded)
                        .offset(y: isExpanded ? 0 : 70)
                        .opacity(isExpanded ? 1 : 0)
                        .allowsHitTesting(isExpanded)
                    
                }
                .opacity(isExpanded ? 1 : progress)
        }
        .safeAreaInset(edge: .top){
            HeaderView()
        }
        .scrollTargetBehavior(OnScrollEnd { dy in
            if offsetY > 100 || (-dy > 1.5 && offsetY > 0) {
                isExpanded = true
            }
        })
        .animation(.interpolatingSpring(duration: 0.2), value: isExpanded)
    }
    
    /// Header View
    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 20){
            if !isExpanded{
                Button {
                    
                } label: {
                    Image(systemName: "slider.horizontal.below.square.filled.and.square").font(.title3)
                }
                .transition(.blurReplace)
            }
            
            /// Search bar
            TextField("Search App", text: .constant(""))
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background {
                    ZStack {
                        Rectangle()
                            .fill(.gray.opacity((0.2)))
                        
                        Rectangle()
                            .fill(.ultraThinMaterial)
                    }
                    .clipShape(.rect(cornerRadius: 15))
                }
                .focused($isExpanded)
            
            Button {
                
            } label: {
                Image(systemName: "person.circle.fill").font(.title2)
            }
            .opacity(isExpanded ? 0 : 1)
            .overlay(alignment: .trailing) {
                Button("Cancel") {
                    isExpanded = false
                }
                .fixedSize()
                .opacity(isExpanded ? 1 : 0)
            }
            .padding(.leading, isExpanded ? 20 : 0)
        }
        .foregroundStyle(Color.primary)
        .padding(.horizontal, 15)
        .padding(.top, 10)
        .padding(.bottom, 5)
        .background {
            Rectangle()
                .fill(.background)
                .ignoresSafeArea()
                .opacity(progress == 0 && !isExpanded ? 1 : 0)
        }
    }
    
    /// Dummy Scroll Content
    @ViewBuilder
    func DummyScrollContent() -> some View {
        VStack(spacing: 15) {
            HStack(spacing: 30) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.red.gradient)
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(.blue.gradient)
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(.green.gradient)
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(.yellow.gradient)
            }
            .frame(height: 60)
            
            VStack(alignment: .leading, spacing: 25) {
                Text("Favourites")
                    .foregroundStyle(.gray)
                
                Text("Start adding your favourites\nto show up here!")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(.top, 30)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 20)
    }
    
    /// Converting offset into progress
    var progress: CGFloat {
        return max(min(offsetY / 100, 1), 0)
    }
}

#Preview {
    ContentView()
}

struct OnScrollEnd: ScrollTargetBehavior {
    /// Return Velocity
    var onEnd: (CGFloat) -> ()
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        let dy = context.velocity.dy
        DispatchQueue.main.async {
            onEnd(dy)
        }
    }
}


struct ExpandedSearchView: View {
    var isExpanded: Bool
    var body: some View {
        List {
            let colors: [Color] = [.black, .indigo, .cyan]
            
            if isExpanded {
                ForEach(colors, id: \.self) {color in
                    Section(String.init(describing: color).capitalized){
                        ForEach(1...5, id: \.self) {index in
                            HStack(spacing: 10) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(color.gradient)
                                    .frame(width: 40, height: 40)
                                
                                Text("Search Item No: \(index)")
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 12, leading: 0, bottom: 12, trailing: 0))
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .clipped()
    }
}
