import SpriteKit
import SwiftUI

class GameSceneEnding: SKScene {
    var cameraNode: SKCameraNode!
    var hsvDegree: CGFloat = 0.0
    var isTouchEnable = true
    var textIndex = 0
    
    let textNode = {
        let textNode = SKLabelNode(fontNamed: PRIMARY_FONT)
        textNode.text = ""
        textNode.fontSize = 36
        textNode.fontColor = .black
        textNode.position = CGPoint(
            x: GAMESCREEN_SIZE.width/2,
            y: GAMESCREEN_SIZE.height/2
        )
        textNode.zPosition = 3
        textNode.numberOfLines = -1
        return textNode
    }()
    
    func animateNextText(){
        let currentText = endingTexts[textIndex]
        textIndex += 1
        textNode.removeAllActions()
        textNode.run(.sequence([
            .fadeOut(withDuration: 0),
            .run{ [weak self] in
                guard let self = self else { return }
                self.textNode.text = currentText
            },
            .fadeIn(withDuration: 2)
        ]))
    }
    
    func moveToTitleScreen(){
        isTouchEnable = false
        let bg2Node = SKShapeNode(rectOf: GAMESCREEN_SIZE)
        bg2Node.position = self.centerPoint
        bg2Node.fillColor = .white
        bg2Node.zPosition = 1001
        self.addChild(bg2Node)
        bg2Node.run(.sequence([
            .fadeOut(withDuration: 0),
            .fadeIn(withDuration: 3),
        ])){
            self.changeScene(scene: GameSceneTitle())
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        self.addChild(textNode)
        animateNextText()
        
        let backgroundSound = SKAudioNode(fileNamed: "plain_sight.wav")
        self.addChild(backgroundSound)
        backgroundSound.run(.play())
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first else { return }
        guard isTouchEnable else { return }
        if textIndex < endingTexts.count {
            animateNextText()
            return
        }
        moveToTitleScreen()
    }
}

struct GameSceneEndingScreen: View {
    var scene: SKScene {
        let scene = GameSceneEnding()
        scene.size = GAMESCREEN_SIZE
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .frame(minWidth: 0, maxWidth: .infinity)
            .aspectRatio(SPRITEVIEW_RATIO, contentMode: .fit)
    }
}

struct GameSceneEndingScreen_Previews: PreviewProvider {
    static var previews: some View {
        CustomPreviewView{
            GameSceneEndingScreen()
        }
    }
}
