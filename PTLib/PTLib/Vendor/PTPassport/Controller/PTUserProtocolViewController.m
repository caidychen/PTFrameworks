//
//  PTUserProtocolViewController.m
//  PTLatitude
//
//  Created by LiLiLiu on 15/11/30.
//  Copyright © 2015年 PT. All rights reserved.
//

#import "PTUserProtocolViewController.h"

//Model

//View
#import "PTLoginNavView.h"
#import "PassportUtilTool.h"
#import "PassportMacro.h"

//Controller


@interface PTUserProtocolViewController ()<UIScrollViewDelegate>
@property (nonatomic , strong) UIImageView *backgroundImage;
@property (nonatomic , strong) PTLoginNavView *navView;
@property (nonatomic , strong) UITextView *textView;
@end

@implementation PTUserProtocolViewController
@synthesize backgroundImage = _backgroundImage;
@synthesize navView = _navView;
@synthesize textView = _textView;

- (void)dealloc {
    PPTRELEASE(_backgroundImage);
    PPTRELEASE(_navView);
    PPTRELEASE(_textView);
    PPTSUPERDEALLOC();
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        
    }
    return (self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.backgroundImage];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.textView];
    
    [self setText];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.backgroundImage.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    //这里是自定义导航栏宽高设置
    self.navView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), Passport_HEIGHT_NAV+Passport_HEIGHT_STATUS);
    
    self.textView.frame = CGRectMake(0, Passport_HEIGHT_STATUS+Passport_HEIGHT_NAV, Passport_Screenwidth, Passport_Screenheight);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - getter
- (UIImageView *)backgroundImage{
    if (!_backgroundImage) {
        _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectZero ];
        if ([@"4" isEqualToString:[PassportUtilTool getCurrentDrive]]) {
            _backgroundImage.image = [UIImage imageNamed:@"img_bg_signup@2x.png"];
        }else{
            _backgroundImage.image = [UIImage imageNamed:@"img_bg_signup@3x.png"];
        }
    }
    return _backgroundImage;
}


- (PTLoginNavView *)navView{
    if (!_navView) {
        _navView = [[PTLoginNavView alloc] initWithFrame:CGRectZero];
        _navView.backType = PTLoginNavBackImageType;
        _navView.title = @"用户服务协议";
        
        __weak typeof(self) weakSelf = self;
        _navView.leftActionBlock = ^(){
            //点击取消按钮
            [weakSelf leftItemTouched];
        };
    }
    return _navView;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectZero];
        _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 66, 10); //上右下左填充
        _textView.backgroundColor = [UIColor clearColor];
    }
    return _textView;
}

#pragma mark -

