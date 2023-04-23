import SpriteKit
import SwiftUI



class GameSceneIdealColorPeople: SKScene {
    var cameraNode: SKCameraNode!
    var targetNode: SKNode?
    var isSceneStarting: Bool = true
    var isEvent1Triggerred: Bool = false
    var isEvent2Triggerred: Bool = false
    var isEvent3Triggerred: Bool = false
    var isDisableUpdateAction: Bool = false
    var isDisableTouch: Bool = false
    var isGameEnding: Bool = false
    
    let player = {
        let playerPosition = CGPoint(x: 50, y: 200).add(point: CGPoint(x: 1000, y: 0))
        let player = Player(position: playerPosition)
        return player
    }()
    
    let npc1 = {
        let npcPosition = CGPoint(x: 400, y: 300).add(point: CGPoint(x: 1000, y: 0))
        let npc = NPC.createPinkNPC(location: npcPosition, name: "npc-1")
        return npc
    }()
    
    let npc2 = {
        let npcPosition = CGPoint(x: 800, y: 150).add(point: CGPoint(x: 1000, y: 0))
        let npc = NPC.createGreenNPC(location: npcPosition, name: "npc-2")
        return npc
    }()
    
    let npcBlue = {
        let npcPosition = CGPoint(
            x: GAMESCREEN_SIZE.width * 2 - 100,
            y: 290
        ).add(point: CGPoint(x: 1000, y: 0))
        let npc = NPC.createBlueNPC(location: npcPosition)
        npc.animateSad()
        return npc
    }()
    
    let npcRed1 = {
        let npcPosition = CGPoint(
            x: GAMESCREEN_SIZE.width * 2 + 80,
            y: 300
        ).add(point: CGPoint(x: 1000, y: 0))
        let npc = NPC.createRedNPC(location: npcPosition)
        npc.faceLeft()
        npc.animateMoving()
        return npc
    }()
    
    let npcRed2 = {
        let npcPosition = CGPoint(
            x: GAMESCREEN_SIZE.width * 2 + 180,
            y: 280
        ).add(point: CGPoint(x: 1000, y: 0))
        let npc = NPC.createRedNPC(location: npcPosition)
        npc.faceLeft()
        return npc
    }()
    
    let npcBlueMask = {
        let npcPosition = CGPoint(
            x: GAMESCREEN_SIZE.width * 3,
            y: 280
        ).add(point: CGPoint(x: 1000, y: 0))
        let npc = NPC.createBlueMaskNPC(location: npcPosition)
        return npc
    }()
    
    let event1TriggerNode: SKSpriteNode = {
        let nodeSize = CGSize(width: 50, height: 250)
        let node = SKSpriteNode(color: .yellow, size: nodeSize)
        node.position = CGPoint(
            x: GAMESCREEN_SIZE.width - nodeSize.width/2,
            y: 350 - nodeSize.height / 2
        ).add(point: CGPoint(x: 1000, y: 0))
        node.zPosition = 3
        node.isHidden = true
        return node
    }()
    
    let event2TriggerNode: SKSpriteNode = {
        let nodeSize = CGSize(width: 50, height: 250)
        let node = SKSpriteNode(color: .orange, size: nodeSize)
        node.position = CGPoint(
            x: GAMESCREEN_SIZE.width + GAMESCREEN_SIZE.width/4 + 40,
            y: 350 - nodeSize.height / 2
        ).add(point: CGPoint(x: 1000, y: 0))
        node.zPosition = 3
        node.isHidden = true
        return node
    }()
    
    let event3TriggerNode: SKSpriteNode = {
        let nodeSize = CGSize(width: 50, height: 250)
        let node = SKSpriteNode(color: .black, size: nodeSize)
        node.position = CGPoint(
            x: GAMESCREEN_SIZE.width + GAMESCREEN_SIZE.width * 3/4.0,
            y: 350 - nodeSize.height / 2
        ).add(point: CGPoint(x: 1000, y: 0))
        node.zPosition = 3
        node.isHidden = true
        return node
    }()
    
    let wall: SKSpriteNode = {
        let texture = SKTexture(imageNamed: "ideal-wall")
        texture.filteringMode = .nearest
        let wall = SKSpriteNode(texture: texture, size: CGSize(width: 3000, height: 400))
        wall.anchorPoint = CGPoint(x: 0, y: 1.0)
        wall.position = CGPoint(x: 0, y: 750).add(point: CGPoint(x: 1000, y: 0))
        wall.zPosition = 1
        return wall
    }()
    
    let ground: SKSpriteNode = {
        let groundSize = CGSize(width: 3000, height: 250)
        let texture = SKTexture(imageNamed: "ideal-ground")
        texture.filteringMode = .nearest
        let ground = SKSpriteNode(texture: texture, size: groundSize)
        ground.physicsBody = SKPhysicsBody(edgeLoopFrom: ground.frame)
        ground.position = CGPoint(x: groundSize.width/2, y: 350 - groundSize.height / 2).add(point: CGPoint(x: 1000, y: 0))
        ground.zPosition = 1
        return ground
    }()
    
