import Foundation
import SpriteKit

let npcDefaultTexture = {
    let texture = SKTexture(imageNamed: "lc-yellow4")
    texture.filteringMode = .nearest
    return texture
}()

class NPC {
    var bodyNode: SKNode
    var spriteNode: SKSpriteNode
    var defaultSKTexture: SKTexture
    
    var defaultTexture: String
    var idleTextures: [String]
    var moveTextures: [String]
    var sadTextures: [String]
    var standTextures: [String]
    var poseTextures: [String]
    
    init(
        position: CGPoint,
        name: String,
        defaultTexture: String,
        idleTextures: [String],
        moveTextures: [String],
        sadTextures: [String],
        standTextures: [String],
        poseTextures: [String]
    ) {
        let physicBody = SKPhysicsBody(rectangleOf: CGSize(width: 80, height: 40))
        physicBody.allowsRotation = false
        physicBody.categoryBitMask = CONTACT_NPC
        physicBody.contactTestBitMask = CONTACT_PLAYER
        physicBody.isDynamic = false
        
        let texture = SKTexture(imageNamed: defaultTexture)
        texture.filteringMode = .nearest
        defaultSKTexture = texture
        
        let spriteNode = SKSpriteNode(texture: defaultSKTexture, size: CGSize(width: 160, height: 160))
        spriteNode.position.y = 50
        
        let bodyNode = SKNode()
        bodyNode.position = position
        bodyNode.zPosition = 3
        bodyNode.physicsBody = physicBody
        bodyNode.addChild(spriteNode)
        bodyNode.name = name
        
        self.bodyNode = bodyNode
        self.spriteNode = spriteNode
        
        self.defaultTexture = defaultTexture
        self.idleTextures = idleTextures
        self.moveTextures = moveTextures
        self.sadTextures = sadTextures
        self.standTextures = standTextures
        self.poseTextures = poseTextures
        
        self.animateIdle()
    }
    
    // MARK: animation
    func animateIdle(){
        let textures: [SKTexture] = idleTextures.map{ el in
            let texture = SKTexture(imageNamed: el)
            texture.filteringMode = .nearest
            return texture
        }
        let playerIdleAction: SKAction = .animate(with: textures, timePerFrame: 0.3)
        spriteNode.removeAllActions()
        spriteNode.run(.repeatForever(playerIdleAction), withKey: "idle")
    }
    func animateMoving() {
        // if player already moving ignore code
        guard spriteNode.action(forKey: "moving") == nil else { return }
        
        let textures: [SKTexture] = moveTextures.map{ el in
            let texture = SKTexture(imageNamed: el)
            texture.filteringMode = .nearest
            return texture
        }
       
        let playerMoveAction: SKAction = .animate(with: textures, timePerFrame: 0.1)
        spriteNode.removeAllActions()
        spriteNode.run(.repeatForever(playerMoveAction), withKey: "moving")
    }
    func animateSad() {
        guard spriteNode.action(forKey: "sad") == nil else { return }
        
        let textures: [SKTexture] = sadTextures.map{ el in
            let texture = SKTexture(imageNamed: el)
            texture.filteringMode = .nearest
            return texture
        }
       
        let playerMoveAction: SKAction = .animate(with: textures, timePerFrame: 0.1)
        spriteNode.removeAllActions()
        spriteNode.run(.repeatForever(playerMoveAction), withKey: "sad")
    }
    func animateStand() {        
        let textures: [SKTexture] = sadTextures.map{ el in
            let texture = SKTexture(imageNamed: el)
            texture.filteringMode = .nearest
            return texture
        }
       
        let playerMoveAction: SKAction = .animate(with: textures, timePerFrame: 0.4)
        spriteNode.removeAllActions()
        spriteNode.run(.sequence([
            .repeat(playerMoveAction, count: 1),
            .wait(forDuration: 0.5),
            .run { [weak self] in
                self?.stopAnimate()
                self?.animateIdle()
            }
        ]), withKey: "sad")
    }
    func animatePose(){
        guard spriteNode.action(forKey: "pose") == nil else { return }

        let textures: [SKTexture] = poseTextures.map{ el in
            let texture = SKTexture(imageNamed: el)
            texture.filteringMode = .nearest
            return texture
        }
        let playerMoveAction: SKAction = .animate(with: textures, timePerFrame: 0.3)
        spriteNode.removeAllActions()
        spriteNode.run(.sequence([
            .repeat(playerMoveAction, count: 3),
            .run { [weak self] in
                self?.stopAnimate()
                self?.animateIdle()
            }
        ]), withKey: "pose")
    }
    func faceLeft(){
        spriteNode.xScale = -1
    }
    func faceRight(){
        spriteNode.xScale = 1
    }
    func faceToPoint(point: CGPoint){
        if bodyNode.position.x > point.x { // right of object
            faceLeft()
        } else {
            faceRight()
        }
    }
    func stopAnimate(){
        spriteNode.removeAllActions()
        spriteNode.texture = defaultSKTexture
    }
    func updateZIndex(){
        bodyNode.zPosition = 1000 - bodyNode.position.y
    }
    
