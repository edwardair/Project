//
//  TheStaticGameLayer.m
//  iPlayCrossWord
//
//  Created by 丝瓜&冬瓜 on 13-4-29.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "TheStaticGameLayer.h"
#import "OneWord.h"

#define QB(x) [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/iPlayCrossWord.app/QuestionBank_%d.plist",x]]   

TheStaticGameLayer *theStaticGameLayer = nil;

@interface TheStaticGameLayer(){
    NSMutableArray *selectedWords;
}
@property (nonatomic,retain) NSMutableArray *contentWords;
@property (nonatomic,retain) NSMutableArray *contentEditEnableWords;

@end
@implementation TheStaticGameLayer
//+(id )sceneAddWithInde:(int)index{
//    theStaticGameLayer = [[TheStaticGameLayer alloc]init];
//    
//    AnswerInterface *answerLayer = [AnswerInterface initizlizeWithQ:@"" AndA:@""];
//    [theStaticGameLayer addChild:answerLayer];
//    answerLayer.delegate = theStaticGameLayer;
//    theStaticGameLayer.answerInterface = answerLayer;
//    
//    MenuLayer *curMenuLayer = [MenuLayer initializeWithIndex:index];
//    [theStaticGameLayer addChild:curMenuLayer];
//    curMenuLayer.delegate = theStaticGameLayer;
//
//    [theStaticGameLayer resetWordsPropertyWithPlist:QB(index)];
//    
//    return theStaticGameLayer;
//
//}

//+(void )unShareTheStaticGameLayer{
//    
//    [theStaticGameLayer release];
//        theStaticGameLayer = nil;
//        NSLog(@"%d",theStaticGameLayer.retainCount);
////    }
//}
- (NSMutableArray *)contentWords{
    if (!_contentWords) {
        _contentWords = [[NSMutableArray alloc]initWithCapacity:100];
    }
    return _contentWords;
}
- (NSMutableArray *)contentEditEnableWords{
    if (!_contentEditEnableWords) {
        _contentEditEnableWords = [[NSMutableArray alloc]initWithCapacity:100];
    }
    return _contentEditEnableWords;
}
- (void)setPlistAllWords:(NSMutableDictionary *)plistAllWords{
    [_plistAllWords release];
    _plistAllWords = [plistAllWords retain];
}
+(id )initWithIndex:(int )index{
    return [[[[self class]alloc]initWithIndex:index] autorelease];
}
- (id)initWithIndex:(int )index{
    if ((self = [super init])) {
        
//        [self writePlist];
        
//        [WGDirector addTargetedDelegate:self priority:-1 swallowsTouches:YES];
        
        selectedWords = [[NSMutableArray alloc]init];
        
        self.backGroundImage = [CCSprite spriteWithFile:@"B2.png"];
        
        [self setContentSize:CGSizeMake(300, 300)];
        
        //从左上角开始第0位，到右下角结束
        for (int i = 0; i < 10; i++) {
            for (int j = 0; j < 10; j++) {
                OneWord *word = [OneWord node];
                [self addChild:word];
                word.position = ccp(25 + j * 30, WinHeight - 50 - i * 30);
                word.tag = i * 10 + j;
                word.wordPlacement = [NSString stringWithFormat:@"%d*%d",i,j];
                [word addTarget:self selector:@selector(wordSelected:) withObject:word];

                [self.contentWords addObject:word];
            }
        }
        AnswerInterface *answerLayer = [AnswerInterface initizlizeWithQ:@"" AndA:@""];
        [self addChild:answerLayer];
        answerLayer.delegate = self;
        self.answerInterface = answerLayer;
        
        MenuLayer *curMenuLayer = [MenuLayer initializeWithIndex:index];
        [self addChild:curMenuLayer];
        curMenuLayer.delegate = self;
        
        [self resetWordsPropertyWithPlist:QB(index)];

        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillAppear) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillDisAppear) name:UIKeyboardWillHideNotification object:nil];

        
    }
    return self;
}
//键盘弹出
- (void)keyBoardWillAppear{
//    [self runAction:[CCMoveBy actionWithDuration:.25f position:ccp(0, 108)]];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25f];

    [Director view].transform = CGAffineTransformMakeTranslation(0, -216);
    [UIView commitAnimations];
}
//键盘消失
- (void)keyBoardWillDisAppear{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25f];
    [Director view].transform = CGAffineTransformMakeTranslation(0, 0);
    [UIView commitAnimations];
}

