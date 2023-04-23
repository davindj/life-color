import SpriteKit
import SwiftUI

class GameSceneCivilWar: SKScene {
    var cameraNode: SKCameraNode!
    var isTouchEventStarted: Bool = false
    var isDisableTouch: Bool = false
    var numOfTouch = 0
    
    let player = {
        let playerPosition = CGPoint(x: 500, y: 200)
        let player = Player(position: playerPosition)
        return player
    }()
    
    let listNpcBlue: [NPC] = {
        return [
            CGPoint(x: 200, y: 320),
            CGPoint(x: 300, y: 250),
            CGPoint(x: 180, y: 150),
            CGPoint(x: 120, y: 280),
            CGPoint(x: 250, y: 200),
        ].map{ npcPos in
            let npcPosition = npcPos
            let npc = NPC.createBlueNPC(location: npcPosition)
            npc.animateMoving()
            npc.faceRight()
            return npc
        }
    }()
    
    let listNpcRed: [NPC] = {
        return [
            CGPoint(x: 800, y: 300),
            CGPoint(x: 750, y: 280),
            CGPoint(x: 680, y: 235),
            CGPoint(x: 740, y: 210),
            CGPoint(x: 810, y: 150)
        ].map{ npcPos in
            let npcPosition = npcPos
            let npc = NPC.createRedNPC(location: npcPosition)
            npc.animateMoving()
            npc.faceLeft()
            return npc
        }
    }()
    
    let npc1 = {
        let npcPosition = CGPoint(x: 400, y: 250)
        let npc = NPC.createPinkNPC(location: npcPosition)
        npc.bodyNode.alpha = 0
        npc.faceLeft()
        return npc
    }()
    
    let npc2 = {
        let npcPosition = CGPoint(x: 600, y: 250)
        let npc = NPC.createGreenNPC(location: npcPosition)
        npc.bodyNode.alpha = 0
        npc.faceRight()
        return npc
    }()
    
    let npc3 = {
        let npcPosition = CGPoint(x: 400, y: 150)
        let npc = NPC.createBlueNPC(location: npcPosition)
        npc.bodyNode.alpha = 0
        npc.faceLeft()
        return npc
    }()
    
    let npc4 = {
        let npcPosition = CGPoint(x: 600, y: 150)
        let npc = NPC.createRedNPC(location: npcPosition)
        npc.bodyNode.alpha = 0
        npc.faceRight()
        return npc
    }()
    
    let wall: SKSpriteNode = {
        let texture = SKTexture(imageNamed: "war")
        texture.filteringMode = .nearest
        let wall = SKSpriteNode(texture: texture, size: CGSize(width: 1000, height: 400))
        wall.anchorPoint = CGPoint(x: 0, y: 1.0)
        wall.position = CGPoint(x: 0, y: 750)
        wall.zPosition = 1
        return wall
    }()
    
    let ground: SKSpriteNode = {
        let groundSize = CGSize(width: 1000, height: 250)
        let texture = SKTexture(imageNamed: "grass")
        texture.filteringMode = .nearest
        let ground = SKSpriteNode(texture: texture, size: groundSize)
        ground.physicsBody = SKPhysicsBody(edgeLoopFrom: ground.frame)
        ground.position = CGPoint(x: groundSize.width/2, y: 350 - groundSize.height / 2)
        ground.zPosition = 1
        return ground
    }()
    
    let underground: SKSpriteNode = {
        let texture = SKTexture(imageNamed: "dirt")
        texture.filteringMode = .nearest
        let underground = SKSpriteNode(texture: texture, size: CGSize(width: 1000, height: 100))
        underground.anchorPoint = CGPoint(x: 0, y: 1.0)
        underground.position = CGPoint(x: 0, y: 100)
        underground.zPosition = 1
        return underground
    }()
    
    func setupPhysicWorld(){
        physicsWorld.gravity = .zero
    }
    
    func setupCamera(){
        cameraNode = SKCameraNode()
        cameraNode.position = self.centerPoint
        self.addChild(cameraNode)
        self.camera = cameraNode
    }
    
    func setupScene(){
        self.addChild(wall)
        self.addChild(ground)
        self.addChild(underground)
        self.addChild(player.bodyNode)
    }
    
    func setupNpc(){
        for npcBlue in listNpcBlue {
            self.addChild(npcBlue.bodyNode)
        }
        for npcRed in listNpcRed {
            self.addChild(npcRed.bodyNode)
        }
        for npc in [npc1, npc2, npc3, npc4] {
            self.addChild(npc.bodyNode)
        }
    }
    
