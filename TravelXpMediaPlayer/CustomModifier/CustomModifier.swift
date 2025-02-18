//
//  CustomModifier.swift
//  TravelXpMediaPlayer
//
//  Created by Aditya Bikram Swain on 17/02/25.
//

import SwiftUI

// Modifier to transition from top (for your first transition)
struct TransitionModifier: ViewModifier {
    var showNavigation: Bool
    
    func body(content: Content) -> some View {
        content
            .transition(
                .asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),  // Move from the top and fade in
                    removal: .move(edge: .top).combined(with: .opacity)     // Move upwards and fade out
                )
            )
            .animation(.easeInOut(duration: 0.3), value: showNavigation) // Smooth animation
    }
}


// Modifier for transition from the bottom (fix for your bottom transition)
struct TransitionMoveDown: ViewModifier {
    var showNavigation: Bool
    
    func body(content: Content) -> some View {
        content
            .transition(
                .asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),  // Appear from the bottom and fade in
                    removal: .move(edge: .bottom).combined(with: .opacity)     // Disappear to the bottom and fade out
                )
            )
            .animation(.easeInOut(duration: 0.3), value: showNavigation) // Smooth animation
    }
}

extension View {
    func transitionModifier(showNavigation: Bool) -> some View {
        self.modifier(TransitionModifier(showNavigation: showNavigation))
    }
    func transitionMoveDown(showNavigation: Bool) -> some View {
        self.modifier(TransitionMoveDown(showNavigation: showNavigation))
    }
}
