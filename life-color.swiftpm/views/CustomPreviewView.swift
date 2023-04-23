import SwiftUI

struct CustomPreviewView <Content> : View where Content : View {
    let content: Content
    
    @inlinable public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body : some View {
        VStack{
            self.content
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity
        )
        .ignoresSafeArea()
        .background(.black)
        .previewInterfaceOrientation(.landscapeRight)
    }
}