    let underground: SKSpriteNode = {
        let texture = SKTexture(imageNamed: "ideal-underground")
        texture.filteringMode = .nearest
        let underground = SKSpriteNode(texture: texture, size: CGSize(width: 3000, height: 100))
        underground.anchorPoint = CGPoint(x: 0, y: 1.0)
        underground.position = CGPoint(x: 0, y: 100).add(point: CGPoint(x: 1000, y: 0))
        underground.zPosition = 1
        return underground
    }()
    
    func setupPhysicWorld(){
        physicsWorld.contactDelegate = self
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
        self.addChild(event1TriggerNode)
        self.addChild(event2TriggerNode)
        self.addChild(event3TriggerNode)
        self.addChild(player.bodyNode)
        generateOuterWall1()
    }
    
    func setupNpc(){
        self.addChild(npc1.bodyNode)
        self.addChild(npc2.bodyNode)
        self.addChild(npcBlue.bodyNode)
        self.addChild(npcRed1.bodyNode)
        self.addChild(npcRed2.bodyNode)
    }
    
    func generateOuterWall1(){
        let outerWallSize = CGSize(width: 1000, height: 1000)
        let texture = SKTexture(imageNamed: "brick-1")
        texture.filteringMode = .nearest
        var lastX: CGFloat = 0
        while lastX < size.width {
            var lastY: CGFloat = 750
            while lastY > 0 {
                let outerWall = SKSpriteNode(texture: texture, size: outerWallSize)
                outerWall.anchorPoint = CGPoint(x: 0, y: 1)
                outerWall.position = CGPoint(x: lastX, y: lastY)
                outerWall.zPosition = 10
                self.addChild(outerWall)
                lastY -= outerWallSize.height
            }
            lastX += outerWallSize.width
        }
    }
    
    func startIntroScene() {
        let cameraMoveAction = SKAction.moveBy(x: size.width, y: 0, duration: 2)
        cameraNode.run(cameraMoveAction){ [weak self] in
            guard let self = self else { return }
            self.isSceneStarting = false
            self.player.animateIdle()
            self.showText(text: ideal1Texts[0])
        }
    }
    
    func removeTargetObject() {
        guard let targetNode = self.targetNode else { return }
        targetNode.removeFromParent()
        self.targetNode = nil
    }
    
    func createTargetObject(location: CGPoint) {
        let newTargetNode = SKShapeNode(circleOfRadius: 10) // Size of Circle
        newTargetNode.position = location
        newTargetNode.strokeColor = .black
        newTargetNode.glowWidth = 1.0
        newTargetNode.fillColor = .orange
        newTargetNode.zPosition = 2
        self.targetNode = newTargetNode
        self.addChild(newTargetNode)
    }
    
    func replaceTargetObject(location: CGPoint) {
        removeTargetObject()
        createTargetObject(location: location)
    }
    
    func checkPlayerTriggerEvent1() -> Bool {
        return !isEvent1Triggerred && player.checkIsIntersect(with: event1TriggerNode)
    }
    func checkPlayerTriggerEvent2() -> Bool {
        return !isEvent2Triggerred && player.checkIsIntersect(with: event2TriggerNode)
    }
    func checkPlayerTriggerEvent3() -> Bool {
        return !isEvent3Triggerred && player.checkIsIntersect(with: event3TriggerNode)
    }
    func startEvent1(){ // notify not ideal people
        isEvent1Triggerred = true
        print("Trigger Event 1")
        showText(text: ideal2Texts[0])
    }
    func startEvent2(){ // show not ideal people in action
        backgroundSound.run(.stop()){ [weak self] in
            guard let self = self else { return }
            self.backgroundSound.removeFromParent()
            let newBackgroundSound = SKAudioNode(fileNamed: "goblin_den.wav")
            self.addChild(newBackgroundSound)
            newBackgroundSound.run(.play())
            self.backgroundSound = newBackgroundSound
        }
        
        isEvent2Triggerred = true
        print("Trigger Event 2")
        isDisableTouch = true
        player.stopMoveAndIdle()
        removeTargetObject()
        showText(text: ideal3Texts[0])
        cameraNode.run(.sequence([
            // move camera to not ideal people
            .moveTo(x: event3TriggerNode.position.x + GAMESCREEN_SIZE.width / 4, duration: 2),
            // move camera to player
            .wait(forDuration: 3),
            .moveTo(x: player.bodyNode.position.x + size.width / 4, duration: 2),
        ])){ [weak self] in
            guard let self = self else { return }
            self.isDisableTouch = false
        }
    }
    func startEvent3(){ // protect victim and end scene
        isEvent3Triggerred = true
        print("Trigger Event 3")
        isDisableTouch = true
        isDisableUpdateAction = true
        player.stopMove()
        player.clearPhysic()
        removeTargetObject()
        hideText()
        player.animateMoving()
        player.faceRight()
        player.bodyNode.run(.sequence([
            .move(to: npcBlue.bodyNode.position, duration: 0.6),
            .moveBy(x: 80, y: 0, duration: 0.3)
        ])){ [weak self] in
            guard let self = self else { return }
            self.player.animateTPose()
            self.npcRed1.faceRight()
            self.npcRed2.faceRight()
            self.npcRed1.animateMoving()
            self.npcRed2.animateMoving()
            self.npcRed1.bodyNode.run(.sequence([
                .wait(forDuration: 1.0),
                .moveBy(x: GAMESCREEN_SIZE.width / 2, y: 0, duration: 2)
            ]))
            self.npcRed2.bodyNode.run(.sequence([
                .wait(forDuration: 1.0),
                .moveBy(x: GAMESCREEN_SIZE.width / 2, y: 0, duration: 2)
            ])){
                self.player.faceLeft()
                self.player.animateIdle()
                self.npcBlue.animateStand()
                self.addChild(self.npcBlueMask.bodyNode)
                self.showText(text: ideal4Texts[0]) // congrat
                self.npcBlueMask.clearPhysic()
                self.npcBlueMask.faceLeft()
                self.npcBlueMask.animateMoving()
                self.npcBlueMask.bodyNode.run(
                    .group([
                        .sequence([
                            .wait(forDuration: 2),
                            .run{
                                self.showText(text: ideal5Texts[0]) // hide color
                            }
                        ]),
                        .moveTo(x: self.player.bodyNode.position.x + 80, duration: 7)
                    ])
                ){
                    self.showText(text: ideal6Texts[0]) // hide color
                    self.npcBlueMask.animateIdle()
                    self.player.faceRight()
                    self.player.stopAnimate()
                    self.cameraNode.run(
                        .sequence([
                            .wait(forDuration: 3),
                            .run{
                                self.hideText()
                            },
                            .group([
                                .move(to: self.npcBlueMask.bodyNode.position.add(point: CGPoint(x: -10, y: 105)), duration: 2),
                                .scale(to: 0.01, duration: 2)
                            ])
                        ])
                    ){
                        self.changeScene(scene: GameSceneCivilWar())
                    }
                }
            }
        }
    }
    
