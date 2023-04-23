import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack (alignment: .center, spacing: 0){
            GameSceneTitleScreen()
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity
        )
        .ignoresSafeArea()
        .background(.black)
        .onAppear{
            let fontURL = Bundle.main.url(forResource: "upheavtt", withExtension: "ttf")
            // install font upheavtt
            CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}
