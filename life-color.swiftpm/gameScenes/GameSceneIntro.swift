import SpriteKit
import SwiftUI

class GameSceneIntro: SKScene {
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
        let currentText = introTexts[textIndex]
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
    
    func moveToFactoryScene(){
        isTouchEnable = false
        let bgNode = SKShapeNode(rectOf: GAMESCREEN_SIZE)
        bgNode.position = self.centerPoint
        bgNode.fillColor = UIColor(red: 0.95451, green: 0.90098, blue: 0.35686, alpha: 1)
        bgNode.zPosition = 1000
        addChild(bgNode)
        bgNode.run(.sequence([
            .scale(to: 0, duration: 0),
            .scale(to: 1, duration: 0.3),
            .wait(forDuration: 0.5)
        ])){ [weak self] in
            guard let self = self else { return }
            let bg2Node = SKShapeNode(rectOf: GAMESCREEN_SIZE)
            bg2Node.position = self.centerPoint
            bg2Node.fillColor = UIColor(red: 0.87451, green: 0.85098, blue: 0.15686, alpha: 1)
            bg2Node.zPosition = 1001
            self.addChild(bg2Node)
            bg2Node.run(.sequence([
                .fadeOut(withDuration: 0),
                .fadeIn(withDuration: 1),
            ])){
                self.changeScene(scene: GameSceneFactory())
            }
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        self.addChild(textNode)
        animateNextText()
        
        let backgroundSound = SKAudioNode(fileNamed: "menu.wav")
        self.addChild(backgroundSound)
        backgroundSound.run(.play())
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first else { return }
        guard isTouchEnable else { return }
        if textIndex < introTexts.count {
            animateNextText()
            return
        }
        moveToFactoryScene()
    }
}

struct GameSceneIntroScreen: View {
    var scene: SKScene {
        let scene = GameSceneIntro()
        scene.size = GAMESCREEN_SIZE
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .frame(minWidth: 0, maxWidth: .infinity)
            .aspectRatio(SPRITEVIEW_RATIO, contentMode: .fit)
    }
}

struct GameSceneIntroScreen_Previews: PreviewProvider {
    static var previews: some View {
        CustomPreviewView{
            GameSceneIntroScreen()
        }
    }
}