//根据plist重置所有word的属性
- (void)resetWordsPropertyWithPlist:(NSString *)plist{

//    NSLog(@"%@",plist);
//    NSLog(@"%@",[[NSBundle mainBundle]pathForResource:@"QuestionBank_1" ofType:@"plist"]);
    [self.contentEditEnableWords removeAllObjects];
    
    self.plistAllWords = [WGWritePlist readPlist:plist];

    for (OneWord *word in self.contentWords) {
        NSString *placement = word.wordPlacement;
        id temp = [_plistAllWords objectForKey:placement];
        if ([temp isKindOfClass:[NSString class]]) {
            word.selectEnable = NO;
//            word.allowTouch = NO;
        }else{
            word.selectEnable = YES;
//            word.allowTouch = YES;
            word.whichQuestion = 0;
            word.selected = NO;
            NSMutableDictionary *tempArray = (NSMutableDictionary *)temp;
            if (tempArray[@"TextRecord"]) {
                word.text = [tempArray objectForKey:@"TextRecord"];
            }
            [word.questions removeAllObjects];
            [word.answers removeAllObjects];
            [word.questions addObject:[tempArray objectForKey:@"Q1"]];
            [word.answers addObject:[tempArray objectForKey:@"A1"]];
            if ([tempArray objectForKey:@"Q2"]) {
                [word.questions addObject:[tempArray objectForKey:@"Q2"]];
            }
            if ([tempArray objectForKey:@"A2"]) {
                [word.answers addObject:[tempArray objectForKey:@"A2"]];
            }

            [_contentEditEnableWords addObject:word];
            
        }
    }
    
    //初始化时 默认显示第一个word的问题 
    [self wordSelected:_contentEditEnableWords[0]];
}
//word点击方法
- (void)wordSelected:(OneWord *)word{
    if (!word.selectEnable) {
        NSLog(@"禁止点击");
        return;
    }
    self.answerInterface.question.text = word.questions[word.whichQuestion];
    self.answerInterface.answerLength = [word.answers[word.whichQuestion] length];
    self.answerInterface.answer.text = @"";
    [self ergodicAllWordsWithA:word.answers[word.whichQuestion]];
}
//将所有选中状态的words改成未选中状态
- (void)setWordsSelected:(BOOL )selected{
    if (selectedWords.count>0) {
        for (OneWord *word in selectedWords) {
            word.selected = selected;
        }
        if (!selected)
            [selectedWords removeAllObjects];
    }
}
//根据答案遍历所有words找到相同的 同时按照从前到后排列顺序
- (void )ergodicAllWordsWithA:(NSString *)answer{
    [self setWordsSelected:NO];
    
    //遍历搜索
    for (OneWord *word in _contentEditEnableWords) {
        if (word.questions.count>0) {
            if ( ( (word.questions.count==1)&&([word.answers[0] isEqualToString:answer]) ) ||
                ( (word.questions.count==2)&&(([word.answers[0] isEqualToString:answer])||([word.answers[1] isEqualToString:answer])) ) ) {
                [selectedWords addObject:word];
            }
        }
    }

    [self setWordsSelected:YES];
}
//AnswerDelegate
- (void)UITextFieldShouldReturn{
    int count = self.answerInterface.answer.text.length;
    for (int i = 0; i < count; i++) {
        NSRange range = {i,1};
        NSString *wordText = [self.answerInterface.answer.text substringWithRange:range];
        [(OneWord *)selectedWords[i] setText:wordText];
        wordText = nil;
    }
}
//MenuLayerDelegate
- (void)setWordText:(OneWord *)word{
    NSString *rightText = [[_plistAllWords objectForKey:word.wordPlacement] objectForKey:@"Text"];
    word.text = rightText;
}
- (void)showXiaoChao{
    int number = arc4random()%_contentEditEnableWords.count;
    OneWord *word = _contentEditEnableWords[number];

    [self setWordText:word];
    
}
- (void)showDaChao{
    int number = arc4random()%_contentEditEnableWords.count;
    OneWord *word = _contentEditEnableWords[number];
    
    [self ergodicAllWordsWithA:word.answers[word.whichQuestion]];
    for (OneWord *word in selectedWords) {
        [self setWordText:word];
    }
}
- (void)saveCurPuzzleWithIndex:(int )index{
    
    for (OneWord *word in _contentEditEnableWords) {
        if (word.selectEnable) {
            if (word.text.length>0) {
                [[_plistAllWords objectForKey:word.wordPlacement] setObject:word.text forKey:@"TextRecord"];
            }else{
                [[_plistAllWords objectForKey:word.wordPlacement] setObject:@"" forKey:@"TextRecord"];
            }
        }
    }
    
    [WGWritePlist writePlistWithObj:_plistAllWords.allValues key:_plistAllWords.allKeys plistName:QB(index)];
}
- (void)submitPuzzle{
    int count = _contentEditEnableWords.count;
    int number = 0;
    for (OneWord *word in _contentEditEnableWords) {
        NSString *rightText = [[_plistAllWords objectForKey:word.wordPlacement] objectForKey:@"Text"];
        if ([word.text isEqualToString:rightText]) {
            number++;
        }
    }
    float rate = (float )number/count;
    if (rate>.6f) {
        NSLog(@"及格");
    }else{
        NSLog(@"不及格");
    }
}
//写 plist
- (void)writePlist{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSArray *texts = [NSArray arrayWithObjects:
                      @"乔/苹果教主，2011年10月因病去世。/乔布斯/电视剧，讲述晋商代表人物乔致庸一生的传奇故事。/乔家大院",
                      @"布/苹果教主，2011年10月因病去世。/乔布斯",
                      @"斯/苹果教主，2011年10月因病去世。/乔布斯",
                      @"",@"",
                      @"迈/已故美国超级巨星，被誉为“流行音乐之王”。/迈克尔杰克逊",
                      @"",
                      @"丁/指夫妇都有收入并且不打算生育孩子的家庭，是英文“DINK”的音译。/丁克",
                      @"",
                      @"世/2010年在上海举办的展现人类在各领域取得成就的国际性大型展示会。/世博会",
                      
                      @"家/电视剧，讲述晋商代表人物乔致庸一生的传奇故事。/乔家大院",
                      @"",@"",
                      @"阿/人类首次登上月球乘坐的飞船。/阿波罗号",
                      @"",
                      @"克/美国男明星，曾饰演《乱世佳人》中的白瑞德。/克拉克盖博/已故美国超级巨星，被誉为“流行音乐之王”。/迈克尔杰克逊",
                      @"拉/美国男明星，曾饰演《乱世佳人》中的白瑞德。/克拉克盖博",
                      @"克/美国男明星，曾饰演《乱世佳人》中的白瑞德。/克拉克盖博/指夫妇都有收入并且不打算生育孩子的家庭，是英文“DINK”的音译。/丁克",
                      @"盖/美国男明星，曾饰演《乱世佳人》中的白瑞德。/克拉克盖博",
                      @"博/美国男明星，曾饰演《乱世佳人》中的白瑞德。/克拉克盖博/2010年在上海举办的展现人类在各领域取得成就的国际性大型展示会。/世博会",
                      
                      @"大/美国一位著名的魔术师。/大卫科波菲尔/电视剧，讲述晋商代表人物乔致庸一生的传奇故事。/乔家大院",
                      @"卫/美国一位著名的魔术师。/大卫科波菲尔",
                      @"科/美国一位著名的魔术师。/大卫科波菲尔",
                      @"波/美国一位著名的魔术师。/大卫科波菲尔/人类首次登上月球乘坐的飞船。/阿波罗号",
                      @"菲/美国一位著名的魔术师。/大卫科波菲尔",
                      @"尔/美国一位著名的魔术师。/大卫科波菲尔/已故美国超级巨星，被誉为“流行音乐之王”。/迈克尔杰克逊",
                      @"",@"",@"",
                      @"会/2010年在上海举办的展现人类在各领域取得成就的国际性大型展示会。/世博会",
                      
                      @"院/电视剧，讲述晋商代表人物乔致庸一生的传奇故事。/乔家大院",
                      @"",@"",
                      @"罗/人类首次登上月球乘坐的飞船。/阿波罗号",
                      @"",
                      @"杰/20世纪初北美著名小说家，代表作有《荒野的呼唤》、《马丁.伊登》等。/杰克伦敦/已故美国超级巨星，被誉为“流行音乐之王”。/迈克尔杰克逊",
                      @"克/20世纪初北美著名小说家，代表作有《荒野的呼唤》、《马丁.伊登》等。/杰克伦敦",
                      @"伦/20世纪初北美著名小说家，代表作有《荒野的呼唤》、《马丁.伊登》等。/杰克伦敦/Ｘ射线的别称。/伦琴射线",
                      @"敦/20世纪初北美著名小说家，代表作有《荒野的呼唤》、《马丁.伊登》等。/杰克伦敦",
                      @"",
                      
                      @"",
                      @"集/冯小刚导演的一部战争片，张涵予、廖凡、王宝强、邓超等主演。/集结号",
                      @"结/冯小刚导演的一部战争片，张涵予、廖凡、王宝强、邓超等主演。/集结号/徐帆、陈建斌主演的二十集电视连续剧。/结婚十年",
                      @"号/冯小刚导演的一部战争片，张涵予、廖凡、王宝强、邓超等主演。/集结号/人类首次登上月球乘坐的飞船。/阿波罗号",
                      @"",
                      @"克/已故美国超级巨星，被誉为“流行音乐之王”。/迈克尔杰克逊",
                      @"",
                      @"琴/Ｘ射线的别称。/伦琴射线",
                      @"",
                      @"汗/传说中一种会流出红色汗水的良驹。/汗血宝马",
                      
                      @"",@"",
                      @"婚/徐帆、陈建斌主演的二十集电视连续剧。/结婚十年",
                      @"",
                      @"谢/《倚天屠龙记》中男主人公的义父。/谢逊",
                      @"逊/《倚天屠龙记》中男主人公的义父。/谢逊/已故美国超级巨星，被誉为“流行音乐之王”。/迈克尔杰克逊",
                      @"",
                      @"射/Ｘ射线的别称。/伦琴射线",
                      @"",
                      @"血/传说中一种会流出红色汗水的良驹。/汗血宝马",
                      
                      
                      @"五/时代名，从朱温灭唐称帝至北宋建立这段历史时期。/五代十国/指唱歌的人把握不好音阶音调，唱歌跑调难听。/五音不全",
                      @"代/时代名，从朱温灭唐称帝至北宋建立这段历史时期。/五代十国",
                      @"十/时代名，从朱温灭唐称帝至北宋建立这段历史时期。/五代十国/徐帆、陈建斌主演的二十集电视连续剧。/结婚十年",
                      @"国/时代名，从朱温灭唐称帝至北宋建立这段历史时期。/五代十国",
                      @"",@"",
                      @"天/幼儿节目，主角是四个模样古怪的外星人。/天线宝宝/金庸的一部武侠小说。/天龙八部",
                      @"线/幼儿节目，主角是四个模样古怪的外星人。/天线宝宝/Ｘ射线的别称。/伦琴射线",
                      @"宝/幼儿节目，主角是四个模样古怪的外星人。/天线宝宝",
                      @"宝/幼儿节目，主角是四个模样古怪的外星人。/天线宝宝/传说中一种会流出红色汗水的良驹。/汗血宝马",
                      
                      @"音/指唱歌的人把握不好音阶音调，唱歌跑调难听。/五音不全",
                      @"",
                      @"年/徐帆、陈建斌主演的二十集电视连续剧。/结婚十年",
                      @"",
                      @"李/一代功夫巨星，他主演的功夫片风靡全球，中国功夫也随之闻名于世界。/李小龙/女明星，主演的电影有《云水谣》、《辛亥革命》、《雪花秘扇》等。/李冰冰",
                      @"小/一代功夫巨星，他主演的功夫片风靡全球，中国功夫也随之闻名于世界。/李小龙",
                      @"龙/一代功夫巨星，他主演的功夫片风靡全球，中国功夫也随之闻名于世界。/李小龙/金庸的一部武侠小说。/天龙八部",
                      @"",@"",
                      @"马/传说中一种会流出红色汗水的良驹。/汗血宝马",
                      
                      @"不/指唱歌的人把握不好音阶音调，唱歌跑调难听。/五音不全",
                      @"",@"",
                      @"干/固态的二氧化碳，白色，半透明，形状像冰。/干冰",
                      @"冰/固态的二氧化碳，白色，半透明，形状像冰。/干冰/女明星，主演的电影有《云水谣》、《辛亥革命》、《雪花秘扇》等。/李冰冰",
                      @"",
                      @"八/明清科举考试制度所规定的文体。每篇由破题、承题、起讲、入手、起股、中股、后股、束股八部分组成。/八股文/金庸的一部武侠小说。/天龙八部",
                      @"股/明清科举考试制度所规定的文体。每篇由破题、承题、起讲、入手、起股、中股、后股、束股八部分组成。/八股文",
                      @"文/明清科举考试制度所规定的文体。每篇由破题、承题、起讲、入手、起股、中股、后股、束股八部分组成。/八股文/东南亚国家，首都斯里巴加湾市，石油、天然气的开采和出口是经济支柱。/文莱",
                      @"",
                      
                      @"全/中华知名老字号，以烤鸭著称。/全聚德/指唱歌的人把握不好音阶音调，唱歌跑调难听。/五音不全",
                      @"聚/中华知名老字号，以烤鸭著称。/全聚德",
                      @"德/中华知名老字号，以烤鸭著称。/全聚德",
                      @"",
                      @"冰/女明星，主演的电影有《云水谣》、《辛亥革命》、《雪花秘扇》等。/李冰冰",
                      @"",
                      @"部/金庸的一部武侠小说。/天龙八部",
                      @"",
                      @"莱/东南亚国家，首都斯里巴加湾市，石油、天然气的开采和出口是经济支柱。/文莱",
                      @"",
                      nil];
    
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 10 ; j++) {
            NSMutableDictionary *temp = [NSMutableDictionary dictionary];
            
            NSString *string = [texts objectAtIndex:i * 10 + j];
            NSString *placement = [NSString stringWithFormat:@"%d*%d",i,j];
            
            if (string.length>0) {
                NSArray *compareArray = [string componentsSeparatedByString:@"/"];
                
                NSString *text = compareArray[0];
                NSString *Q1,*A1,*Q2,*A2;
                Q1 = compareArray[1];
                A1 = compareArray[2];
                Q2 = compareArray.count>3?compareArray[3]:@"";
                A2 = compareArray.count>4?compareArray[4]:@"";
                
                [temp setObject:text forKey:@"Text"];
                [temp setObject:Q1 forKey:@"Q1"];
                [temp setObject:A1 forKey:@"A1"];
                if (Q2.length>0 && A2.length>0) {
                    [temp setObject:Q2 forKey:@"Q2"];
                    [temp setObject:A2 forKey:@"A2"];
                }
                
                [dic setObject:temp forKey:placement];
            }
            else{
                [dic setObject:@"N" forKey:placement];
            }
            
        }
    }
    
    [WGWritePlist writePlistWithObj:dic.allValues key:dic.allKeys plistName:@"QuestionBank_1.plist"];
    
}
- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    self.answerInterface = nil;
    [_contentWords release];
    [_contentEditEnableWords release];
//    _contentWords = nil;
//    _contentEditEnableWords = nil;
    [selectedWords release];
    
//    self.contentWords = nil;
//    self.contentEditEnableWords = nil;
    
    self.plistAllWords = nil;
    [super dealloc];
}
@end