    func startIntroScene() {
        let bgNode = SKShapeNode(rectOf: GAMESCREEN_SIZE)
        bgNode.position = self.centerPoint
        bgNode.fillColor = UIColor.white
        bgNode.zPosition = 1000
        bgNode.alpha = 1
        addChild(bgNode)
        bgNode.run(.sequence([
            .fadeOut(withDuration: 1),
        ])){ [weak self] in
            guard let self = self else { return }
            showText(text: civilWarText1)
            self.isTouchEventStarted = true
            self.player.animateIdle()
        }
    }
    
    func endScene(){
        isTouchEventStarted = false
        hideText()
        player.animateTPose()
        player.bodyNode.run(.wait(forDuration: 3)){ [weak self] in
            guard let self = self else { return }
            self.listNpcBlue.forEach{ $0.stopAnimate() }
            self.listNpcRed.forEach{ $0.stopAnimate() }
            showText(text: civilWarText2)
            player.bodyNode.run(.wait(forDuration: 4)){
                let bgNode = SKShapeNode(rectOf: GAMESCREEN_SIZE)
                bgNode.position = self.centerPoint
                bgNode.fillColor = UIColor.white
                bgNode.zPosition = 1000
                bgNode.alpha = 0
                self.addChild(bgNode)
                bgNode.run(.sequence([
                    .fadeIn(withDuration: 3),
                ])){ 
                    self.changeScene(scene: GameSceneEnding())
                }
            }
        }
    }
    
    override func didMove(to view: SKView) {
        setupPhysicWorld()
        setupScene()
        setupNpc()
        setupCamera()
        startIntroScene()
        
        let backgroundSound = SKAudioNode(fileNamed: "goblin_den.wav")
        self.addChild(backgroundSound)
        backgroundSound.run(.play())
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isTouchEventStarted else { return }
        guard let _ = touches.first else { return }
        numOfTouch += 1
        if numOfTouch == 1 {
            npc1.bodyNode.run(.fadeIn(withDuration: 0.3)){ [weak self] in
                self?.npc1.animateIdle()
            }
        }
        if numOfTouch == 2 {
            npc2.bodyNode.run(.fadeIn(withDuration: 0.3)){ [weak self] in
                self?.npc2.animateIdle()
            }
        }
        if numOfTouch == 3 {
            npc3.bodyNode.run(.fadeIn(withDuration: 0.3)){ [weak self] in
                self?.npc3.animateIdle()
            }
        }
        if numOfTouch == 4 {
            npc4.bodyNode.run(.fadeIn(withDuration: 0.3)){ [weak self] in
                self?.npc4.animateIdle()
            }
            endScene()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.updateZIndex()
        [npc1, npc2, npc3, npc4].forEach{ el in
            el.updateZIndex()
        }
        listNpcBlue.forEach{ el in
            el.updateZIndex()
        }
        listNpcRed.forEach{ el in
            el.updateZIndex()
        }
    }
    
    let textNode = {
        let textNode = SKLabelNode(fontNamed: PRIMARY_FONT)
        textNode.text = ""
        textNode.fontSize = 36
        textNode.fontColor = .white
        textNode.position = CGPoint(
            x: GAMESCREEN_SIZE.width/2,
            y: GAMESCREEN_SIZE.height/2 + 160
        )
        textNode.zPosition = 2
        textNode.numberOfLines = -1
        return textNode
    }()
    func showText(text: String){
        if textNode.parent == nil {
            self.addChild(textNode)
        }
        textNode.removeAllActions()
        textNode.run(.sequence([
            .fadeOut(withDuration: 0),
            .run{ [weak self] in
                guard let self = self else { return }
                self.textNode.text = text
            },
            .fadeIn(withDuration: 2)
        ]))
    }
    func hideText(){
        textNode.alpha = 0
    }
}

struct GameSceneCivilWarScreen: View {
    var scene: SKScene {
        let scene = GameSceneCivilWar()
        scene.size = GAMESCREEN_SIZE
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .frame(minWidth: 0, maxWidth: .infinity)
            .aspectRatio(SPRITEVIEW_RATIO, contentMode: .fit)
    }
}

struct GameSceneCivilWarScreen_Previews: PreviewProvider {
    static var previews: some View {
        CustomPreviewView{
            GameSceneCivilWarScreen()
        }
    }
}