    var backgroundSound: SKAudioNode!
    
    override func didMove(to view: SKView) {
        setupPhysicWorld()
        setupScene()
        setupNpc()
        setupCamera()
        startIntroScene()
        
        let backgroundSound = SKAudioNode(fileNamed: "menu.wav")
        self.addChild(backgroundSound)
        backgroundSound.run(.play())
        self.backgroundSound = backgroundSound
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isDisableTouch else { return }
        guard !isSceneStarting else { return }
        guard !isGameEnding else { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: ground)
        let newLocation = ground.position.add(point: location)
        replaceTargetObject(location: newLocation)
        player.animateMoving()
    }
    
    override func update(_ currentTime: TimeInterval) {
        textNode.position.x = cameraNode.position.x
        
        guard !isDisableUpdateAction else { return }
        guard !isSceneStarting else { return }
        guard !isGameEnding else { return }
        
        if checkPlayerTriggerEvent1() {
            startEvent1()
            return
        }
        if checkPlayerTriggerEvent2() {
            startEvent2()
            return
        }
        if checkPlayerTriggerEvent3() {
            startEvent3()
            return
        }
        
        player.updateZIndex()
        [npc1, npc2].forEach{ el in
            el.faceToPoint(point: player.bodyNode.position)
            el.updateZIndex()
        }
        
        if let targetNode = self.targetNode { // if there's target Node
            if player.checkIsDestinationReached(destination: targetNode.position) { // Remove Target if player reach destination
                removeTargetObject()
                player.stopMoveAndIdle()
            } else { // Move to Target
                player.moveTo(location: targetNode.position)
            }
        }
        // Move Camera according to Player.. should be have a diff of 25% of screen
        // And make sure player cant go to left after moving forward
        let cameraXBasedOnPlayer = player.getXCameraBasedOnPlayerPosition()
        if cameraXBasedOnPlayer > cameraNode.position.x {
            cameraNode.position.x = cameraXBasedOnPlayer
        }
    }
    
    let textNode = {
        let textNode = SKLabelNode(fontNamed: PRIMARY_FONT)
        textNode.text = ""
        textNode.fontSize = 36
        textNode.fontColor = .black
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

extension GameSceneIdealColorPeople: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        let isCollidedWithNPC1 = nodeA.name == "npc-1" || nodeB.name == "npc-1"
        if isCollidedWithNPC1 {
            npc1.animatePose()
        }
        let isCollidedWithNPC2 = nodeA.name == "npc-2" || nodeB.name == "npc-2"
        if isCollidedWithNPC2 {
            npc2.animatePose()
        }
    }
}

struct GameSceneIdealColorPeopleScreen: View {
    var scene: SKScene {
        let scene = GameSceneIdealColorPeople()
        scene.size = GAMESCREEN_SIZE
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .frame(minWidth: 0, maxWidth: .infinity)
            .aspectRatio(SPRITEVIEW_RATIO, contentMode: .fit)
    }
}

struct GameSceneIdealColorPeopleScreen_Previews: PreviewProvider {
    static var previews: some View {
        CustomPreviewView{
            GameSceneIdealColorPeopleScreen()
        }
    }
}
