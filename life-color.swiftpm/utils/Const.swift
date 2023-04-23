import Foundation

let PRIMARY_FONT = "Upheaval TT (BRK)"
let GAMESCREEN_SIZE: CGSize = CGSize(width: 1000, height: 750)
let SPRITEVIEW_RATIO: CGFloat = 4/3
let PLAYER_SPEED: CGFloat = 200
let CONTACT_PLAYER: UInt32 = 0x1 << 0
let CONTACT_NPC: UInt32    = 0x1 << 1

let redDefaultTexture = "lc-red04"
let redIdleTextures  = ["lc-red04", "lc-red05"]
let redMoveTextures  = ["lc-red00", "lc-red01", "lc-red02", "lc-red03"]
let redSadTextures   = ["lc-red09", "lc-red10"]
let redStandTextures = ["lc-red11", "lc-red12", "lc-red13", "lc-red14"]
let redPoseTextures  = ["lc-red06", "lc-red07", "lc-red08"]

let blueDefaultTexture = "lc-blue04"
let blueIdleTextures  = ["lc-blue04", "lc-blue05"]
let blueMoveTextures  = ["lc-blue00", "lc-blue01", "lc-blue02", "lc-blue03"]
let blueSadTextures   = ["lc-blue09", "lc-blue10"]
let blueStandTextures = ["lc-blue11", "lc-blue12", "lc-blue13", "lc-blue14"]
let bluePoseTextures  = ["lc-blue06", "lc-blue07", "lc-blue08"]

let blueMaskDefaultTexture = "lc-blue-mask4"
let blueMaskIdleTextures  = ["lc-blue-mask4", "lc-blue-mask5"]
let blueMaskMoveTextures  = ["lc-blue-mask0", "lc-blue-mask1", "lc-blue-mask2", "lc-blue-mask3"]
let blueMaskSadTextures   = [String]()
let blueMaskStandTextures = [String]()
let blueMaskPoseTextures  = [String]()

let greenDefaultTexture = "lc-green4"
let greenIdleTextures  = ["lc-green4", "lc-green5"]
let greenMoveTextures  = ["lc-green0", "lc-green1", "lc-green2", "lc-green3"]
let greenSadTextures   = [String]()
let greenStandTextures = [String]()
let greenPoseTextures  = ["lc-green6", "lc-green7", "lc-green8"]

let pinkDefaultTexture = "lc-pink4"
let pinkIdleTextures  = ["lc-pink4", "lc-pink5"]
let pinkMoveTextures  = ["lc-pink0", "lc-pink1", "lc-pink2", "lc-pink3"]
let pinkSadTextures   = [String]()
let pinkStandTextures = [String]()
let pinkPoseTextures  = ["lc-pink0", "lc-pink1", "lc-pink2", "lc-pink3"]
