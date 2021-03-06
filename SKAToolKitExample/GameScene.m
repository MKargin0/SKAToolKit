//
//  GameScene.m
//  SKATMXParser
//
//  Created by Skyler Lauren on 5/3/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import "GameScene.h"
#import "SKATiledMap.h"
#import "SKATestPlayer.h"
#import "SKATestHud.h"
#import "SKAMiniMap.h"
#import "SKACroppedMiniMap.h"

@interface GameScene ()

@property (nonatomic, strong)SKATestPlayer *player;
@property (nonatomic, strong)SKATiledMap *map;
@property (nonatomic, strong)SKACroppedMiniMap *croppedMiniMap;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view
{
    self.map = [[SKATiledMap alloc]initWithMapName:@"SampleMap0"];
//    self.map.xScale = .3;
//    self.map.yScale = .3;
    [self addChild:self.map];
    
    NSInteger padding = 10;
    
    
    SKAMiniMap *miniMap = [[SKAMiniMap alloc]initWithMap:self.map withWidth:150];
     miniMap.position = CGPointMake(self.size.width-miniMap.size.width/2-padding, self.size.height-miniMap.size.height/2-padding);
    
    self.croppedMiniMap = [[SKACroppedMiniMap alloc]initWithMap:self.map withWidth:150 withCroppedSize:CGSizeMake(50, 50)];
    
    self.croppedMiniMap.position = CGPointMake(self.size.width-self.croppedMiniMap.size.width/2-padding, self.size.height-self.croppedMiniMap.size.height/2-padding);


    miniMap.position = CGPointMake(self.size.width-miniMap.size.width/2, self.size.height-miniMap.size.height/2);
    
    SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:.5];
    SKAction *fadeIn = [SKAction fadeAlphaTo:1 duration:.5];
    
    SKAction *repeat = [SKAction repeatActionForever:[SKAction sequence:@[fadeOut, fadeIn]]];
    
    SKASpriteLayer *layer =  self.map.spriteLayers[2];
    
    [layer runAction:repeat];
    
    SKAction *rotate = [SKAction rotateByAngle:2 duration:1];
    SKAction *repeatRotation = [SKAction repeatActionForever:rotate];
    
    SKASprite *sprite = [self.map spriteOnLayer:1 indexX:3 indexY:3];
    
    [sprite runAction:repeatRotation];
    
    self.player = [SKATestPlayer spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(40, 80)];
    self.player.zPosition = 20;
    self.player.position = CGPointMake(400, 400);
    [self.map addChild:self.player];
    
    self.map.autoFollowNode = self.player;
    self.croppedMiniMap.autoFollowNode = self.player;
    
    SKATestHud *testHud = [SKATestHud hudWithScene:self.scene withPlayer:self.player];
    
    [testHud addChild:miniMap];

//    [testHud addChild:self.croppedMiniMap];

    [self addChild:testHud];
}

-(void)update:(NSTimeInterval)currentTime
{
    [self.player update];
    
    CGPoint playerIndex = [self.map indexForPoint:self.player.position];
    [self.map cullAroundIndexX:playerIndex.x indexY:playerIndex.y columnWidth:14 rowHeight:7];
    
    [self.map update];
    [self.croppedMiniMap update];
}

@end