    // MARK: Physic
    func clearPhysic(){
        bodyNode.physicsBody = nil
    }
    func stopMove(){
        bodyNode.physicsBody?.velocity = .zero
    }
    func stopMoveAndIdle(){
        stopMove()
        animateIdle()
    }
    func moveTo(location: CGPoint){
        let diffX = location.x - bodyNode.position.x
        let diffY = location.y - bodyNode.position.y
        let totalDiff = abs(diffX) + abs(diffY)
        if diffX >= 0 {
            faceRight()
        } else {
            faceLeft()
        }
        bodyNode.physicsBody?.velocity = CGVector(dx: PLAYER_SPEED * diffX/totalDiff, dy: PLAYER_SPEED * diffY/totalDiff)
    }
    func checkIsDestinationReached(destination: CGPoint) -> Bool {
        let diffX = destination.x - bodyNode.position.x
        let diffY = destination.y - bodyNode.position.y
        let isPlayerReachDestination = abs(diffX) < 5 && abs(diffY) < 5
        
        return isPlayerReachDestination
    }
    func checkIsIntersect(with otherNode: SKNode) -> Bool{
        return bodyNode.frame.intersects(otherNode.frame)
    }
    func getXCameraBasedOnPlayerPosition() -> CGFloat {
        return bodyNode.position.x + GAMESCREEN_SIZE.width / 4
    }
}

extension NPC {
    static func createRedNPC(location: CGPoint, name: String = "") -> NPC{
        return NPC(
            position: location,
            name: name,
            defaultTexture: redDefaultTexture,
            idleTextures: redIdleTextures,
            moveTextures: redMoveTextures,
            sadTextures: redSadTextures,
            standTextures: redStandTextures,
            poseTextures: redPoseTextures)
    }
    static func createBlueNPC(location: CGPoint, name: String = "") -> NPC{
        return NPC(
            position: location,
            name: name,
            defaultTexture: blueDefaultTexture,
            idleTextures: blueIdleTextures,
            moveTextures: blueMoveTextures,
            sadTextures: blueSadTextures,
            standTextures: blueStandTextures,
            poseTextures: bluePoseTextures)
    }
    static func createBlueMaskNPC(location: CGPoint, name: String = "") -> NPC{
        return NPC(
            position: location,
            name: name,
            defaultTexture: blueMaskDefaultTexture,
            idleTextures: blueMaskIdleTextures,
            moveTextures: blueMaskMoveTextures,
            sadTextures: blueMaskSadTextures,
            standTextures: blueMaskStandTextures,
            poseTextures: blueMaskPoseTextures)
    }
    static func createGreenNPC(location: CGPoint, name: String = "") -> NPC{
        return NPC(
            position: location,
            name: name,
            defaultTexture: greenDefaultTexture,
            idleTextures: greenIdleTextures,
            moveTextures: greenMoveTextures,
            sadTextures: greenSadTextures,
            standTextures: greenStandTextures,
            poseTextures: greenPoseTextures)
    }
    static func createPinkNPC(location: CGPoint, name: String = "") -> NPC{
        return NPC(
            position: location,
            name: name,
            defaultTexture: pinkDefaultTexture,
            idleTextures: pinkIdleTextures,
            moveTextures: pinkMoveTextures,
            sadTextures: pinkSadTextures,
            standTextures: pinkStandTextures,
            poseTextures: pinkPoseTextures)
    }
}
