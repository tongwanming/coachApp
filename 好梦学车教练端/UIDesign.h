//
//  UIDesign.h
//  好梦学车
//
//  Created by haomeng on 2017/4/26.
//  Copyright © 2017年 haomeng. All rights reserved.
//

#ifndef UIDesign_h
#define UIDesign_h


// colors

#ifndef RGBA
#define RGBA(r, g, b, a)                     [UIColor colorWithRed:r green:g blue:b alpha:a]
#define RGBAN(r, g, b, a)                   RGBA(r / 255.0, g / 255.0, b / 255.0, a / 100.0)
#endif


#define POPVIEW_BACKGROUND_COLOR RGBA(0, 0, 0, 0.30)
#define LIGHTED_TEXT_COLOR  RGBAN(30, 149, 227, 255)

#define UNIMPORTANT_TEXT_COLOR  RGBAN(179, 179, 179, 255)
#define LIGHTED_TEXT_COLOR  RGBAN(30, 149, 227, 255)

//文字主要颜色

//464c55
#define TEXT_COLOR RGBAN(70, 76, 85, 255)
//676e79
#define UNMAIN_TEXT_COLOR RGBAN(103, 110, 121, 255)
//ffffff
#define WHITE_TEXT_COLOR RGBAN(255,255,255,60)
//007cea
#define SELECT_TEXT_COLOR RGBAN(0,124,234,100)
//00a0ff
#define BLUE_BACKGROUND_COLOR RGBAN(0,160,255,100)
//c4c6cc
#define C4C6CC RGBAN(70,76,85,100)
//adb1b9
#define ADB1B9 RGBAN(173,177,185,100)
//ff8400
#define FF8400 RGBAN(255,132,0,100)
//cccfd6
#define CCCFD6 RGBAN(204,207,214,100)
//d8dbdf
#define D8DBDF RGBAN(216,219,223,100)
//CFEDFF
#define CFEDFF RGBAN(207,237,255,90)
//eeeeee
#define EEEEEE RGBAN(238,238,238,100)
//f7f7f7
#define F7F7F7 RGBAN(247,247,247,100)
//999999
#define RECORDWORK RGBAN(153,153,153,100)
//333333
#define BLACK_TEXT_COLOR RGBAN(51,51,51,100)
//DDDDDD
#define DDDDDD RGBAN(221,221,221,100)
//F39D10
#define F39D10 RGBAN(243,157,16,100)
//EFF2F6
#define EFF2F6 RGBAN(239,242,246,100)

#define CURRENT_BOUNDS [UIScreen mainScreen].bounds.size


#define TYPERATION [[UIScreen mainScreen] bounds].size.width/414

#define TYPERATIONTWO [[UIScreen mainScreen] bounds].size.width/375
#endif /* UIDesign_h */