#pragma mark - setter
- (void)setText{
    NSString *text = @"    本协议服务条款（简称“本协议”）是由用户（服务使用者，简称“您”）与上海葡萄纬度科技有限公司针对葡萄纬度软件(以下简称”本软件”)的下载、安装、使用、复制而订立的权利义务协议。本协议连同所有关于本软件的更新材料、补充条款、软件许可证、以及相关规则和和政策，共同构成您与上海葡萄纬度科技有限公司间的协议。本协议适用于本软件所包含的任何服务，包括服务的功能和内容，以及功能和内容的发布、更新、升级、修改。一旦您打开并注册本软件，则表示您已阅读并接受本协议的所有条款的约束，包括接受上海葡萄纬度科技对本协议随时所做出的任何修改。如果您对本协议有任何异议，您可以选择不使用并删除本软件。上海葡萄纬度科技有权拒绝不符合本协议中条款要求的访问，并保留不当访问资料，保留追究法律责任的权利。\n    1. 用户的权利和义务\n    1.1 除法律特别规定或者政府明确要求之外，在未取得上海葡萄纬度科技书面明确许可前，任何单位或者个人不得对上海葡萄纬度科技的任何知识产权进行任何目的的使用，包括但不仅限于对本软件进行反向工程、破坏或者规避上海葡萄纬度科技为保护本软件而设置的技术措施，或者以其他方式尝试发现本软件的源代码，以及对上海葡萄纬度科技所拥有知识产权的内容进行使用、复制、修改、二次开发、链接、转载、汇编、发表、出版、建立镜像站点等。\n    1.2 任何经由本软件生成、查看、下载、分发的观点、文字、图片、照片、动画、音频、视频、链接等信息或其它资料（以下简称“内容”），均由内容提供者、使用者自行承担其上传、使用行为的完全责任。葡萄纬度科技作为服务提供商，无法对用户的使用行为进行全面控制，也无法控制经由本服务传送之内容，因此不能保证内容的合法性、正确性、真实性以及质量。一旦您使用本服务，即视为您已完全知晓可能接触到有冒犯性的、不适当的内容，并同意将自行承担所有风险。\n\n    用户不得利用本软件制作、上传、发布、传播包含但不仅限于含有下列信息之一的内容：\n    •	a. 反对宪法基本原则的；\n    •	b. 危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；\n    •	c. 损害国家荣誉和利益的；\n    •	d. 煽动民族仇恨、民族歧视、破坏民族团结的；\n    •	e. 破坏国家宗教政策，宣扬邪教和封建迷信的；\n    •	f. 散布谣言，扰乱社会秩序，破坏社会稳定的；\n    •	g. 散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；\n    •	h. 侮辱或者诽谤他人，侵害他人合法权利的；\n    •	i. 煽动非法集会、结社、游行、示威、聚众扰乱社会秩序的；\n    •	j. 以非法民间组织名义活动的；\n    •	k. 含有虚假、有害、胁迫、侵害他人隐私、骚扰、侵害、中伤、粗俗、猥亵、或其它道德上令人反感的内容的；\n    •	l. 含有未经上海葡萄纬度科技有限公司授权的广告信息或者垃圾信息的；\n    •	m. 含有违反法律法规、政策和公序良俗、社会公德以及侵犯其他用户或者第三方合法权益的信息的。\n    1.3 用户必须在上传任何观点、文字、图片、照片、动画、音频、视频、链接等信息或其它资料（以下简称“内容”）之前保证拥有内容相应的、完整的、无瑕疵的所有权及知识产权或者取得了合法授权，从而有权在本软件中对照片进行上传、处理等一切使用行为。用户必须保证在本软件中使用的内容未侵犯任何第三方的合法权益，特别的，用户不得将任何未获授权的内部资料或者机密资料、可能侵犯他人隐私的资料或者侵犯任何人名誉权、肖像权、知识产权、商业秘密等合法权利的内容在本软件中使用。否则您必须独自承担由此带来的一切法律后果。\n    1.4 一旦用户使用本软件的服务，即视为该用户主动将所上传的文字、图片、照片、动画、音频、视频、链接等信息或其它资料（以下简称“内容”）所承载的全部知识产权利无偿许可给葡萄纬度科技使用，且表明该用户放弃对上海葡萄纬度科技主张所上传内容中任何知识产权、肖像权及隐私权。\n    1.5 用户同意遵守《中华人民共和国民法通则》、《中华人民共和国著作权法》、《中华人民共和国保守国家秘密法》、《中华人民共和国计算机信息系统安全保护条例》、《计算机软件保护条例》、《最高人民法院关于审理涉及计算机 网络著作权纠纷案件适用法律若干问题的解释(法释[2004]1号)》、《互联网著作权行政保护办法》、《互联网新闻信息服务管理规定》等有关国家法律法规、政策。在任何情况下，如果用户违反国家法律法规、政策或者本协议，导致上海葡萄纬度科技遭受任何损害或遭受任何来自第三方的纠纷、诉讼、索赔要求等，用户须向上海葡萄纬度科技赔偿全部损失（包括直接损失及间接损失），用户应当对其违反法律法规、政策或者本协议所产生的一切法律后果承担全部法律责任。\n    1.6 用户不得利用本软件从事任何危害计算机信息网络安全的行为。一经投诉、举报、发现，将由用户承担一切法律责任并赔偿对上海葡萄纬度科技造成的损失。\n    1.7 一旦用户使用本软件，即视为该用户自愿接受上海葡萄纬度科技发出的包括但不仅限于邮件、短消息、系统推送信息等信息（包括但不仅限于商品促销等广告信息）。\n    1.8 本协议服务条款可由上海葡萄纬度科技随时更新，且无需另行通知。用户如果对协议的条款修改有任何异议，可选择自行停止使用本软件并删除本软件。一旦用户继续使本软件，则视为用户已经完全接受本协议及其修改后的服务条款 。\n    1.9 上海葡萄纬度科技非常重视对未成年人信息的保护。若您是18周岁以下的未成年人，在使用上海葡萄纬度科技的产品和/或服务前，应事先取得您家长或法定监护人的同意。\n\n    2. 服务风险及免责声明\n    2.1 用户完全理解并同意，本软件存在因各种不可抗力、计算机病毒或黑客攻击、系统不稳定、移动通讯网络质量、互联网络通信质量、通信线路故障等原因造成的服务中断或不能满足用户要求的风险，或可能造成服务取消或终止的风险（用户在本服务中储存的任何信息可能无法恢复），使用本软件的用户须自行承担以上风险，上海葡萄纬度科技对本软件的及时性、安全性、准确性不作担保，对因此导致用户不能正确生成、发送、接收、存储数据、查看已生成数据或者其他问题的，上海葡萄纬度科技不承担任何责任。对于由于不可抗力或者不是基于上海葡萄纬度科技的过错而导致的用户数据损失、丢失或服务停止，上海葡萄纬度科技将不承担任何责任。\n    2.2 上海葡萄纬度科技承诺，一经发现系统故障便及时进行处理、修复。但上海葡萄纬度科技将不承担用户因此而产生的任何经济和精神损失。此外，上海葡萄纬度科技保留不经事先通知为系统维护、升级或其它任何目的而暂停部分或全部本软件服务的权利。\n    2.3 上海葡萄纬度科技有权根据自行发现或者他人举报、投诉用户违法本协议内容，对其采取包括但不仅限于拒绝、屏蔽、删除、警告等相应行动，包括但不限于不经通知随时暂停或停止用户使用本服务的全部或部分，保存有关记录，并向相关部门报告。\n    2.4 如果因您违反本协议或相关服务条款的规定，导致或者产生第三方主张的任何索赔、要求或损失，您应当独立承担责任；上海葡萄纬度科技因此遭受损失的，您也应当一并赔偿。\n\n    3. 用户隐私保护\n    3.1 为进一步完善服务，提升用户体验，我们将在提供服务的过程中收集必要的数据信息，并根据这些数据的分析结果改进产品和服务，不断提升服务品质。\n    3.2 我们收集的用户数据可能会包含硬件设备信息、性能统计数据、以及本软件的使用数据等信息。数据的采集将全部匿名，并被妥善地加密保护。\n\n    4. 适用法律及争议管辖\n    4.1 本服务条款之效力和解释均适用中华人民共和国法律。如服务条款的任何一部分与中华人民共和国法律相抵触，则该部分条款应按法律规定重新解释，部分条款之无效或重新解释不影响其它条款之法律效力。\n    4.2 本协议签订地为中华人民共和国上海市。\n    4.3 用户和上海葡萄纬度科技一致同意凡因本协议所产生的纠纷双方应当先协商解决，协商不成的，任何一方可提交本协议签订地有管辖权的人民法院管辖。\n    4.4 上海葡萄纬度科技拥有对本协议服务条款的最终解释权。\n\n                上海葡萄纬度科技有限公司\n";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];    //行间距
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"313131"] range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [attributedString length])];
    self.textView.attributedText = attributedString;
}
#pragma mark -

#pragma mark - action
- (void)leftItemTouched{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -


#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (0 != scrollView.contentInset.top) {
        scrollView.contentInset = UIEdgeInsetsZero;
    }
}


#pragma mark - <SOViewControllerProtocol>
- (void)setParameters:(id)parameters {
    [super setParameters:parameters];
    
}
#pragma mark -




@end
