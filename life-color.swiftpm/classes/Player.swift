import Foundation
import SpriteKit

let playerDefaultTexture = {
    let texture = SKTexture(imageNamed: "lc-yellow4")
    texture.filteringMode = .nearest
    return texture
}()

class Player {
    var bodyNode: SKNode
    var spriteNode: SKSpriteNode
    
    init(position: CGPoint = .zero) {
        let physicBody = SKPhysicsBody(rectangleOf: CGSize(width: 80, height: 40))
        physicBody.allowsRotation = false
        physicBody.categoryBitMask = CONTACT_PLAYER
        
        let spriteNode = SKSpriteNode(texture: playerDefaultTexture, size: CGSize(width: 160, height: 160))
        spriteNode.position.y = 50
        
        let bodyNode = SKNode()
        bodyNode.position = position
        bodyNode.zPosition = 3
        bodyNode.physicsBody = physicBody
        bodyNode.addChild(spriteNode)
        bodyNode.name = "player"
        
        self.bodyNode = bodyNode
        self.spriteNode = spriteNode
    }
    
    // MARK: animation
    func animateIdle(){
        let textures: [SKTexture] = [
            "lc-yellow4", "lc-yellow5",
        ].map{ el in
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
        
        let textures: [SKTexture] = [
            "lc-yellow0", "lc-yellow1", "lc-yellow2", "lc-yellow3"
        ].map{ el in
            let texture = SKTexture(imageNamed: el)
            texture.filteringMode = .nearest
            return texture
        }
       
        let playerMoveAction: SKAction = .animate(with: textures, timePerFrame: 0.1)
        spriteNode.removeAllActions()
        spriteNode.run(.repeatForever(playerMoveAction), withKey: "moving")
    }
    func animateTPose(){
        let textures: [SKTexture] = [
            "lc-yellow6", "lc-yellow7", "lc-yellow8"
        ].map{ el in
            let texture = SKTexture(imageNamed: el)
            texture.filteringMode = .nearest
            return texture
        }
        print(textures)
        let playerMoveAction: SKAction = .animate(with: textures, timePerFrame: 0.3)
        spriteNode.removeAllActions()
        spriteNode.run(.repeat(playerMoveAction, count: 1), withKey: "tpose")
    }
    func faceLeft(){
        spriteNode.xScale = -1
    }
    func faceRight(){
        spriteNode.xScale = 1
    }
    func stopAnimate(){
        spriteNode.removeAllActions()
        spriteNode.texture = playerDefaultTexture
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
