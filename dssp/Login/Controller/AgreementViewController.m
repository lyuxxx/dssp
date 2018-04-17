//
//  AgreementViewController.m
//  dssp
//
//  Created by qinbo on 2018/3/21.
//  Copyright © 2018年 capsa. All rights reserved.
//

#import "AgreementViewController.h"
#import "RegisterViewController.h"
@interface AgreementViewController ()
@property (nonatomic,strong) UITextView *contentlabel;
@end

@implementation AgreementViewController

- (BOOL)needGradientBg {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navigationItem.title = NSLocalizedString(@"用户协议", nil);
    
    
    UILabel *topLabel = [[UILabel alloc] init];
    topLabel.text = NSLocalizedString(@"用户协议", nil);
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = [UIFont fontWithName:@"SFProDisplay-Medium" size:20];
    topLabel.textColor = [UIColor colorWithHexString:@"#A18E79"];
    //    botLabel.backgroundColor =[UIColor redColor];
    [self.view addSubview:topLabel];
    [topLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(30 * HeightCoefficient);
        make.width.equalTo(120);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    
    
    self.view.clipsToBounds = YES;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    gradient.colors = @[(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#040000"].CGColor,(id)[UIColor colorWithHexString:@"#212121"].CGColor];
    gradient.locations = @[@0,@0.8,@1];
    gradient.startPoint = CGPointMake(0.5, 0);
    gradient.endPoint = CGPointMake(0.5, 1);
    [self.view.layer addSublayer:gradient];
    [self.view.layer insertSublayer:gradient atIndex:0];
    [self setupUI];
}

- (void)setupUI {
    
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
    [self.view addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15 * WidthCoefficient);
        make.height.equalTo(kScreenHeight - kNaviHeight-kTabbarHeight-kStatusBarHeight-50);
        make.left.equalTo(15 * WidthCoefficient);
        make.top.equalTo(84 * HeightCoefficient);
        
        
    }];
    
    
    UILabel *botLabel = [[UILabel alloc] init];
    botLabel.text = NSLocalizedString(@"DS车联网服务协议", nil);
   
    botLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    botLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    //    botLabel.backgroundColor =[UIColor redColor];
    [line addSubview:botLabel];
    [botLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(10 * HeightCoefficient);
        make.width.equalTo(180);
        make.height.equalTo(20 * HeightCoefficient);
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ds_service_protocols" ofType:@"txt"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    
    
    
    NSLog(@"srt=%@",content);

    
    
    self.contentlabel =[[UITextView alloc] init];
    NSString *cssStr = @"<style type='text/css'>body{color:#ffffff;background:#120f0e !important;}p{background: #120f0e1 !important;color: #FFFFFF;font size:20px;line-height: 24px!important;}p span{background: #120f0e !important;color: #FFFFFF !important;}p img{max-width: 100%!important;}</style>";
    
    
    
    NSString *htmlString = @"<p>DS车联网服务协议</p><p>本服务协议条款系由您与上长安标致雪铁龙汽车有限公司销售分公司(下称“我们”或“CAPSA”)签署。本条款适用于您使用CAPSA车联网服务(下称“本服务”)。</p><!--<br/>--><p>1，前言本协议内容除协议正文以外，CAPSA已经发布的或将来可能发布的各类规则，以及我们通过DS 官网、车联网手机APP等途径向您提供、更新的政策或程序均与协议正文具有同等法律效力。您承诺，在使用车联网提供的各项服务时，接受并遵守上述文件及程序的规定。您认可，CAPSA有权根据需要不时地修改本协议或制定、修改各类规则，如您不同意相关变更，须立即以正式书面签字或盖章的通知方式告知CAPSA，CAPSA有权选择终止相关变更或维持变更。如变更后，您继续使用本协议项下服务的，将视为您同意接受变更。当更新后的协议与之前的协议内容存在冲突时，应优先适用新协议内容。</p><!--<br/>--><p>2，服务的获取与开通2.1您可获得的服务取决于您购买的车型。2.2请确保在开通并激活车联网账户时，登记的信息与购车时登记的车主信息保持一致。2.3按照车联网服务开通的步骤进行车主账号的注册与服务的开通。开通服务前，本协议必须由您或您的委托人审核确认。除非法律另有相反规定，在以下任一情况下表示您同意并接受了本协议:在您购买一辆含有CAPSA提供车联网服务的新车或二手车时，授权汽车销售方代为开通CAPSA车联网服务；在您签署本协议时；在您登录车机互联网系统并在线确认同意接受本协议时；在您通过DS 车联网手机APP完成个人注册时；当您(或者经您授权使用您车辆的任何人)使用CAPSA提供的车联网服务或接受其任何服务援助时(包括使用带有已激活的CAPSA提供服务的车辆)时。若您的行为符合上述条件中的一项或多项内容时，即表示您已接受本协议及其任何变更或修改(您可根据本协议规定获得该协议变更或修改的全部条款及内容)。服务的开通时间及随车使用的服务套餐请以CAPSA正式通知为准。</p><!--<br/>--><p>3，服务内容本服务具体内容取决于您购买的车型有所差异，同时也取决于您订购或获赠的车联网服务套餐，详见DS车联网手机APP内容或咨询CAPSA客服顾问。</p><!--<br/>--><p>4，服务限制我们仅对中国大陆地区(港、澳、台地区不在服务范围内)提供服务。本服务受您车辆所在位置移动通信网络信号和GPS信号强弱等其他非甲方因素的影响，可能造成服务质量和效率的降低。您理解，基于整车定位信息实施的车联网服务的实施需同时具备以下条件:该地区可接受GPS卫星信号，且GPS信号无阻碍；GPS卫星信号与车联网硬件相匹配；移动信号无阻碍，GSM、3G、4G网络信号良好；无其他可能影响车联网服务的、非甲方造成的因素另外，您的车辆还具备有效的电气系统(包括电量充足的电池)以供车联网系统运作。如果您的随车车联网设备未经(CAPSA或由CAPSA授权的机构或人员)妥善安装，或您未将这些设备和您的车辆保养至良好状态，本服务可能无法实施。若您增加或变更您车内的车联网设备的任何硬件或软件系统，本服务也可能无法实施。</p><!--<br/>--><p>5，服务费用5.1当您购买配有本服务的新车时，我们为您提供了一定期限的车联网服务体验期，有效期详见CAPSA公告信息，您可以根据需求自愿使用。5.2 当您购买一辆配有车联网服务的二手车时，如需继续使用随车的车联网服务，若购买的二手车在服务期内，您只需根据自己的需求联系我们进行用户变更、注册自己的信息，便可以使用车联网服务；若购买的二手车服务期超过保号期未续费，您只能重新更换车载设备之后开通车联网服务，您更换设备所产生的费用问题，由您与卖方自行协商。5.3对于付费购买的车联网服务因具体套餐种类的不同而有所差异，且均采用预付费。您应当先付费，再使用。您支付的费用将依据所选服务套餐而定。但购买本服务的费用总额中不包括第三方服务所发生的任何费用，您应自行承担与第三方发生服务的费用，并直接将该费用支付给第三方，例如紧急服务提供商、现场服务提供商、拖车公司、医疗机构或酒店等。5.4服务有效期于您开通车联网服务时开始起算，直至您或者我们根据本协议终止服务。5.5 本服务免费体验期过后，如需继续使用，只需按照我们告知的车联网服务内容，选择套餐，按照购买服务时长，付费即可； 车联网服务产品价格以服务购买页面显示价格为准。每次购买仅能配置到单一车辆，并仅限配置车辆使用。车联网服务内容具有一定的使用有效期，请您在有效期内使用。若您未续费，我们将为您免费提供12个月的保号服务，超过12个月仍未续费，此设备作废。您若再想使用远程控制等车联网功能时，需要重新激活您的车联网服务，由此产生的费用由用户自行承担。5.6本服务一旦使用，在协议有效期内原则上用户没有单方中止车联网服务的权利。若您支付费用后取消车联网服务的，CAPSA将不予退还所支付的所有费用。 </p><!--<br/>--><p>6，使用条款CAPSA希望您了解我们收集、记录、使用和分享账户信息、车辆信息和驾驶信息(见下文描述)的方式。使用协议就我们收集、记录、使用、分享和保护该信息的具体操作方法进行约定。6.1收集范围账户信息:例如您的联系方式、账单信息以及您如何使用某些CAPSA服务、访问CAPSA网站、DS 车联网手机APP等信息，以及用于定制新服务或升级原有服务所需的其他相关个人信息车辆信息:例如诊断信息、里程数、胎压、油量、车辆碰撞、车辆定位等信息驾驶信息:例如行车轨迹、速度、点火、熄火和有关车辆使用方式的其他类似信息 设备信息:例如设备型号、操作系统、唯一设备识别码、登录IP地址、设备加速器(如重力感应设备)等信息 日志信息:例如您的搜索内容、IP地址、浏览器类型、访问日期和时间及您访问的网页记录等6.2收集方式为保证服务的质量，我们需按照以下方式收集有关您本人和您车辆的相关信息:在您注册、使用、购买或租赁配有CAPSA设备的车辆时，我们将通过您个人、您所用车辆的经销商等多种渠道收集相关信息；在您使用CAPSA服务时，我们将收集信息； 我们通过您浏览CAPSA网站收集信息(包括cookies和其他相关网页终端)； 我们通过您与我们或我们授权的任何第三方之间的电话或电子邮件沟通收集信息； 我们通过第三方服务提供商或其他业务合作方(如无线服务提供商)收集信息； 通过您车辆内与我们保持连接的CAPSA设备远程收集车辆信息；6.3使用、分享和转让我们承诺不随意使用，不对外公开或向本公司以外第三方提供或分享转让用户注册资料、车辆信息、驾驶信息以及用户存储的非公开内容等相关信息。但是，下列情况中，表示您同意授权本公司使用或与第三方分享您的相关信息: 事先获得您的授权；公安或司法部门按照法律、法规要求本公司提供相关信息； 与公共安全、公共卫生、重大公共利益有关的；与国家安全、国防安全相关的；出于维护您或其他人的生命财产安全等重大合法权益但又难以得到您同意的；为维护公众利益或本公司的合法权益；向您提供您需要的车联网服务，包括网站服务、手机应用服务等并针对服务进行的维护、升级安装和更新等；向您发送本公司的营销广告、促销信息或资料服务、短信服务、车辆维修、车辆保险的信息和数据等；本公司为开发新产品或提升服务质量，例如市场和客户调研；在不透露单个用户隐私资料的前提下，本公司有权对整个用户数据库进行分析并对用户数据库进行商业上的利用；只有透露您的相关资料，才能提供您所要求的产品和服务(当本公司为提供车联网服务而将必要的业务委托给第三方服务提供方时，服务提供方可以在目的范围内使用您的个人信息，同时本公司会要求第三方服务提供方遵守与个人信息有关的法律、法规)；您的经销商，以协助对您的车辆进行维护，进行营销或提供经销商维护保养通知；您要求我们与其共享该信息的其他第三方，例如需要获得信息以向您提供您专门要求或订购的服务的第三方(如您的保险公司或贷款人)；其他第三方，以便促进、加强、改善、或扩展我们的服务或和我们CAPSA服务相关的服务；其他本公司需要或按照法律法规规定对您的信息进行使用或公开的情形； 在您明确同意的情况下转让您的相关信息；根据法律法规、法律程序的要求或强制性的政府要求或司法裁定必须提供；在涉及合并、收购或破产清算时，如涉及到个人信息转让，我们会要求新的持有您个人信息的公司、组织继续受此隐私权政策的约束，否则我们会要求该公司、组织重新向您征求授权同意； 6.4隐私保护及免责6.4.1因您的信息安全对车联网服务至关重要，我们不排除使用技术手段、物理保障措施保护您的信息，并针对相应信息进行严密保存，对收集到的不需要的信息进行匿名处理或其他方法处置。6.4.2我们会使用可靠的安全保护机制防止个人信息遭到各种恶意手段攻击，在网络安全方面，我们会竭尽所能加强安全措施并尽全力保障您的信息安全。6.4.3由于您将用户密码告知他人或与他人共享注册帐户，由此导致的任何个人资料泄露，本公司不承担任何责任。6.5协议更新随着我们业务和CAPSA服务扩展或变更，或根据法律法规的要求，我们可能需要不时对本协议进行更新，具体方式为:我们将在长汽车官方网站上或DS 车联网手机APP上公布最新更新版本，该方式将是我们使您了解该变更的合理和有效的方式。您同意，将定期查看我们是否已做出更新。如您不同意相关更新，须立即以正式书面签字或盖章的通知方式告知CAPSA，CAPSA有权选择终止相关更新或维持更新。如协议更新后，您继续使用车联网服务的，将视为您同意接受更新，更新后协议对您和CAPSA具有法律约束力。 </p><!--<br/>--><p>7，免责说明7.1请在日常行驶中务必遵守国内的交通及道路法律法规，确保安全合法地行车，否则因此造成的一切后果，将由您自行承担。7.2由于如下特殊情况及原因，我们可以在不事先通知您的情况下临时中止提供车联网服务，且不需要承担任何责任(除非相关法律法规另有强制规定):(1)CAPSA在定期或者紧急实施车联网的系统维护，系统升级时；(2)由于发生地震、火灾、洪水等天灾、断电、战争、动乱、暴乱、骚乱等不可抗力而无法提供车联网服务时；(3)其他因CAPSA判定在运营过程及技术上出现需要临时中断车联网服务的情况；(4)国家机关向CAPSA提出相应要求时；(5)其他CAPSA认为需要中止车联网服务的情况。7.3由于信息受无线网络通信的复杂性、计算方式、传输时延等因素影响，信息可能存在不完整或与仪表信息存在差异等问题，CAPSA不对数据的有效性和及时性做出承诺。对其他第三方通过CAPSA车联网提供的服务也不做任何保证。因提供服务内容发生延迟、错误或中断对您造成的损失，除非相关法规另有强制规定，否则CAPSA对此造成的任何损失不负责任。7.4如果您在您的车辆上自行安装任何硬件设备，或者对您的车辆进行改装或改造，或其他您人为原因导致车联网服务车载设备受损，均可能导致本服务无法正常运行与使用，CAPSA不对因此产生的损害承担任何责任。7.5我们提供的导航路线和整车定位服务来源于我们可以获得的最新地图信息。但局限于地图技术的发展，该导航路线和定位功能可能存在某些差错或遗漏，给您造成的损失，CAPSA不承担赔偿责任。7.6 CAPSA在您车辆被盗的情况下，经过您和公安机关的授权许可下，可协助提供车辆位置信息、行驶轨迹、发动机禁止启动等服务。车辆位置、行驶轨迹等信息需要取得您本人的授权才能获取，但若因车辆TBOX被拔出或发生故障、地图存在差错，或信号受阻等其他不可控因素影响服务提供，给您造成的损失，CAPSA不承担赔偿责任，我们采用严格的技术手段及人工甄别的方式确保用户隐私的安全，但由于用户本人手机丢失或身份证信息等个人隐私数据泄露造成的损失，我们不承担任何责任。发动机禁止启动指令在您本人通过厂家的身份验证，向CAPSA呼叫中心提供车辆被盗立案证明，我们在确认报案信息真实性并获得公安机关授权的情况下，可对您的车辆下达发动机禁止启动的指令(该指令在车辆行驶中无法生效，当车辆熄火后车辆无法再次启动)，但若因此给您或他人造成的损失，CAPSA不承担赔偿责任。7.7 当车联网服务注册车辆发生指定使用者更换、二手车交易时，您有义务根据CAPSA规定的流程对注册账户退款联系我们，我们将继续沿用前车主所备案的信息，继续向前车主注册使用的DS 车联网手机APP账户发送车况检测报告和其他服务信息，且仍将向前任车主收取与注册车辆相关的服务费等费用。而且，对于此项问题等产生隐私泄露问题，或其他法律纠纷，CAPSA概不负责。7.8 CAPSA仅作为您或您的车辆与第三方服务提供商之间的联络桥梁。第三方服务提供商和CAPSA为互相独立的实体。我们无法确保所有的第三方服务提供商都会响应或都能及时响应服务请求，也不能承担由于第三方服务提供商能否响应以及能否及时响应服务请求所产生的责任。7.9基于呼叫中心的服务，如:协助查询目的地，下发目的地导航等，若因网络问题导致下发失败或错误，或者车机无信号时，导致该功能失效，我们不承担任何责任。7.10 您可以通过车机上的“一键呼叫按钮，选择使用B-CALL道路救援服务。当您使用该服务时，道路救援业务由实际的服务提供方实施，救援所产生的费用由您和服务提供方协商，由此产生的所有争议与CAPSA无关7.11 您可以通过车机上的“一键呼按钮，选择使用iCALL服务。用户可以通过iCALL进行机票、酒店、门票、餐饮的预订服务，预订所产生的费用及具体服务内容由您和预定服务提供方进行协商，由此产生的费用由您承担。7.12 CAPSA在接到紧急救援请求后可以帮您代为联系紧急服务提供方，提供医疗救援、车辆救援等服务。紧急救援请求会在车辆发生碰撞事故安全气囊爆开或用户主动按下SOS按键(前排顶部控制面板的红色按钮)时触发，CAPSA呼叫中心在收到紧急救援请求后将与您确认是否需要代为联系紧急服务提供方。如通过车辆通讯装置和您的个人电话都无法和您建立有效的联系，我们将联系您预设的紧急情况联系人，如我们无法与您预设的紧急情况联系人建立有效的联系或您未预设紧急情况联系人，我们会视您已发生紧急情况需要紧急救援，将直接帮您代为联系紧急服务提供方。紧急救援所产生的费用由您和服务提供方协商，CAPSA不承担救援过程中出现的人员伤情过重导致死亡的责任。</p><!--<br/>--><p>8,适用法律及合同纠纷的解决8.1 本协议的订立、履行及争议的解决均适用中华人民共和国法律。8.2 因本协议引起或与本协议有关的任何争议，双方未能通过友好协商进行解决，双方同意将该争议提交仲裁而非诉讼。仲裁应提交到中国国际经济贸易仲裁委员会华南分会。</p><!--<br/>--><p>9, 其他事项9.1 本协议最终解释权归长安标致雪铁龙汽车有限公司销售分公司所有。9.2 在您确认接受本协议之前，已仔细阅读并充分理解了本协议的每一条款，包括车辆配置清单，DS车联网服务内容等文件，本协议一经您签署，或接受之日起生效。</p>";
    
    NSString *htmlStr = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><title>webview</title></head><body>%@%@</body></html>",cssStr,htmlString];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil] ;
    
        _contentlabel.textColor = [UIColor whiteColor];
        _contentlabel.backgroundColor = [UIColor colorWithHexString:@"#120F0E"];
    
        _contentlabel.editable = NO;
//        _contentlabel.attributedText = attributedString;
        _contentlabel.text= content;
        [line addSubview:_contentlabel];
        [_contentlabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0 * WidthCoefficient);
            make.bottom.equalTo(0);
            make.left.equalTo(0 * WidthCoefficient);
            make.top.equalTo(50 * HeightCoefficient);
        }];
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 2;
    [nextBtn setTitle:NSLocalizedString(@"同意", nil) forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont fontWithName:FontName size:16];
    [nextBtn setBackgroundColor:[UIColor colorWithHexString:GeneralColorString]];
    [self.view addSubview:nextBtn];
    [nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(271 * WidthCoefficient);
        make.height.equalTo(44 * HeightCoefficient);
        make.centerX.equalTo(0);
        make.top.equalTo(line.bottom).offset(30 * HeightCoefficient);
    }];
    
}

-(void)nextBtnClick:(UIButton *)btn
{

    [self dismissViewControllerAnimated:NO completion:^{
        self.callBackBlocks(@"同意");
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
