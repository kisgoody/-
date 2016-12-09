//
//  棋盘.swift
//  五子棋
//
//  Created by EDF on 16/12/7.
//  Copyright © 2016年 EDF. All rights reserved.
//

import UIKit

protocol CheckerListener{

    func pieceDown()
    func pieceMoveStart()
    func pieceMoveEnd()
    func gameOver(wine: Int)
    
}

class 棋盘: UIView{
    
    var w: CGFloat = 0
    var pw: CGFloat = 0;
    var pieces : Dictionary<Int,UIImageView>?
    var listener: CheckerListener?
    var context: CGContext?
    var box: CGRect?
    
    func setOnCheckerListener(listener: CheckerListener){
        self.listener = listener
    }
    
    func reStart(){
        for piece in self.subviews{
            piece.removeFromSuperview()
        }
        pieces?.removeAll()
    }
    override func drawRect(rect: CGRect) {
       startWork()
        
        
    }
    func startWork(){
        pieces = Dictionary<Int,UIImageView>()
        
        context = UIGraphicsGetCurrentContext()
        box = CGContextGetClipBoundingBox(context)
        w = box!.size.width > box!.size.height ? box!.size.height : box!.size.width
        
        
        let background = UIImage(named:"board_back")
        
        CGContextDrawImage(context, box!, background!.CGImage)
        
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1)
        CGContextSetLineWidth(context, 0.4)
        CGContextBeginPath(context)
        let space = w/20.0
        pw = space
        
