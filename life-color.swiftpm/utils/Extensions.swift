import SpriteKit

extension SKScene {
    var centerX: CGFloat {
        self.size.width / 2
    }
    var centerY: CGFloat {
        self.size.height / 2
    }
    var centerPoint: CGPoint {
        CGPoint(x: centerX, y: centerY)
    }
    func changeScene(scene: SKScene){
        let nextScene = scene
        nextScene.size = GAMESCREEN_SIZE
        self.scene?.view?.presentScene(nextScene)
    }
}

extension CGPoint {
    func add(point: CGPoint) -> CGPoint {
        return CGPoint(x: self.x + point.x, y: self.y + point.y)
    }
}
