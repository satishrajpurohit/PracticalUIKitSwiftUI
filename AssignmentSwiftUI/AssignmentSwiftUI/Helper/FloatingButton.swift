//
//  FloatingButton.swift
//  AssignmentSwiftUI
//
//  Created by Satish Rajpurohit on 23/12/24.
//

import SwiftUI

// FloatingButton is a custom view that represents a floating action button.
// The button is positioned at the bottom-right of the screen and triggers an action when pressed.

struct FloatingButton: View {
    let action: () -> Void
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    action()
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                .padding()
            }
        }
    }
}