        for(var i = 0;i <= 18;i++){
            
            CGContextMoveToPoint(context, CGFloat(i+1)*space, space)
            CGContextAddLineToPoint(context, CGFloat(i+1)*space, w-space)
            CGContextStrokePath(context)
            
        }
        for(var i = 0;i <= 18;i++){
            
            CGContextMoveToPoint(context, space, CGFloat(i+1)*space)
            CGContextAddLineToPoint(context, w-space, CGFloat(i+1)*space)
            CGContextStrokePath(context)
            
        }
        for (var i=0;i<=2;i++)
        {
            for(var j=0;j<=2;j++)
            {
                CGContextBeginPath(context);
                
                CGContextAddArc(context, (CGFloat(1+3+6*i))*space ,CGFloat(1+3+6*j)*space, 2, 0, CGFloat(2.0*M_PI), 1);
                
                CGContextStrokePath(context);
            }
        }

    }
    
    var courrentView: UIImageView?
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = touches.first?.locationInView(self)
        if point!.x < w-pw && point!.y < w-pw && point?.x >= pw && point?.y >= pw{
            courrentView = createPiece(point!.x,point!.y)
            listener?.pieceDown()
        }
    }
    var isFrist: Bool = true
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = touches.first?.locationInView(self)
        if point!.x <= w-pw && point!.y <= w-pw && point?.x >= pw && point?.y >= pw{
            courrentView?.center = (touches.first?.locationInView(self))!
            if isFrist{
                listener?.pieceMoveStart()
                isFrist = false
            }

        }else{
        listener?.pieceMoveEnd()
            isFrist = true
        }
        
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if courrentView?.center.x <= w-pw && courrentView?.center.y <= w-pw && courrentView?.center.x >= pw && courrentView?.center.y >= pw{
            
            listener?.pieceMoveEnd()
            isFrist = true
            
            let x = Int((courrentView?.center.x)!/pw) + ((courrentView?.center.x)!%pw < pw/2 ? 0 : 1)
            let y = Int((courrentView?.center.y)!/pw) + ((courrentView?.center.y)!%pw < pw/2 ? 0 : 1)
            if ((pieces?.indexForKey(x*100+y)) != nil){
                courrentView?.removeFromSuperview()
                count--
            }else{
                pieces![x*100+y] = courrentView
                courrentView?.center = CGPointMake(CGFloat(x) * pw, CGFloat(y) * pw)
                let isOver = isGameOver(x,y)
                if isOver {
                    listener?.gameOver(getPieceType(x, y))
                    
                }
                print("game isOver? \(isOver)")
            }
            courrentView = nil
        }
        
    }
    
    private func isGameOver(x: Int, _ y: Int) -> Bool{
        var countPieceOK = 1;
        
        if leftDown(x,y)&&rightUp(x,y){
            countPieceOK += 2
            if leftDown(x-1, y+1){
            countPieceOK++
                if leftDown(x-2, y+2){
                countPieceOK++
                }
            }
            if rightUp(x+1, y-1){
            countPieceOK++
                if rightUp(x+2, y-2){
                countPieceOK++
                }
            }
        return countPieceOK>=5
        }else if rightUp(x,y){
            countPieceOK++
            if rightUp(x+1,y-1) {
                countPieceOK++
                if rightUp(x+2,y-2) {
                    countPieceOK++
                    if rightUp(x+3,y-3) {
                        countPieceOK++
                    }
                }
            }
        return countPieceOK>=5
        }else if leftDown(x,y){
            countPieceOK++
            if leftDown(x-1, y+1){
                countPieceOK++
                if leftDown(x-2, y+2){
                    countPieceOK++
                    if leftDown(x-3, y+3){
                        countPieceOK++
                    }
                }
            }
        return countPieceOK>=5
        }
        
        if leftUp(x, y)&&rightDown(x,y){
            countPieceOK += 2
            if leftUp(x-1, y-1){
            countPieceOK++
                if leftUp(x-2, x-2){
                    countPieceOK++
                }
            }
            if rightDown(x+1, y+1){
                countPieceOK++
                if rightDown(x+2, y+2){
                    countPieceOK++
                }
            }
        return countPieceOK>=5
        }else if rightDown(x, y){
            countPieceOK++
            if rightDown(x+1, y+1){
                countPieceOK++
                if rightDown(x+2, y+2){
                    countPieceOK++
                }
                if rightDown(x+3, y+3){
                    countPieceOK++
                }
            }
        return countPieceOK>=5
        }else if leftUp(x, y){
            countPieceOK++
            if leftUp(x-1, y-1){
                countPieceOK++
                if leftUp(x-2, y-2){
                    countPieceOK++
                    if leftUp(x-3, y-3){
                        countPieceOK++
                    }
                }
                
            }
        return countPieceOK>=5
        }
        
        if xLeft(x, y)&&xRight(x,y){
            countPieceOK += 2
            if xLeft(x-1, y){
            countPieceOK++
                if xLeft(x-2, y){
                countPieceOK++
                }
            }
            if xRight(x+1, y){
            countPieceOK++
                if xRight(x+2, y){
                countPieceOK++
                }
            }
        return countPieceOK>=5
        }else if xLeft(x, y){
            countPieceOK++
            if xLeft(x-1, y){
            countPieceOK++
                if xLeft(x-2, y){
                countPieceOK++
                    if xLeft(x-3, y){
                    countPieceOK++
                    }
                }
            }
        return countPieceOK>=5
        }else if xRight(x, y){
            countPieceOK++
            if xRight(x+1, y){
                countPieceOK++
                if xRight(x+2, y){
                    countPieceOK++
                    if xRight(x+3, y){
                        countPieceOK++
                    }
                }
            }
        return countPieceOK>=5
        }
        
        if yUp(x, y)&&yDown(x,y){
            countPieceOK += 2
            if yUp(x, y-1){
                countPieceOK++
                if yUp(x, y-2){
                    countPieceOK++
                }
            }
            
            if yDown(x, y+1){
                countPieceOK++
                if yDown(x, y+2){
                    countPieceOK++
                }
            }
            
        return countPieceOK>=5
        }else if yDown(x, y){
            countPieceOK++
            if yDown(x, y+1){
                countPieceOK++
                if yDown(x, y+2){
                    countPieceOK++
                    if yDown(x, y+3){
                        countPieceOK++
                    }
                }
            }
        return countPieceOK>=5
        }else if yUp(x, y){
            countPieceOK++
            if yUp(x, y-1){
                countPieceOK++
                if yUp(x, y-2){
                    countPieceOK++
                    if yUp(x, y-3){
                        countPieceOK++
                    }
                }
            }
            
        return countPieceOK>=5
        }
        
        
    return countPieceOK>=5
    }
    
    
    
    private func getPieceType(x: Int, _ y: Int) -> Int{
        return getPiece(x,y).tag%2
    }
    
    private func getPiece(x: Int, _ y: Int) -> UIImageView{
    
        return pieces![(x*100+y)]!
    }
    
    private func leftDown(x: Int, _ y: Int) -> Bool{
        if (pieces?.indexForKey((x-1)*100+(y+1))) != nil{
            return getPieceType(x,y) == getPieceType(x-1,y+1)
        }
        
        return false
    }
    
    private func rightUp(x: Int, _ y: Int) -> Bool{
    
        if (pieces?.indexForKey((x+1)*100+(y-1))) != nil{
        
            return getPieceType(x,y) == getPieceType(x+1,y-1)
        }
        
        return false
    
    }
    
    private func leftUp(x: Int,_ y: Int) -> Bool{
        if (pieces?.indexForKey((x-1)*100+(y-1))) != nil {
            return getPieceType(x,y) == getPieceType(x-1,y-1)
        }
    
        return false
    }
    
    private func rightDown(x: Int,_ y: Int) -> Bool{
        
        if (pieces?.indexForKey((x+1)*100+(y+1))) != nil {
            return getPieceType(x,y) == getPieceType(x+1,y+1)

        }
        
        return false
    }
    
    private func xRight(x: Int,_ y: Int) -> Bool{
    
        if (pieces?.indexForKey((x+1)*100+(y))) != nil {
            return getPieceType(x,y) == getPieceType(x+1,y)

        }
        
        return false

    }
    private func xLeft(x: Int,_ y: Int) -> Bool{
        
        if (pieces?.indexForKey((x-1)*100+(y))) != nil{
            return getPieceType(x,y) == getPieceType(x-1,y)

        }
        return false
        
    }
    private func yUp(x: Int,_ y: Int) -> Bool{
        if (pieces?.indexForKey((x)*100+(y-1))) != nil{
            return getPieceType(x,y) == getPieceType(x,y-1)

        }
        
        return false
        
    }
    
    private func yDown(x: Int,_ y: Int) -> Bool{
        
        if (pieces?.indexForKey((x)*100+(y+1))) != nil {
            return getPieceType(x,y) == getPieceType(x,y+1)

        }
        
        return false
        
    }
    
    var count: Int = 0
    private func createPiece(x: CGFloat, _ y: CGFloat) -> UIImageView{
    
        let piece = UIImageView(frame: CGRectMake(x-pw/2, y-pw/2, pw, pw))
        
        piece.image = count%2==0 ? UIImage(named: "Black") : UIImage(named: "White")//黑子偶数，白子奇数
        piece.contentMode = UIViewContentMode.ScaleToFill
        piece.tag = count
    
        self.addSubview(piece)
        count++
        return piece
    }

}
