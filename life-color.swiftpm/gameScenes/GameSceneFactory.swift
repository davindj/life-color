import SpriteKit
import SwiftUI

class GameSceneFactory: SKScene {
    var cameraNode: SKCameraNode!
    var targetNode: SKNode?
    var isDisableTouch = true
    var isGameEnding: Bool = false
    
    let player = Player(position: CGPoint(x: 50, y: 200))
    
    let eventTriggerNode: SKSpriteNode = {
        let nodeSize = CGSize(width: 50, height: 250)
        let node = SKSpriteNode(color: .yellow, size: nodeSize)
        node.position = CGPoint(
            x: GAMESCREEN_SIZE.width - nodeSize.width/2, 
            y: 350 - nodeSize.height / 2
        )
        node.zPosition = 3
        node.isHidden = true
        return node
    }()
    
    let wall: SKSpriteNode = {
        let texture = SKTexture(imageNamed: "brick-underground")
        texture.filteringMode = .nearest
        let wall = SKSpriteNode(texture: texture, size: CGSize(width: 1000, height: 400))
        wall.anchorPoint = CGPoint(x: 0, y: 1.0)
        wall.position = CGPoint(x: 0, y: 750)
        wall.zPosition = 1
        return wall
    }()
    
    let ground: SKSpriteNode = {
        let groundSize = CGSize(width: 1000, height: 250)
        let texture = SKTexture(imageNamed: "brick-ground")
        texture.filteringMode = .nearest
        let ground = SKSpriteNode(texture: texture, size: groundSize)
        ground.physicsBody = SKPhysicsBody(edgeLoopFrom: ground.frame)
        ground.position = CGPoint(x: groundSize.width/2, y: 350 - groundSize.height / 2)
        ground.zPosition = 1
        return ground
    }()
    
    let underground: SKSpriteNode = {
        let texture = SKTexture(imageNamed: "brick-wall")
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
        self.addChild(eventTriggerNode)
        self.addChild(player.bodyNode)
        generateOuterWall()
        player.animateIdle()
    }
    
    func startScene(){
        isDisableTouch = true
        cameraNode.position = CGPoint(
            x: 50,
            y: GAMESCREEN_SIZE.height / 2 - GAMESCREEN_SIZE.height / 4 + 80
        )
        cameraNode.setScale(0.02)
        cameraNode.run(.sequence([
            .group([
                .move(to: self.centerPoint, duration: 3),
                .scale(to: 1, duration: 3)
            ])
        ])){ [weak self] in
            guard let self = self else { return }
            self.showText(text: factoryTexts[0])
            self.isDisableTouch = false
        }
    }
    
    func generateOuterWall(){
        let margin = CGPoint(x: size.width, y:0)
        let outerWallSize = CGSize(width: 1000, height: 1000)
        let texture = SKTexture(imageNamed: "brick-1")
        texture.filteringMode = .nearest
        var lastX: CGFloat = 0
        while lastX < size.width {
            var lastY: CGFloat = 750
            while lastY > 0 {
                let outerWall = SKSpriteNode(texture: texture, size: outerWallSize)
                outerWall.anchorPoint = CGPoint(x: 0, y: 1)
                outerWall.position = CGPoint(x: lastX, y: lastY).add(point: margin)
                outerWall.zPosition = 10
                self.addChild(outerWall)
                lastY -= outerWallSize.height
            }
            lastX += outerWallSize.width
        }
    }
    
    func removeTargetObject() {
        guard let targetNode = self.targetNode else { return }
        targetNode.removeFromParent()
        self.targetNode = nil
    }
    
    func createTargetObject(location: CGPoint) {
        let newTargetNode = SKShapeNode(circleOfRadius: 10 ) // Size of Circle
        newTargetNode.position = location
        newTargetNode.strokeColor = .black
        newTargetNode.glowWidth = 1.0
        newTargetNode.fillColor = .orange
        newTargetNode.zPosition = 2
        self.targetNode = newTargetNode
        self.addChild(newTargetNode)
    }
    
    func endScene() {
        isGameEnding = true
        removeTargetObject()
        player.clearPhysic()
        let moveAction = SKAction.move(by: CGVector(dx: 100, dy: 0), duration: 1)
        player.animateMoving()
        player.faceRight()
        player.bodyNode.run(moveAction){ [self] in
            let cameraMoveAction = SKAction.sequence([
                SKAction.move(by: CGVector(dx: size.width, dy: 0), duration: 2),
                SKAction.wait(forDuration: 0.5) // wait .5 sec before change scene
            ])
            cameraNode.run(cameraMoveAction){
                self.changeScene(scene: GameSceneIdealColorPeople())
            }
        }
    }
    
    let textNode = {
        let textNode = SKLabelNode(fontNamed: PRIMARY_FONT)
        textNode.text = ""
        textNode.fontSize = 36
        textNode.fontColor = .white
        textNode.position = CGPoint(
            x: GAMESCREEN_SIZE.width/2,
            y: GAMESCREEN_SIZE.height/2 + 40
        )
        textNode.zPosition = 2
        textNode.numberOfLines = -1
        return textNode
    }()
    func showText(text: String){
        self.addChild(textNode)
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
    
    override func didMove(to view: SKView) {
        setupPhysicWorld()
        setupScene()
        setupCamera()
        startScene()
        
        let backgroundSound = SKAudioNode(fileNamed: "menu.wav")
        self.addChild(backgroundSound)
        backgroundSound.run(.play())
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isDisableTouch else { return }
        guard let touch = touches.first, !isGameEnding else { return }
        let location = touch.location(in: ground)
        let newLocation = ground.position.add(point: location)
        removeTargetObject()
        createTargetObject(location: newLocation)
        player.animateMoving()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isGameEnding {
            return
        }
        if player.checkIsIntersect(with: eventTriggerNode) {
            endScene()
            return
        }
        if let targetNode = self.targetNode { // if there's target Node
            let destination = targetNode.position
            if player.checkIsDestinationReached(destination: destination) { // Remove Target if player reach destination
                removeTargetObject()
                player.stopMove()
                player.animateIdle()
            } else { // Move to Target
                player.moveTo(location: destination)
            }
        }
    }
    
    
}

struct GameSceneFactoryScreen: View {
    var scene: SKScene {
        let scene = GameSceneFactory()
        scene.size = GAMESCREEN_SIZE
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .frame(minWidth: 0, maxWidth: .infinity)
            .aspectRatio(SPRITEVIEW_RATIO, contentMode: .fit)
    }
}

struct GameSceneFactoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        CustomPreviewView{
            GameSceneFactoryScreen()
        }
    }
}
