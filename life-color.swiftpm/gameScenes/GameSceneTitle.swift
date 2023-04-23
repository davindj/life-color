import SpriteKit
import SwiftUI

class GameSceneTitle: SKScene {
    var cameraNode: SKCameraNode!
    var hsvDegree: CGFloat = 0.0
    var isTouchEnable = false

    let titleNode = {
        let node = SKSpriteNode(imageNamed: "life-color-title")
        node.setScale(0.8)
        node.position = CGPoint(
            x: GAMESCREEN_SIZE.width/2,
            y: GAMESCREEN_SIZE.height/2 + GAMESCREEN_SIZE.height/8
        )
        return node
    }()
    
    let clickAnywhereText = {
        let textNode = SKLabelNode(fontNamed: PRIMARY_FONT)
        textNode.text = "click anywhere to start"
        textNode.fontSize = 48
        textNode.fontColor = SKColor.green
        textNode.position = CGPoint(
            x: GAMESCREEN_SIZE.width/2,
            y: GAMESCREEN_SIZE.height/2 - GAMESCREEN_SIZE.height/4
        )
        textNode.zPosition = 3
        return textNode
    }()
    
    let clickAnywhereShadowText = {
        let textNode = SKLabelNode(fontNamed: PRIMARY_FONT)
        textNode.text = "click anywhere to start"
        textNode.fontSize = 48
        textNode.fontColor = SKColor.green
        textNode.position = CGPoint(
            x: GAMESCREEN_SIZE.width/2 + 2,
            y: GAMESCREEN_SIZE.height/2 - GAMESCREEN_SIZE.height/4 - 2
        )
        textNode.zPosition = 2
        return textNode
    }()
    
    func moveToIntroScene(){
        let bgNode = SKShapeNode(rectOf: GAMESCREEN_SIZE)
        bgNode.position = self.centerPoint
        bgNode.fillColor = UIColor.white
        bgNode.zPosition = 1000
        addChild(bgNode)
        bgNode.run(.sequence([
            .fadeOut(withDuration: 0),
            .fadeIn(withDuration: 1),
        ])){ [weak self] in
            self?.changeScene(scene: GameSceneIntro())
        }
    }
    
    func playBGM(){
        let backgroundSound = SKAudioNode(fileNamed: "plain_sight.wav")
        self.addChild(backgroundSound)
        backgroundSound.run(.play())
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        addChild(titleNode)

        // Camera
        cameraNode = SKCameraNode()
        cameraNode.position = self.centerPoint.add(point: CGPoint(x: 0, y: GAMESCREEN_SIZE.height))
        self.addChild(cameraNode)
        self.camera = cameraNode
        // Animation Stuff
        cameraNode.run(.sequence([
            .moveTo(y: GAMESCREEN_SIZE.height/2, duration: 4)
        ])){ [weak self] in
            guard let self = self else { return }
            self.addChild(clickAnywhereText)
            self.addChild(clickAnywhereShadowText)
            isTouchEnable = true
        }
        
        
        let developertextNode = SKLabelNode(fontNamed: PRIMARY_FONT)
        developertextNode.text = "made by Davin Djayadi"
        developertextNode.fontSize = 24
        developertextNode.fontColor = .gray
        developertextNode.position = CGPoint(
            x: GAMESCREEN_SIZE.width/2,
            y: 40
        )
        developertextNode.zPosition = 2
        self.addChild(developertextNode)
        
        playBGM()
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isTouchEnable else { return }
        guard let _ = touches.first else { return }
        isTouchEnable = false
        moveToIntroScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        hsvDegree += 0.0025
        if hsvDegree >= 1 {
            hsvDegree = 0
        }
        clickAnywhereText.fontColor = UIColor(hue: hsvDegree, saturation: 0.5, brightness: 1, alpha: 1.0)
        clickAnywhereShadowText.fontColor = UIColor(hue: hsvDegree, saturation: 0.5, brightness: 0.5, alpha: 1.0)
    }
}

struct GameSceneTitleScreen: View {
    var scene: SKScene {
        let scene = GameSceneTitle()
        scene.size = GAMESCREEN_SIZE
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .frame(minWidth: 0, maxWidth: .infinity)
            .aspectRatio(SPRITEVIEW_RATIO, contentMode: .fit)
    }
}

struct GameSceneTitleScreen_Previews: PreviewProvider {
    static var previews: some View {
        CustomPreviewView{
            GameSceneTitleScreen()
        }
    }
}
