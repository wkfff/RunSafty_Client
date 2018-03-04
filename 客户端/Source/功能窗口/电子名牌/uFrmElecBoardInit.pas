unit uFrmElecBoardInit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLabel, ComCtrls, RzListVw, uElecnameBoardControl,
  RzPanel, ExtCtrls, RzTabs, Buttons, PngSpeedButton, uLine, uTrainmanJiaolu,
  ImgList, uStation, uBoardBaseInfo, uTrainman, Menus, uDBTrainmanJiaolu,
  RzButton,uSaftyEnum;

const WM_USER_UPDATEJIAOLU_INIT = WM_USER + $1001; //交换结果
type
  /// <summary>当前鼠标所在电子名牌区域类型</summary>
  TCursorPosInBoard = (csd_unKnown{全不在},csd_Up{上方电子名牌},csd_Down{下方电子名称});
  TFrmElecBoardInit = class(TForm)
    rztbcntrlLine: TRzTabControl;
    rzpnlBack: TRzPanel;
    rzgrpbxStart: TRzGroupBox;
    elcnmbrdcntrlStart: TElecnameBoardControl;
    lvJiBanJiaoLu: TRzListView;
    lbl1: TRzLabel;
    rzgrpbxEnd: TRzGroupBox;
    elcnmbrdcntrlEnd: TElecnameBoardControl;
    rzpnlTool: TRzPanel;
    ilJL: TImageList;
    pmBoard: TPopupMenu;
    pmAddUser: TMenuItem;
    pmDeleteUser: TMenuItem;
    pmSep1: TMenuItem;
    pmAddGroup: TMenuItem;
    pmDeleteGroup: TMenuItem;
    pmSep2: TMenuItem;
    pmAskLeave: TMenuItem;
    pmComeBack: TMenuItem;
    pmSep3: TMenuItem;
    pmAddJiCheAdd: TMenuItem;
    pmDeleteJiCheDel: TMenuItem;
    mmElecBoard: TMainMenu;
    pmSep4: TMenuItem;
    pmSetWork: TMenuItem;
    N1: TMenuItem;
    mmExit: TMenuItem;
    N2: TMenuItem;
    mmUpdate: TMenuItem;
    mmAskLeave: TMenuItem;
    mmSickLeave: TMenuItem;
    mmSetWork: TMenuItem;
    rztlbr1: TRzToolbar;
    btnRefresh: TPngSpeedButton;
    btnAskLeave: TPngSpeedButton;
    btnSickLeave: TPngSpeedButton;
    btnSetWork: TPngSpeedButton;
    btnAdd: TRzMenuToolbarButton;
    btnDelete: TRzMenuToolbarButton;
    btnClose: TPngSpeedButton;
    pmAdd: TPopupMenu;
    pmToolBarAddLoco: TMenuItem;
    pmToolBarAddGroup: TMenuItem;
    pmToolBarAddUser: TMenuItem;
    pmDelete: TPopupMenu;
    pmToolBarDelLoco: TMenuItem;
    pmToolBarDelGroup: TMenuItem;
    pmToolBarDelUser: TMenuItem;
    N3: TMenuItem;
    mmAdd: TMenuItem;
    mmDel: TMenuItem;
    mmAddLoco: TMenuItem;
    mmAddGroup: TMenuItem;
    mmAddUser: TMenuItem;
    mmDelLoco: TMenuItem;
    mmDelGroup: TMenuItem;
    mmDelUser: TMenuItem;
    procedure FormResize(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure lvJiBanJiaoLuClick(Sender: TObject);
    procedure rztbcntrlLineClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    function elcnmbrdcntrlStartExchangeItemEvent(FirstItem,
      SeconddItem: TElecBoardGroupInfo): Boolean;
    procedure pmAddUserClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pmAddGroupClick(Sender: TObject);
    procedure pmAddJiCheAddClick(Sender: TObject);
    procedure pmDeleteJiCheDelClick(Sender: TObject);
    procedure pmDeleteGroupClick(Sender: TObject);
    procedure pmDeleteUserClick(Sender: TObject);
    function elcnmbrdcntrlEndExchangeItemEvent(FirstItem,
      SeconddItem: TElecBoardGroupInfo): Boolean;
    procedure elcnmbrdcntrlStartMouseSelectObjEvent(Button: TMouseButton;
      selGroupObj: TElecBoardGroupInfo; Shift: TShiftState; X, Y: Integer);
    procedure elcnmbrdcntrlEndMouseSelectObjEvent(Button: TMouseButton;
      selGroupObj: TElecBoardGroupInfo; Shift: TShiftState; X, Y: Integer);
    procedure pmAskLeaveClick(Sender: TObject);
    procedure pmComeBackClick(Sender: TObject);
    procedure pmSetWorkClick(Sender: TObject);
    procedure mmExitClick(Sender: TObject);
    procedure btnAskLeaveClick(Sender: TObject);
    procedure btnSickLeaveClick(Sender: TObject);
    procedure btnSetWorkClick(Sender: TObject);
    procedure mmAskLeaveClick(Sender: TObject);
    procedure mmSickLeaveClick(Sender: TObject);
    procedure mmSetWorkClick(Sender: TObject);
    procedure pmToolBarAddLocoClick(Sender: TObject);
    procedure pmToolBarDelLocoClick(Sender: TObject);
    procedure pmToolBarAddGroupClick(Sender: TObject);
    procedure pmToolBarAddUserClick(Sender: TObject);
    procedure pmToolBarDelGroupClick(Sender: TObject);
    procedure pmToolBarDelUserClick(Sender: TObject);
    procedure mmAddLocoClick(Sender: TObject);
    procedure mmAddGroupClick(Sender: TObject);
    procedure mmAddUserClick(Sender: TObject);
    procedure mmDelLocoClick(Sender: TObject);
    procedure mmDelGroupClick(Sender: TObject);
    procedure mmDelUserClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    m_dbTrainmanJiaoLu:TDBTrainmanJiaolu;
    /// <summary>线路信息</summary>
    m_LineAry:TLineArray;
    /// <summary>人员交路数组</summary>
    m_TrainJiaoLuAry:TTrainmanJiaoluArray;

    /// <summary>记名式交路临时存储信息</summary>
    m_NamedGroupAry:TNamedGroupArray;
    /// <summary>轮乘交路临时存储信息</summary>
    m_OrderGroupAry:TOrderGroupArray;
    /// <summary>包乘交路临时存储信息</summary>
    m_TogetherTrainAry:TTogetherTrainArray;
    /// <summary>非运转模式或预备模式人员信息</summary>
    m_OtherGroupAry:TOtherGroupArray;

    /// <summary>预备模式下的车站信息</summary>
    m_PreStationAry:TStationArray;

    /// <summary>开始站选中对象</summary>
    m_SelectedObjStart:TElecBoardGroupInfo;
    /// <summary>结束站选中对象</summary>
    m_SelectedObjEnd:TElecBoardGroupInfo;
    m_ElecBoardPos:TCursorPosInBoard;
  private
    /// <summary>功能:获取将要进行操作的电子名牌位置</summary>
    function GetSelectElecCtrlPos:TCursorPosInBoard;
    procedure SetOptBtnState(bState:Boolean);
    procedure SetPopupMenuMainVisible(bVisible:Boolean);
    /// <summary>功能:获取人员的提示信息  </summary>
    function FormatTrainmanHintsInfo(trainman:RTrainman):string;
    /// <summary>功能:获取轮乘交路下人员的提示信息  </summary>
    function FormatOrderHintsInfo(group:RGroup;nUserIndex:Integer):string;
    /// <summary>功能:获取记名式交路下人员的提示信息  </summary>
    function FormatNamedHintsInfo(group:RNamedGroup;nUserIndex:Integer):string;
    /// <summary>功能:获取包乘交路下人员的提示信息  </summary>
    function FormatTogetherHintsInfo(group:RTogetherTrain;nUserGroupIndex,nUserIndex:Integer):string;
    /// <summary>功能:获取预备人员提示信息  </summary>
    function FormatReadyHintsInfo(readyUser:ROherGroup):string;
    /// <summary>功能:删除轮乘模式下的机班</summary>
    procedure DelOrderGroup;
    /// <summary>功能:删除记名式交路模式下的机班</summary>
    procedure DelNamedGroup;
    /// <summary>功能:删除包乘模式下的机班</summary>
    procedure DelTogetherGroup;
    /// <summary>功能:删除非运转模式下人员</summary>
    procedure DelUnRunUser;
    /// <summary>功能:删除预备模式下人员</summary>
    procedure DelReadyUser;
    /// <summary>功能:添加轮乘模式下的机班</summary>
    procedure AddOrderGroup;
    /// <summary>功能:添加记名式交路模式下的机班</summary>
    procedure AddNamedGroup;
    /// <summary>功能:添加包乘模式下的机班</summary>
    procedure AddTogetherGroup;
    /// <summary>功能:添加非运转模式下人员</summary>
    procedure AddUnRunUser;
    /// <summary>功能:添加预备模式下人员</summary>
    procedure AddReadyUser;
    /// <summary>功能:手动添加人员</summary>
    /// <param name="jlType">所属人员交路类型</param>
    /// <param name="elecBoardPos">电子名牌位置</param>
    procedure ManualAddUser(jlType:TJiaoluType;elecBoardPos:TCursorPosInBoard);
    /// <summary>功能:手动删除人员</summary>
    /// <param name="jlType">所属人员交路类型</param>
    /// <param name="elecBoardPos">电子名牌位置</param>
    procedure ManualDeleteUser(jlType:TJiaoluType;elecBoardPos:TCursorPosInBoard);
    /// <summary>功能:获取添加人员时的所属机班组和人员的位置</summary>
    procedure GetSelectedGroup(jlType:TJiaoluType;elecBoardPos:TCursorPosInBoard;
      out groupInfo:TTurnGroupInfo;out nUserIndex:Integer);
    procedure AddUserToGroupList(group: TTurnGroupInfo; Trainman:RTrainman);
    procedure SetUserInfoOfGroupList(user:TElecBoardUserInfo;trainman:RTrainman);
    /// <summary>功能:更新线路信息</summary>
    procedure UpdateLines;
    /// <summary>功能:更新人员交路列表信息</summary>
    procedure UpdateJiaoLus(strLineGUID:string);   
    procedure UpdateJiaoLuInfo(strJLGUID:string; jlType: TJiaoluType;bIsActive:Boolean = False);
    /// <summary>功能:读取记名式交路信息,并将其更新至电子名牌控件中</summary>
    procedure UpdateNamedBaseInfo(strJLGUID:string);
    /// <summary>功能:读取轮乘交路信息,并将其更新至电子名牌控件中</summary>
    procedure UpdateOrderBaseInfo(strJLGUID:string);
    /// <summary>功能:读取包乘交路信息,并将其更新至电子名牌控件中</summary>
    procedure UpdateTogetherBaseInfo(strJLGUID:string);
    /// <summary>功能:获取预备模式下车站信息</summary>
    procedure UpdatePrepareStations(strJLGUID:string;bIsActive:Boolean = False);
    /// <summary>功能:更新非运转人员交路信息</summary>
    procedure UpdateNoWorkBaseInfo(strJLGUID:string);
    /// <summary>功能:更新</summary>
    procedure ReadOtherBaseInfo(strJLGUID:string);
    /// <summary>功能:非包乘模式下选择对象交换</summary>
    function ExchangeUnTogetherObj(FirstItem,SeconddItem: TElecBoardGroupInfo;
      jlType: TJiaoluType):Boolean;

    procedure OnUpdateJiaoLu(var msg:TMessage);message WM_USER_UPDATEJIAOLU_INIT;
  public
    { Public declarations }
  end;

implementation
uses
  uGlobalDM, uDBLine, uFrmAddUser, uFrmAddGroup, uFrmAddCheCi, uFrmAddJiChe,
  uFrmAskLeave, uAskForLeave, uTFSystem, uSickLeave, uFrmSickLeave,
  uFrmSetWork, uFrmSelectStation;

{$R *.dfm}

procedure TFrmElecBoardInit.btnAskLeaveClick(Sender: TObject);
var
  jlInfo:RTrainmanJiaolu;
  frmStation:TFrmSelectStation;
begin
  m_ElecBoardPos := csd_Up;
  jlInfo := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index];
  if jlInfo.nJiaoluType = jltOrder then
  begin
    frmStation := TFrmSelectStation.Create(Self);
    try
      frmStation.StartStation := jlInfo.strStartStationName;
      frmStation.EndStation := jlInfo.strEndStationName;
      if frmStation.ShowModal <> mrOk then
        Exit;
      if frmStation.SelectStation = jlInfo.strEndStationName then
          m_ElecBoardPos := csd_Down;
    finally
      FreeAndNil(frmStation);
    end;
  end;

  pmAskLeaveClick(Sender);
end;

procedure TFrmElecBoardInit.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmElecBoardInit.btnRefreshClick(Sender: TObject);
begin
  UpdateLines;
end;

procedure TFrmElecBoardInit.btnSetWorkClick(Sender: TObject);
var
  jlInfo:RTrainmanJiaolu;
  frmStation:TFrmSelectStation;
begin
  m_ElecBoardPos := csd_Up;
  jlInfo := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index];
  if jlInfo.nJiaoluType = jltOrder then
  begin
    frmStation := TFrmSelectStation.Create(Self);
    try
      frmStation.StartStation := jlInfo.strStartStationName;
      frmStation.EndStation := jlInfo.strEndStationName;
      if frmStation.ShowModal <> mrOk then
        Exit;
      if frmStation.SelectStation = jlInfo.strEndStationName then
          m_ElecBoardPos := csd_Down;  
    finally
      FreeAndNil(frmStation);
    end;
  end;
  pmSetWorkClick(Sender);
end;

procedure TFrmElecBoardInit.btnSickLeaveClick(Sender: TObject);
var
  jlInfo:RTrainmanJiaolu;
  frmStation:TFrmSelectStation;
begin
  m_ElecBoardPos := csd_Up;
  jlInfo := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index];
  if jlInfo.nJiaoluType = jltOrder then
  begin
    frmStation := TFrmSelectStation.Create(Self);
    try
      frmStation.StartStation := jlInfo.strStartStationName;
      frmStation.EndStation := jlInfo.strEndStationName;
      if frmStation.ShowModal <> mrOk then
        Exit;
      if frmStation.SelectStation = jlInfo.strEndStationName then
          m_ElecBoardPos := csd_Down;  
    finally
      FreeAndNil(frmStation);
    end;
  end;
  pmComeBackClick(Sender);
end;

procedure TFrmElecBoardInit.DelNamedGroup;
var
  strGroupGUID,strJLGUID:string;
begin
//  if not Assigned(m_SelectedObjStart) then
//  begin
//    MessageBox(Handle,'请选择要删除的班组','提示',MB_ICONINFORMATION);
//    Exit;
//  end;
//  if MessageBox(Handle,'您确定要删除吗?','请问',
//    MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) <> mrYes then
//    Exit;
//  strGroupGUID := '';
//  strJLGUID := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strTrainmanJiaoluGUID;
//  case m_ElecBoardPos of
//    csd_Up:
//      strGroupGUID := TCheckRailGroupInfo(m_SelectedObjStart).Key;
//    csd_Down:
//      strGroupGUID := TCheckRailGroupInfo(m_SelectedObjEnd).Key;
//  end;
//  if '' = Trim(strGroupGUID) then
//    raise Exception.Create('没有找到要删除的班组');
//  if m_dbTrainmanJiaoLu.DeleteNamedGroup(GlobalDM.ADOConnection,strGroupGUID) then
//  begin
////    MessageBox(Handle,'删除班组成功','恭喜您',MB_OK);
//    PostMessage(Handle,WM_USER_UPDATEJIAOLU_INIT,1,0);
//  end
//  else
//    MessageBox(Handle,'删除班组失败','很遗憾',MB_ICONERROR);
end;

procedure TFrmElecBoardInit.DelOrderGroup;
var
  strGroupGUID,strJLGUID:string;
  group:TElecBoardGroupInfo;
begin
//  case m_ElecBoardPos of
//    csd_Up:
//      group := m_SelectedObjStart;
//    csd_Down:
//      group := m_SelectedObjEnd;
//  end;
//  if ( not Assigned(group) ) or (group.Key = '') then
//  begin
//    MessageBox(Handle,'请选择要删除的班组','提示',MB_ICONINFORMATION);
//    Exit;
//  end;
//    
//  if MessageBox(Handle,'您确定要删除吗?','请问',
//    MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) <> mrYes then
//    Exit;
//
//  strGroupGUID := '';
//  strJLGUID := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strTrainmanJiaoluGUID;
//      
//  strGroupGUID := group.Key;
//  if m_dbTrainmanJiaoLu.DeleteOrderGroup(GlobalDM.ADOConnection,strGroupGUID) then
//  begin
////    MessageBox(Handle,'删除班组成功','恭喜您',MB_OK);
//    PostMessage(Handle,WM_USER_UPDATEJIAOLU_INIT,1,0);
//  end
//  else
//    MessageBox(Handle,'删除班组失败','很遗憾',MB_ICONERROR);
end;

procedure TFrmElecBoardInit.DelReadyUser;
var
  strGroupGUID,strJLGUID:string;
  jlInfo:RTrainmanJiaolu;
begin    
  if MessageBox(Handle,'您确定要删除吗?','请问',
    MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) <> mrYes then
    Exit;
  strGroupGUID := '';
  strJLGUID := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strTrainmanJiaoluGUID;
  case m_ElecBoardPos of
    csd_Up:
      strGroupGUID := TTurnGroupInfo(m_SelectedObjStart).Key;
    csd_Down:
      strGroupGUID := TTurnGroupInfo(m_SelectedObjEnd).Key;
  end;
  if '' = Trim(strGroupGUID) then
    raise Exception.Create('没有找到要删除的人员');
  jlInfo := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index];
  if m_dbTrainmanJiaoLu.DeleteTrainmanFromOther(GlobalDM.ADOConnection,jlInfo.nJiaoluType,strGroupGUID) then
  begin
    UpdateJiaoLuInfo(strJLGUID,jlInfo.nJiaoluType);
    UpdatePrepareStations(strJLGUID);
//    MessageBox(Handle,'删除预备人员成功','恭喜您',MB_OK);
  end
  else
    MessageBox(Handle,'删除预备人员失败','很遗憾',MB_ICONERROR);
end;

procedure TFrmElecBoardInit.DelTogetherGroup;
var
  strGroupGUID,strJLGUID:string;
  group:ROrderGroupInTrain;
begin
//  if not Assigned(m_SelectedObjStart) then
//  begin
//    MessageBox(Handle,'请选择要删除的班组','提示',MB_ICONINFORMATION);
//    Exit;
//  end;
//  if (TContractGroupInfo(m_SelectedObjStart).ChildGroupList.Count = 1) and
//    (Trim(TContractGroupInfo(m_SelectedObjStart).ChildGroupList.Items[0].UserList.Items[0].strGongHao) = '') and
//    (Trim(TContractGroupInfo(m_SelectedObjStart).ChildGroupList.Items[0].UserList.Items[1].strGongHao) = '') and
//    (Trim(TContractGroupInfo(m_SelectedObjStart).ChildGroupList.Items[0].UserList.Items[2].strGongHao) = '') then
//  begin
//    MessageBox(Handle,'该机车内包乘班组已为空,不能再进行删除!','警告',MB_ICONWARNING);
//    Exit;
//  end;
//
//  if MessageBox(Handle,'您确定要删除吗?','请问',
//    MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) <> mrYes then
//    Exit;
//  if (not Assigned(m_SelectedObjStart)) or
//    (TContractGroupInfo(m_SelectedObjStart).ActiveUserGroupIndex < 0) then
//    raise Exception.Create('请选择要删除的包乘班组');
//  strJLGUID := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strTrainmanJiaoluGUID;
//  strGroupGUID := TContractGroupInfo(m_SelectedObjStart).ChildGroupList.Items[
//    TContractGroupInfo(m_SelectedObjStart).ActiveUserGroupIndex].Key;
//    
//  FillChar(group,SizeOf(ROrderGroupInTrain),0);
//
//  group.Group.Station.strStationGUID := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strStartStationGUID;
//  group.Group.Station.strStationName := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strTrainmanJiaoluName;
//  group.strOrderGUID := NewGUID;
//  group.strTrainGUID := TContractGroupInfo(m_SelectedObjStart).Key;
//  group.nOrder := 0;
//  group.Group.strGroupGUID := NewGUID;
//  group.Group.Trainman1.nPostID := ptTrainman;
//  group.Group.Trainman2.nPostID := ptSubTrainman;
//  group.Group.Trainman3.nPostID := ptLearning;
//
//  if m_dbTrainmanJiaoLu.DeleteTogetherGroup(GlobalDM.ADOConnection,strGroupGUID) then
//  begin
//    if TContractGroupInfo(m_SelectedObjStart).ChildGroupList.Count = 1 then
//      m_dbTrainmanJiaoLu.AddGroupToTrain(GlobalDM.ADOConnection,group.strTrainGUID,
//        group);  
//    
////    MessageBox(Handle,'删除包乘班组成功','恭喜您',MB_OK);
//    PostMessage(Handle,WM_USER_UPDATEJIAOLU_INIT,1,0);
//  end
//  else
//    MessageBox(Handle,'删除包乘班组失败','非常遗憾',MB_ICONERROR);
end;

procedure TFrmElecBoardInit.DelUnRunUser;
var
  strGroupGUID,strJLGUID:string;
begin   
  if MessageBox(Handle,'您确定要删除吗?','请问',
    MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) <> mrYes then
    Exit;
  strGroupGUID := '';
  strJLGUID := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strTrainmanJiaoluGUID;
  case m_ElecBoardPos of
    csd_Up:
      strGroupGUID := TTurnGroupInfo(m_SelectedObjStart).Key;
    csd_Down:
      strGroupGUID := TTurnGroupInfo(m_SelectedObjEnd).Key;
  end;
  if '' = Trim(strGroupGUID) then
    raise Exception.Create('没有找到要删除的对象');

  if m_dbTrainmanJiaoLu.DeleteTrainmanFromOther(GlobalDM.ADOConnection,
    m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType,strGroupGUID) then
  begin
//    MessageBox(Handle,'删除非运转人员成功','恭喜您',MB_OK);
    PostMessage(Handle,WM_USER_UPDATEJIAOLU_INIT,1,0);
  end
  else
    MessageBox(Handle,'删除非运转人员失败','很遗憾',MB_ICONERROR);
end;

function TFrmElecBoardInit.elcnmbrdcntrlEndExchangeItemEvent(FirstItem,
  SeconddItem: TElecBoardGroupInfo): Boolean;
var
  jlInfo:RTrainmanJiaolu;
begin
  Result := False;
  jlInfo := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index];
  if MessageBox(Handle,'您确定要对选中的对象进行交换吗?','请问',
    MB_ICONQUESTION OR MB_YESNO OR MB_DEFBUTTON2) <> mrYes then
      Exit;
  Result := ExchangeUnTogetherObj(FirstItem,SeconddItem,jlInfo.nJiaoluType);
  if Result then
  begin
//    MessageBox(Handle,'交换成功','恭喜您',MB_OK);
    PostMessage(Handle,WM_USER_UPDATEJIAOLU_INIT,1,0);
  end
  else
    MessageBox(Handle,'交换失败','非常遗憾',MB_ICONERROR);
end;

procedure TFrmElecBoardInit.elcnmbrdcntrlEndMouseSelectObjEvent(
  Button: TMouseButton; selGroupObj: TElecBoardGroupInfo; Shift: TShiftState; X,
  Y: Integer);
var
  I,nIndex:Integer;
  bFlag:Boolean;
  strHints:string;  
  pt:TPoint;
begin
  bFlag := False;
  if Assigned(selGroupObj) then  
    m_SelectedObjEnd := selGroupObj;
  nIndex := 0;
  if Assigned(selGroupObj) then
  begin
    for I := 0 to Length(m_OrderGroupAry) - 1 do
    begin
      if Trim(selGroupObj.Key) = Trim(m_OrderGroupAry[I].Group.strGroupGUID) then
      begin
        nIndex := I;
        bFlag := True;
        Break;
      end;
    end;

    if not bFlag then
      Exit;
    strHints := FormatOrderHintsInfo(m_OrderGroupAry[nIndex].Group,
      selGroupObj.ActiveUserIndex);
    if '' = strHints then
      elcnmbrdcntrlEnd.ShowHint := False
    else
    begin
      elcnmbrdcntrlEnd.Hint := strHints;
      elcnmbrdcntrlEnd.ShowHint := True;
    end;

    elcnmbrdcntrlEnd.ShowHint := False;
  end;
  if Button = mbRight then
  begin
    if not Assigned(lvJiBanJiaoLu.Selected) then
      Exit;

    case m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType of
      jltUnrun,
      jltReady,
      jltOrder,
      jltNamed:
      begin
        SetPopupMenuMainVisible(True);
        pmAddJiCheAdd.Visible := False;
        pmDeleteJiCheDel.Visible := False;
        pmSep1.Visible := False;
        pmComeBack.Visible := False;
      end;
      jltTogether:
      begin
        SetPopupMenuMainVisible(False);
        pmAddJiCheAdd.Visible := True;
        pmDeleteJiCheDel.Visible := True;
        pmSep1.Visible := True;   
        pmSep4.Visible := True;
        pmSetWork.Visible := True;
      end;
    end;

    if not Assigned(selGroupObj) then
    begin
      pmDeleteJiCheDel.Visible := False;
      pmDeleteGroup.Visible := False;
      pmDeleteUser.Visible := False;
      pmSep3.Visible := False;
      pmAskLeave.Visible := False;
      pmComeBack.Visible := False;
      pmAddUser.Visible := False;        
      pmSep4.Visible := False;
      pmSetWork.Visible := False;
    end;
    pt.X := X + rzgrpbxEnd.Left + rzpnlBack.Left;
    pt.Y := Y + rzgrpbxEnd.Top + rzpnlBack.Top + rztbcntrlLine.Height;
    m_ElecBoardPos := csd_Down;
    pmBoard.Popup(pt.X, pt.Y);
  end;
end;

function TFrmElecBoardInit.elcnmbrdcntrlStartExchangeItemEvent(FirstItem,
  SeconddItem: TElecBoardGroupInfo): Boolean;
var
  jlInfo:RTrainmanJiaolu;
  strGroup1,strGroup2,strUser1,strUser2:string;
  bFlag :Boolean;
begin
//  Result := False;
//  if not Assigned(lvJiBanJiaoLu.Selected) then
//    raise Exception.Create('请选择人员交路');
//  jlInfo := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index];
//  if ((FirstItem.ActiveUserIndex and  SeconddItem.ActiveUserIndex ) < 0) and
//    ((FirstItem.ActiveUserIndex or SeconddItem.ActiveUserIndex) > 0) then
//    raise Exception.Create('交换对象等级不匹配');
//
//  if jlInfo.nJiaoluType = jltTogether then
//  begin
//    // 包乘模式
//    if (TContractGroupInfo(FirstItem).ActiveUserGroupIndex and
//      TContractGroupInfo(SeconddItem).ActiveUserGroupIndex) < 0 then
//      raise Exception.Create('请选择要交换的对象');
//
//    if MessageBox(Handle,'您确定要对选中的对象进行交换吗?','请问',
//      MB_ICONQUESTION OR MB_YESNO OR MB_DEFBUTTON2) <> mrYes then
//        Exit;
//
//    strGroup1 := TContractGroupInfo(FirstItem).ChildGroupList.Items[
//      TContractGroupInfo(FirstItem).ActiveUserGroupIndex].Key;
//    strgroup2 := TContractGroupInfo(SeconddItem).ChildGroupList.Items[
//      TContractGroupInfo(SeconddItem).ActiveUserGroupIndex].Key;
//    if FirstItem.ActiveUserIndex < 0 then
//    begin
//      bFlag := m_dbTrainmanJiaoLu.ExchangeGroup(GlobalDM.ADOConnection,jlInfo.nJiaoluType,
//        strGroup1,strGroup2);
//    end
//    else
//    begin
//      strUser1 := TContractGroupInfo(FirstItem).ChildGroupList.Items[
//        TContractGroupInfo(FirstItem).ActiveUserGroupIndex].UserList.Items[
//        TContractGroupInfo(FirstItem).ActiveUserIndex].Key;
//      strUser2 := TContractGroupInfo(SeconddItem).ChildGroupList.Items[
//        TContractGroupInfo(SeconddItem).ActiveUserGroupIndex].UserList.Items[
//        TContractGroupInfo(SeconddItem).ActiveUserIndex].Key;
//
//      if (strUser1 = '') and (strUser2 = '') then
//        raise Exception.Create('两个空的人员不能进行交换');
//      if strUser1 = '' then      
//        bFlag := m_dbTrainmanJiaoLu.ExchangePerson(GlobalDM.ADOConnection,
//          strUser2,strUser1,strGroup1,
//          TContractGroupInfo(FirstItem).ActiveUserIndex + 1)
//      else
//        bFlag := m_dbTrainmanJiaoLu.ExchangePerson(GlobalDM.ADOConnection,
//          strUser1,strUser2,strGroup2,
//          TContractGroupInfo(SeconddItem).ActiveUserIndex + 1);
//    end;
//  end
//  else
//  begin
//    // 其它模式
//    if MessageBox(Handle,'您确定要对选中的对象进行交换吗?','请问',
//      MB_ICONQUESTION OR MB_YESNO OR MB_DEFBUTTON2) <> mrYes then
//        Exit;
//    bFlag := ExchangeUnTogetherObj(FirstItem,SeconddItem,jlInfo.nJiaoluType);
//  end;
//  Result := bFlag;
//  if bFlag then
//  begin
////    MessageBox(Handle,'交换成功','恭喜您',MB_OK);
//    PostMessage(Handle,WM_USER_UPDATEJIAOLU_INIT,1,0);
//  end
//  else
//    MessageBox(Handle,'交换失败','非常遗憾',MB_ICONERROR);
end;

procedure TFrmElecBoardInit.elcnmbrdcntrlStartMouseSelectObjEvent(
  Button: TMouseButton; selGroupObj: TElecBoardGroupInfo; Shift: TShiftState; X,
  Y: Integer);
var
  jlType:TJiaoluType;
  strHints:string;
  I,nIndex:Integer;
  bFlag :Boolean;
  pt:TPoint;
begin
  if Assigned(selGroupObj) then
    m_SelectedObjStart := selGroupObj;
  if not Assigned(lvJiBanJiaoLu.Selected) then
    Exit;
  
  jlType := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType ;
  if Assigned(selGroupObj) and (selGroupObj.ActiveUserIndex >= 0) then
  begin
    bFlag := False;
    case jlType of
      jltUnrun:  strHints := FormatTrainmanHintsInfo(m_OtherGroupAry[selGroupObj.nIndex].Trainman);
      jltReady:
        begin
          for I := 0 to Length(m_OtherGroupAry) - 1 do
          begin
            if Trim(selGroupObj.Key) = Trim(m_OtherGroupAry[I].Trainman.strTrainmanGUID) then
            begin
              nIndex := I;
              bFlag := True;
              Break;
            end;
          end;
          if not bFlag  then
            Exit;           
          strHints := FormatReadyHintsInfo(m_OtherGroupAry[nIndex]);
        end;
      jltNamed:
        strHints := FormatNamedHintsInfo(m_NamedGroupAry[selGroupObj.nIndex],
          selGroupObj.ActiveUserIndex);
      jltOrder:
        begin
          for I := 0 to Length(m_OrderGroupAry) - 1 do
          begin
            if Trim(selGroupObj.Key) = Trim(m_OrderGroupAry[I].Group.strGroupGUID) then
            begin
              nIndex := I;
              bFlag := True;
              Break;
            end;
          end;

          if not bFlag then
            Exit;           
          strHints := FormatOrderHintsInfo(m_OrderGroupAry[nIndex].Group,
            selGroupObj.ActiveUserIndex);
        end;
      jltTogether:
        strHints := FormatTogetherHintsInfo(m_TogetherTrainAry[selGroupObj.nIndex],
          TContractGroupInfo(selGroupObj).ActiveUserGroupIndex,
          selGroupObj.ActiveUserIndex);
    end;
    if '' = strHints then
      elcnmbrdcntrlStart.ShowHint := False
    else
    begin
      elcnmbrdcntrlStart.Hint := strHints;
      elcnmbrdcntrlStart.ShowHint := True;
    end;
  end;

  elcnmbrdcntrlStart.ShowHint := False;
  if Button = mbRight then
  begin
    case m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType of
      jltUnrun:
      begin
        SetPopupMenuMainVisible(False);
        pmComeBack.Visible := True;
        pmDeleteUser.Visible := True;
        pmAddUser.Visible := True;
      end;
      jltReady:
      begin
        SetPopupMenuMainVisible(False);
      end;
      jltOrder,
      jltNamed:
      begin
        SetPopupMenuMainVisible(False);
        pmAddGroup.Visible := True;
        pmDeleteGroup.Visible := True;
        pmSep2.Visible := True;
        pmAddUser.Visible := True;
        pmDeleteUser.Visible := True;
        pmSep3.Visible := True;
        pmAskLeave.Visible := True;  
        pmSep4.Visible := True;
        pmSetWork.Visible := True;
      end;
      jltTogether:
      begin
        SetPopupMenuMainVisible(True);
        pmComeBack.Visible := False;
      end;
    end;
    
    if not Assigned(selGroupObj) then
    begin
      if m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType = jltTogether then
      begin
        SetPopupMenuMainVisible(False);
        pmAddJiCheAdd.Visible := True;
      end
      else
      begin
        pmDeleteJiCheDel.Visible := False;
        pmDeleteGroup.Visible := False;
        pmDeleteUser.Visible := False;
        pmSep3.Visible := False;
        pmAskLeave.Visible := False;
        pmComeBack.Visible := False;
        pmSep4.Visible := False;
        pmSetWork.Visible := False;
        if (m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType <> jltUnrun) and
          (m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType <> jltReady)  then
          pmAddUser.Visible := False;
      end;
    end;
    pt.X := X + rzgrpbxStart.Left + rzpnlBack.Left;
    pt.Y := Y + rzgrpbxStart.Top + rzpnlBack.Top + rztbcntrlLine.Height;
    m_ElecBoardPos := csd_Up;
    pmBoard.Popup(pt.X, pt.Y);
  end;
end;

function TFrmElecBoardInit.ExchangeUnTogetherObj(FirstItem,
  SeconddItem: TElecBoardGroupInfo; jlType: TJiaoluType): Boolean;
var
  strGroup1,strGroup2,strUser1,strUser2:string;
begin
//  Result := False;
//  if (TTurnGroupInfo(FirstItem).nIndex and
//    TTurnGroupInfo(SeconddItem).nIndex) < 0 then
//    raise Exception.Create('请选择要交换的对象');
//
//  strGroup1 := TTurnGroupInfo(FirstItem).Key;
//  strgroup2 := TTurnGroupInfo(SeconddItem).Key;
//  if FirstItem.ActiveUserIndex < 0 then
//  begin
//    Result := m_dbTrainmanJiaoLu.ExchangeGroup(GlobalDM.ADOConnection,jlType,
//      strGroup1,strGroup2);
//  end
//  else
//  begin
//    strUser1 := TTurnGroupInfo(FirstItem).UserList.Items[
//      TTurnGroupInfo(FirstItem).ActiveUserIndex].Key;
//    strUser2 := TTurnGroupInfo(SeconddItem).UserList.Items[
//      TTurnGroupInfo(SeconddItem).ActiveUserIndex].Key;
//
//    if (strUser1 = '') and (strUser2 = '') then
//      raise Exception.Create('两个空的人员不能进行交换');
//    if strUser1 = '' then      
//      Result := m_dbTrainmanJiaoLu.ExchangePerson(GlobalDM.ADOConnection,
//        strUser2,strUser1,strGroup1,
//        TTurnGroupInfo(FirstItem).ActiveUserIndex + 1)
//    else
//      Result := m_dbTrainmanJiaoLu.ExchangePerson(GlobalDM.ADOConnection,
//        strUser1,strUser2,strGroup2,
//        TTurnGroupInfo(SeconddItem).ActiveUserIndex + 1);
//  end;
end;

procedure TFrmElecBoardInit.FormCreate(Sender: TObject);
begin
  m_dbTrainmanJiaoLu := TDBTrainmanJiaolu.Create(GlobalDM.ADOConnection);
end;

procedure TFrmElecBoardInit.FormDestroy(Sender: TObject);
begin
  FreeAndNil(m_dbTrainmanJiaoLu);
end;

procedure TFrmElecBoardInit.FormResize(Sender: TObject);
var
  jlInfo:RTrainmanJiaolu;
begin
  if not Assigned(lvJiBanJiaoLu.Selected) then
    jlInfo.nJiaoluType := jltOrder
  else
    jlInfo := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index];
  case jlInfo.nJiaoluType of
    jltReady:
      // 预备模式
      begin
        rzgrpbxStart.Height := rzpnlBack.Height - 8;
      end;
    jltUnrun:
      // 非运转模式
      begin
        rzgrpbxStart.Height := rzpnlBack.Height - 8;
        rzgrpbxEnd.Visible := False;
      end;
    jltOrder:
      // 轮乘模式
      begin
        rzgrpbxStart.Height := Trunc(rzpnlBack.Height / 2) - 6;
        rzgrpbxEnd.Top := rzgrpbxStart.Top + rzgrpbxStart.Height + 3;
        rzgrpbxEnd.Height := rzgrpbxStart.Height;
        rzgrpbxStart.Visible := True;
        rzgrpbxEnd.Visible := True;
      end;
    jltNamed:
      // 记名式交路模式
      begin
        rzgrpbxStart.Height := rzpnlBack.Height - 8;
        rzgrpbxEnd.Visible := False;
      end;
    jltTogether:
      // 包乘模式
      begin
        rzgrpbxStart.Height := rzpnlBack.Height - 8;
        rzgrpbxEnd.Visible := False;
      end;
  end;
end;

procedure TFrmElecBoardInit.FormShow(Sender: TObject);
begin
  UpdateLines;
end;

procedure TFrmElecBoardInit.UpdatePrepareStations(strJLGUID:string;bIsActive:Boolean);
var
  I,J:Integer;
  jlInfo:RTrainmanJiaolu;
  group: TReadyGroupInfo;
  turn,turnOld:TTurnGroupInfo;
begin
  jlInfo := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index];

  elcnmbrdcntrlStart.MemberType := mt_ReadyModel;
  elcnmbrdcntrlStart.nMaxCountInGroup := 1;

  group := nil;
  turn := nil;
  try
    group := TReadyGroupInfo.Create;
    turn := TTurnGroupInfo.Create;
    
    m_dbTrainmanJiaoLu.GetLineStations(GlobalDM.ADOConnection,
      m_LineAry[rztbcntrlLine.TabIndex].strLineGUID,m_PreStationAry);
    for I := 0 to Length(m_PreStationAry) - 1 do
    begin
      m_dbTrainmanJiaoLu.GetOtherStationGroups(GlobalDM.ADOConnection,
        jlInfo.strTrainmanJiaoluGUID,
        m_PreStationAry[I].strStationGUID,m_OtherGroupAry);
      if Length(m_OtherGroupAry) <= 0 then
        Continue;
      
      group.Clear;
      group.Key := m_OtherGroupAry[0].Station.strStationGUID;
      group.Title := m_OtherGroupAry[0].Station.strStationName;
      for J := 0 to Length(m_OtherGroupAry) - 1 do
      begin
        turn.Clear;
        turn.Key := m_OtherGroupAry[J].Trainman.strTrainmanGUID;
        AddUserToGroupList(turn,m_OtherGroupAry[J].Trainman);
        group.ChildGroupList.AddCopy(turn);
      end;
      elcnmbrdcntrlStart.lstGroupInfo.AddCopy(group);
    end;
  finally
    elcnmbrdcntrlStart.ReUpdate;
    if Assigned(turn) then
      FreeAndNil(turn);
    if Assigned(group) then
      FreeAndNil(group);
  end;
end;

procedure TFrmElecBoardInit.lvJiBanJiaoLuClick(Sender: TObject);
var
  jlInfo:RTrainmanJiaolu;
begin
  if not Assigned(lvJiBanJiaoLu.Selected) then
    Exit;
  if Assigned(elcnmbrdcntrlStart.lstGroupInfo) then
    elcnmbrdcntrlStart.lstGroupInfo.Clear;
  if Assigned(elcnmbrdcntrlEnd.lstGroupInfo) then
    elcnmbrdcntrlEnd.lstGroupInfo.Clear;
  jlInfo := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index];
  rzgrpbxStart.Caption := jlInfo.strStartStationName;
  rzgrpbxEnd.Caption := jlInfo.strEndStationName;
  elcnmbrdcntrlStart.ShowHint := False;
  elcnmbrdcntrlEnd.ShowHint := False;
  UpdateJiaoLuInfo(jlInfo.strTrainmanJiaoluGUID, jlInfo.nJiaoluType,True);
end;

procedure TFrmElecBoardInit.ManualAddUser(jlType: TJiaoluType;
  elecBoardPos: TCursorPosInBoard);
var
  groupInfo:TTurnGroupInfo;
  nUserIndex:Integer;
  frmUser:TFrmAddUser;
begin
//  GetSelectedGroup(jlType,elecBoardPos,groupInfo,nUserIndex);
//  if (not Assigned(groupInfo) ) or (nUserIndex < 0) then
//    Exit;
//  if groupInfo.UserList.Items[nUserIndex].strGongHao <> '' then
//    raise Exception.Create(PAnsiChar(Format('[%s]已存在,不能进行二次添加',
//      [TPostNameAry[TPost(nUserIndex)]])));
//
//  frmUser := TFrmAddUser.Create(Self);
//
//  try
//    if frmUser.ShowModal <> mrOk then
//      Exit;
//
//    if Ord(frmUser.UserInfo.nPostID) < nUserIndex then
//      raise Exception.Create(PAnsiChar(Format('[%s]不能添加到[%s]处',
//        [TPostNameAry[frmUser.UserInfo.nPostID],TPostNameAry[TPost(nUserIndex)]])));
//    if m_dbTrainmanJiaoLu.AddTrainman(GlobalDM.ADOConnection,groupInfo.Key,
//      nUserIndex + 1,
//      frmUser.UserInfo.strTrainmanGUID) then
//    begin
////      MessageBox(Handle,'添加人员成功','恭喜您',MB_OK);
//      PostMessage(Handle,WM_USER_UPDATEJIAOLU_INIT,1,0);
//    end
//    else
//      MessageBox(Handle,'添加人员失败','非常遗憾',MB_ICONERROR);
//  finally
//    FreeAndNil(frmUser);
//  end;
end;

procedure TFrmElecBoardInit.ManualDeleteUser(jlType: TJiaoluType;
  elecBoardPos: TCursorPosInBoard);
var
  groupInfo:TTurnGroupInfo;
  nUserIndex:Integer;
begin
//  GetSelectedGroup(jlType,elecBoardPos,groupInfo,nUserIndex);
//  if (not Assigned(groupInfo) ) or (nUserIndex < 0) then
//  begin
//    MessageBox(Handle,'请选择需要删除的人员','提示',MB_ICONINFORMATION);
//    Exit;
//  end;
//  if groupInfo.UserList.Items[nUserIndex].Key = '' then
//    raise Exception.Create(PAnsiChar(Format('您选择的[%s]没有人员,无法进行删除操作',
//      [TPostNameAry[TPost(nUserIndex)]])));
//
//  if MessageBox(Handle,'您确定要将选择人的员进行删除吗?','请问',
//    MB_ICONQUESTION OR MB_YESNO OR MB_DEFBUTTON2) <> mrYes then
//      Exit;
//
//  if m_dbTrainmanJiaoLu.DeleteTrainman(GlobalDM.ADOConnection,
//    groupInfo.UserList.Items[nUserIndex].Key) then
//  begin
////    MessageBox(Handle,'删除人员成功','恭喜您',MB_OK);
//    PostMessage(Handle,WM_USER_UPDATEJIAOLU_INIT,1,0);
//  end
//  else
//    MessageBox(Handle,'删除人员失败','非常遗憾',MB_ICONERROR);
end;

procedure TFrmElecBoardInit.mmAddGroupClick(Sender: TObject);
begin
  pmToolBarAddGroupClick(Sender);
end;

procedure TFrmElecBoardInit.mmAddLocoClick(Sender: TObject);
begin
  pmToolBarAddLocoClick(Sender);
end;

procedure TFrmElecBoardInit.mmAddUserClick(Sender: TObject);
begin
  pmToolBarAddUserClick(Sender);
end;

procedure TFrmElecBoardInit.mmAskLeaveClick(Sender: TObject);
begin
  btnAskLeaveClick(Sender);
end;

procedure TFrmElecBoardInit.mmDelGroupClick(Sender: TObject);
begin
  pmToolBarDelGroupClick(Sender);
end;

procedure TFrmElecBoardInit.mmDelLocoClick(Sender: TObject);
begin
  pmToolBarDelLocoClick(Sender);
end;

procedure TFrmElecBoardInit.mmDelUserClick(Sender: TObject);
begin
  pmToolBarDelUserClick(Sender);
end;

procedure TFrmElecBoardInit.mmExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmElecBoardInit.mmSetWorkClick(Sender: TObject);
begin
  btnSetWorkClick(Sender);
end;

procedure TFrmElecBoardInit.mmSickLeaveClick(Sender: TObject);
begin
  btnSickLeaveClick(Sender);
end;

procedure TFrmElecBoardInit.OnUpdateJiaoLu(var msg: TMessage);
var
  jlInfo:RTrainmanJiaolu;
begin
  jlInfo := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index];    
  UpdateJiaoLuInfo(jlInfo.strTrainmanJiaoluGUID,jlInfo.nJiaoluType);
end;

procedure TFrmElecBoardInit.SetOptBtnState(bState:Boolean);
begin
  btnAskLeave.Enabled := bState;
  btnSickLeave.Enabled := bState;
  btnSetWork.Enabled := bState;
  mmAskLeave.Enabled := bState;
  mmSickLeave.Enabled := bState;
  mmSetWork.Enabled := bState;
  pmToolBarAddLoco.Enabled := bState;
  pmToolBarAddGroup.Enabled := bState;
  pmToolBarAddUser.Enabled := bState; 
  pmToolBarDelLoco.Enabled := bState;
  pmToolBarDelGroup.Enabled := bState;
  pmToolBarDelUser.Enabled := bState;

  mmAddLoco.Enabled := bState;
  mmDelLoco.Enabled := bState;
  mmAddGroup.Enabled := bState;
  mmDelGroup.Enabled := bState;
  mmAddUser.Enabled := bState;
  mmDelUser.Enabled := bState;
end;

procedure TFrmElecBoardInit.SetPopupMenuMainVisible(bVisible:Boolean);
begin
  pmAddJiCheAdd.Visible := bVisible;
  pmDeleteJiCheDel.Visible := bVisible;
  pmSep1.Visible := bVisible;
  pmAddGroup.Visible := bVisible;
  pmDeleteGroup.Visible := bVisible;
  pmSep2.Visible := bVisible;
  pmAddUser.Visible := bVisible;
  pmDeleteUser.Visible := bVisible;
  pmSep3.Visible := bVisible;
  pmAskLeave.Visible := bVisible;
  pmComeBack.Visible := bVisible;
  pmSep4.Visible := bVisible;
  pmSetWork.Visible := bVisible;
end;

procedure TFrmElecBoardInit.pmAddGroupClick(Sender: TObject);
begin
  case m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType of
    jltOrder: // 轮乘
      AddOrderGroup;
    jltNamed: // 记名式
      AddNamedGroup;
    jltTogether:  // 包乘
      AddTogetherGroup;
  end;
end;

procedure TFrmElecBoardInit.pmAddJiCheAddClick(Sender: TObject);
var
  JiChe:RTogetherTrain;
  frmJiChe:TFrmAddJiChe;
  group:ROrderGroupInTrain;
  loco:TContractGroupInfo;
  I:Integer;
begin
//  if m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType <> jltTogether then
//    Exit;
//  frmJiChe := TFrmAddJiChe.Create(Self);
//  try
//    if frmJiChe.ShowModal <> mrOk then
//      Exit;
//    JiChe.strTrainGUID := NewGUID;
//    JiChe.strTrainmanJiaoluGUID :=
//      m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strTrainmanJiaoluGUID;
//    JiChe.strTrainTypeName := frmJiChe.JiCheType;
//    JiChe.strTrainNumber := frmJiChe.JiCheNo;
//
//    FillChar(group,SizeOf(ROrderGroupInTrain),0);
//
//    group.Group.Station.strStationGUID := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strStartStationGUID;
//    group.Group.Station.strStationName := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strTrainmanJiaoluName;
//    group.strOrderGUID := NewGUID;
//    group.strTrainGUID := JiChe.strTrainGUID;
//    group.nOrder := 0;
//    group.Group.strGroupGUID := NewGUID;
//    group.Group.Trainman1.nPostID := ptTrainman;
//    group.Group.Trainman2.nPostID := ptSubTrainman;
//    group.Group.Trainman3.nPostID := ptLearning;
//
//    if m_dbTrainmanJiaoLu.AddTrain(GlobalDM.ADOConnection,
//      JiChe.strTrainmanJiaoluGUID,JiChe) and
//      m_dbTrainmanJiaoLu.AddGroupToTrain(GlobalDM.ADOConnection,group.strTrainGUID,
//      group)then
//    begin
//      UpdateTogetherBaseInfo(JiChe.strTrainmanJiaoluGUID);
//      loco := nil;
//      try
//        for I := elcnmbrdcntrlStart.lstGroupInfo.Count - 1 downto 0 do
//        begin
//          if elcnmbrdcntrlStart.lstGroupInfo.Items[I].Key = group.strTrainGUID then
//          begin
//            loco := TContractGroupInfo.Create;
//            loco.nIndex := I;
//            loco.ActiveUserGroupIndex := 0;
//            loco.ActiveUserIndex := 0;
//            elcnmbrdcntrlStart.SelectUser(loco);
//            Break;
//          end;
//        end;
//      finally
//        if Assigned(loco) then        
//          FreeAndNil(loco);
//      end;
////      MessageBox(Handle,'添加包乘机车成功','恭喜您',MB_OK);
//    end
//    else
//      MessageBox(Handle,'添加包乘机车失败','非常遗憾',MB_ICONERROR);
//  finally
//    FreeAndNil(frmJiChe);
//  end;
end;

procedure TFrmElecBoardInit.pmAddUserClick(Sender: TObject);
begin
  case m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType of
    jltOrder, // 轮乘
    jltNamed, // 记名式
    jltTogether:  // 包乘
      ManualAddUser(m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType,
        m_ElecBoardPos);
    jltUnrun: // 非运转
      AddUnRunUser;
    jltReady: // 预备
      AddReadyUser;
  end;
end;

procedure TFrmElecBoardInit.pmAskLeaveClick(Sender: TObject);
var
  jlType:TJiaoluType;
  groupInfo:TTurnGroupInfo;
  nUserIndex:Integer;
  frmLeave:TFrmAskLeave;
  LeaveInfo:RAskForLeave;
begin
//  jlType := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType;
//  GetSelectedGroup(jlType,m_ElecBoardPos,groupInfo,nUserIndex);
//  if (not Assigned(groupInfo) ) or (nUserIndex < 0) then
//    Exit;
//  if groupInfo.UserList.Items[nUserIndex].Key = '' then
//    raise Exception.Create('请假前请先选择人员');
//
//  frmLeave := TFrmAskLeave.Create(Self);
//  try
//    if frmLeave.ShowModal <> mrOk then
//      Exit;
//    LeaveInfo := frmLeave.LeaveInfo;
//    LeaveInfo.strTrainmanGUID := groupInfo.UserList.Items[nUserIndex].Key;
//    LeaveInfo.strDutyUserGUID := GlobalDM.DutyUser.strDutyGUID;
//    if m_dbTrainmanJiaoLu.AskForLeave(GlobalDM.ADOConnection,
//      m_LineAry[rztbcntrlLine.TabIndex].strLineGUID,
//      groupInfo.Key,
//      nUserIndex + 1, LeaveInfo) then
//    begin
//      lvJiBanJiaoLuClick(Sender);
////      MessageBox(Handle,'请假成功','恭喜您',MB_OK);
//    end
//    else
//      MessageBox(Handle,'请假失败','非常遗憾',MB_ICONERROR);
//  finally
//    FreeAndNil(frmLeave);
//  end;
end;

procedure TFrmElecBoardInit.pmComeBackClick(Sender: TObject);
var
  jlType:TJiaoluType;
  groupInfo:TTurnGroupInfo;
  nUserIndex:Integer;
  Sick:RSickLeave;
  frmSick:TFrmSickLeave;
begin
  jlType := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType;
  GetSelectedGroup(jlType,m_ElecBoardPos,groupInfo,nUserIndex);
  if (not Assigned(groupInfo) ) or (nUserIndex < 0) then
    Exit;
  if groupInfo.UserList.Items[nUserIndex].Key = '' then
    raise Exception.Create('销假前请先选择人员');
  frmSick := TFrmSickLeave.Create(Self);
  try
    frmSick.strLineGUID := m_LineAry[rztbcntrlLine.TabIndex].strLineGUID;
    if frmSick.ShowModal <> mrOk then
      Exit;
    Sick := frmSick.SickLeave;
    Sick.strDutyUserGUID := GlobalDM.DutyUser.strDutyGUID;
    Sick.strTrainmanGUID := groupInfo.UserList.Items[nUserIndex].Key;
    if m_dbTrainmanJiaoLu.SickLeave(GlobalDM.ADOConnection,
      m_LineAry[rztbcntrlLine.TabIndex].strLineGUID,
      Sick) then
    begin
      lvJiBanJiaoLuClick(Sender);
//      MessageBox(Handle,'销假成功','恭喜您',MB_OK);
    end
    else
      MessageBox(Handle,'销假失败','非常遗憾',MB_ICONERROR);
  finally
    FreeAndNil(frmSick);
  end;
end;

procedure TFrmElecBoardInit.pmDeleteGroupClick(Sender: TObject);
begin
  case m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType of
    jltOrder: // 轮乘
      DelOrderGroup;
    jltNamed: // 记名式
      DelNamedGroup;
    jltTogether:  // 包乘
      DelTogetherGroup;
    jltUnrun: // 非运转
      DelUnRunUser;
    jltReady: // 预备
      DelReadyUser;
  end;
end;

procedure TFrmElecBoardInit.pmDeleteJiCheDelClick(Sender: TObject);
var
  strJiCheGUID,strJLGUID:string;
begin
//  if (not Assigned(m_SelectedObjStart)) or (m_SelectedObjStart.nIndex < 0) or
//    (m_SelectedObjStart.nIndex >= elcnmbrdcntrlStart.lstGroupInfo.Count) then
//  begin
//    MessageBox(Handle,'请选择要删除的包乘机车','提示',MB_ICONINFORMATION);
//    Exit;
//  end;
//  if MessageBox(Handle,'您确定要删除吗?','请问',
//    MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) <> mrYes then
//    Exit;
//  if not Assigned(lvJiBanJiaoLu.Selected) then
//    raise Exception.Create('请选择人员交路');
//  strJLGUID := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strTrainmanJiaoluGUID;
//  strJiCheGUID := TContractGroupInfoList(elcnmbrdcntrlStart.lstGroupInfo).Items[
//    m_SelectedObjStart.nIndex].Key;
//  
//  if m_dbTrainmanJiaoLu.DeleteTogetherTrain(GlobalDM.ADOConnection,strJiCheGUID) then
//  begin
//    UpdateTogetherBaseInfo(strJLGUID);
////    MessageBox(Handle,'删除包乘机车成功','恭喜您',MB_OK);
//  end
//  else
//    MessageBox(Handle,'删除包乘机车失败','很遗憾',MB_ICONERROR);
end;

procedure TFrmElecBoardInit.pmDeleteUserClick(Sender: TObject);
begin
  case m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType of
    jltOrder, // 轮乘
    jltNamed, // 记名式
    jltTogether:  // 包乘
      ManualDeleteUser(m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType,
        m_ElecBoardPos);
    jltUnrun: // 非运转
      DelUnRunUser;
    jltReady: // 预备
      DelReadyUser;
  end;

end;

procedure TFrmElecBoardInit.pmSetWorkClick(Sender: TObject);
var
  jlType:TJiaoluType;
  groupInfo:TTurnGroupInfo;   
  nUserIndex:Integer;
  Dest:RTrainmanInGroup;
  frmWork:TFrmSetWork;
  I:Integer;
begin
  jlType := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType;
  GetSelectedGroup(jlType,m_ElecBoardPos,groupInfo,nUserIndex);
  if (not Assigned(groupInfo) ) or (nUserIndex < 0) then
    Exit;
  if groupInfo.UserList.Items[nUserIndex].Key <> '' then
    raise Exception.Create('该岗位已有人员');
  Dest.strGroupGUID := groupInfo.Key;
  Dest.nTrainmanIndex := nUserIndex + 1;
  frmWork := TFrmSetWork.Create(Self);
  for I := Length(m_TrainJiaoLuAry) - 1 downto 0 do
  begin
    if m_TrainJiaoLuAry[I].nJiaoluType = jltReady then
    begin
      frmWork.TrainmanJiaoluGUID := m_TrainJiaoLuAry[I].strTrainmanJiaoluGUID;
      Break;
    end;    
  end;
  try
    if frmWork.ShowModal <> mrOk then
      Exit;
    Dest.strTrainmanGUID := frmWork.UserInfo.strTrainmanGUID;
    if m_dbTrainmanJiaoLu.Induction(GlobalDM.ADOConnection,
      frmWork.UserInfo.strTrainmanGUID,Dest,GlobalDM.DutyUser.strDutyGUID) then
    begin
      lvJiBanJiaoLuClick(Sender);
//      MessageBox(Handle,'安排岗位成功','恭喜您',MB_OK);
    end
    else
      MessageBox(Handle,'安排岗位失败','非常遗憾',MB_ICONERROR);
  finally
    FreeAndNil(FrmWork);
  end;
end;

procedure TFrmElecBoardInit.pmToolBarAddGroupClick(Sender: TObject);
begin
  m_ElecBoardPos := GetSelectElecCtrlPos;
  pmAddGroupClick(Sender);
end;

procedure TFrmElecBoardInit.pmToolBarAddLocoClick(Sender: TObject);
begin
  pmAddJiCheAddClick(Sender);  
end;

procedure TFrmElecBoardInit.pmToolBarAddUserClick(Sender: TObject);
begin
  m_ElecBoardPos := GetSelectElecCtrlPos;
  pmAddUserClick(Sender);
end;

procedure TFrmElecBoardInit.pmToolBarDelGroupClick(Sender: TObject);
begin
  m_ElecBoardPos := GetSelectElecCtrlPos;
  pmDeleteGroupClick(Sender);
end;

procedure TFrmElecBoardInit.pmToolBarDelLocoClick(Sender: TObject);
begin
  pmDeleteJiCheDelClick(Sender);
end;

procedure TFrmElecBoardInit.pmToolBarDelUserClick(Sender: TObject);
begin
  m_ElecBoardPos := GetSelectElecCtrlPos;
  pmDeleteUserClick(Sender);
end;

procedure TFrmElecBoardInit.ReadOtherBaseInfo(strJLGUID: string);
begin
  m_dbTrainmanJiaoLu.GetOtherGroups(GlobalDM.ADOConnection,strJLGUID,m_OtherGroupAry);
end;

procedure TFrmElecBoardInit.UpdateJiaoLuInfo(strJLGUID:string; jlType: TJiaoluType;
  bIsActive:Boolean);
begin                       
  m_SelectedObjStart := nil;
  m_SelectedObjEnd := nil;
  case jlType of
    jltReady:
      // 预备模式
      begin                          
        elcnmbrdcntrlStart.nMaxCountInGroup := 1;
        elcnmbrdcntrlEnd.nMaxCountInGroup := 1;
        rzgrpbxStart.Height := rzpnlBack.Height - 8;
        rzgrpbxEnd.Visible := False;
        btnAdd.Enabled := False;
        btnDelete.Enabled := False;
        mmAdd.Enabled := False;
        mmDel.Enabled := False;
        SetOptBtnState(False);
        UpdatePrepareStations(strJLGUID,bIsActive);
      end;
    jltUnrun:
      // 非运转模式
      begin
        SetOptBtnState(False);
        btnAdd.Enabled := True;
        btnDelete.Enabled := True;
        mmAdd.Enabled := True;
        mmDel.Enabled := True;
        pmToolBarAddUser.Enabled := True;
        pmToolBarDelUser.Enabled := True;
        btnSickLeave.Enabled := True;
        mmSickLeave.Enabled := True;
        elcnmbrdcntrlStart.nMaxCountInGroup := 1;
        elcnmbrdcntrlEnd.nMaxCountInGroup := 1;
        rzgrpbxStart.Height := rzpnlBack.Height - 8;
        rzgrpbxEnd.Visible := False;
        UpdateNoWorkBaseInfo(strJLGUID);
      end;
    jltOrder:
      // 轮乘模式
      begin
        btnAdd.Enabled := True;
        btnDelete.Enabled := True; 
        mmAdd.Enabled := True;
        mmDel.Enabled := True;
        SetOptBtnState(True);
        pmToolBarAddLoco.Enabled := False;
        pmToolBarDelLoco.Enabled := False;
        mmAddLoco.Enabled := False;
        mmDelLoco.Enabled := False;
        btnAskLeave.Enabled := True;
        mmAskLeave.Enabled := True;
        btnSetWork.Enabled := True;
        mmSetWork.Enabled := True;
        elcnmbrdcntrlStart.nMaxCountInGroup := 3;
        elcnmbrdcntrlEnd.nMaxCountInGroup := 3;
        rzgrpbxStart.Height := Trunc(rzpnlBack.Height / 2) - 6;
        rzgrpbxEnd.Top := rzgrpbxStart.Top + rzgrpbxStart.Height + 3;
        rzgrpbxEnd.Height := rzgrpbxStart.Height;
        rzgrpbxStart.Visible := True;
        rzgrpbxEnd.Visible := True;
        UpdateOrderBaseInfo(strJLGUID);
      end;
    jltNamed:
      // 记名式交路模式
      begin                  
        btnAdd.Enabled := True;
        btnDelete.Enabled := True;  
        mmAdd.Enabled := True;
        mmDel.Enabled := True;
        SetOptBtnState(True);
        pmToolBarAddLoco.Enabled := False;
        pmToolBarDelLoco.Enabled := False;
        mmAddLoco.Enabled := False;
        mmDelLoco.Enabled := False;
        btnAskLeave.Enabled := True;
        mmAskLeave.Enabled := True;   
        btnSetWork.Enabled := True;
        mmSetWork.Enabled := True;
        elcnmbrdcntrlStart.nMaxCountInGroup := 3;
        elcnmbrdcntrlEnd.nMaxCountInGroup := 3;
        rzgrpbxStart.Height := rzpnlBack.Height - 8;
        //      rzgrpbxEnd.Height := rzgrpbxStart.Height;
        rzgrpbxEnd.Visible := False;
        UpdateNamedBaseInfo(strJLGUID);
      end;
    jltTogether:
      // 包乘模式
      begin         
        btnAdd.Enabled := True;
        btnDelete.Enabled := True;
        mmAdd.Enabled := True;
        mmDel.Enabled := True;
        SetOptBtnState(True);
        btnAskLeave.Enabled := True;
        mmAskLeave.Enabled := True;  
        btnSetWork.Enabled := True;
        mmSetWork.Enabled := True;                          
        elcnmbrdcntrlStart.nMaxCountInGroup := 3;
        elcnmbrdcntrlEnd.nMaxCountInGroup := 3;
        rzgrpbxStart.Height := rzpnlBack.Height - 8;
        //      rzgrpbxEnd.Height := rzgrpbxStart.Height;
        rzgrpbxEnd.Visible := False;
        UpdateTogetherBaseInfo(strJLGUID);
      end;
  end;
end;

procedure TFrmElecBoardInit.GetSelectedGroup(jlType: TJiaoluType;
  elecBoardPos: TCursorPosInBoard; out groupInfo: TTurnGroupInfo;
  out nUserIndex: Integer);
var
  selObj:TElecBoardGroupInfo;
begin
  groupInfo := nil;
  nUserIndex := -1;

  if elecBoardPos = csd_unKnown then
    raise Exception.Create('没有指定电子名牌')
  else if elecBoardPos = csd_Up then
    selObj := m_SelectedObjStart
  else
    selObj := m_SelectedObjEnd;

  if not Assigned(selObj) then
    raise Exception.Create('请选择要人员所在的班组');
    
  nUserIndex := selObj.ActiveUserIndex;
  
  case jlType of
    jltUnrun,
    jltReady,
    jltOrder:
    begin
      if TTurnGroupInfo(selObj).nIndex < 0 then
        raise Exception.Create('请选择人员所属的班组');
      if TTurnGroupInfo(selObj).ActiveUserIndex < 0 then
        raise Exception.Create('请选择人员所处的职位');
      if elecBoardPos = csd_Up then
        groupInfo := TTurnGroupInfoList(elcnmbrdcntrlStart.lstGroupInfo).Items[selObj.nIndex]
      else
        groupInfo := TTurnGroupInfoList(elcnmbrdcntrlEnd.lstGroupInfo).Items[selObj.nIndex];
    end;
    jltNamed:
    begin
      if TCheckRailGroupInfo(selObj).nIndex < 0 then
        raise Exception.Create('请选择人员所属的班组');
      if TCheckRailGroupInfo(selObj).ActiveUserIndex < 0 then
        raise Exception.Create('请选择人员所处的职位');
      
      if elecBoardPos = csd_Up then
        groupInfo := TCheckRailGroupInfoList(elcnmbrdcntrlStart.lstGroupInfo).Items[selObj.nIndex]
      else
        groupInfo := TCheckRailGroupInfoList(elcnmbrdcntrlEnd.lstGroupInfo).Items[selObj.nIndex];
    end;
    jltTogether:
    begin
      if TContractGroupInfo(selObj).nIndex < 0 then
        raise Exception.Create('请选择包乘组');
      if TContractGroupInfo(selObj).ActiveUserGroupIndex < 0 then
        raise Exception.Create('请选择要包乘组下的班组');
      if TContractGroupInfo(selObj).ActiveUserIndex < 0 then
        raise Exception.Create('请选择要添加人员的位置');
      
      if elecBoardPos = csd_Up then
        groupInfo := TContractGroupInfoList(elcnmbrdcntrlStart.lstGroupInfo).Items[
          selObj.nIndex].ChildGroupList.Items[
          TContractGroupInfo(selObj).ActiveUserGroupIndex]
      else
        groupInfo := TContractGroupInfoList(elcnmbrdcntrlEnd.lstGroupInfo).Items[
          selObj.nIndex].ChildGroupList.Items[
          TContractGroupInfo(selObj).ActiveUserGroupIndex]
    end;
  end;
end;

function TFrmElecBoardInit.GetSelectElecCtrlPos: TCursorPosInBoard;
var
  jlInfo:RTrainmanJiaolu;
  frmStation:TFrmSelectStation;
begin
  Result := csd_Up;
  jlInfo := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index];
  if jlInfo.nJiaoluType = jltOrder then
  begin
    frmStation := TFrmSelectStation.Create(Self);
    try
      frmStation.StartStation := jlInfo.strStartStationName;
      frmStation.EndStation := jlInfo.strEndStationName;
      if frmStation.ShowModal <> mrOk then
        Exit;
      if frmStation.SelectStation = jlInfo.strEndStationName then
          Result := csd_Down;
    finally
      FreeAndNil(frmStation);
    end;
  end;
end;

procedure TFrmElecBoardInit.FormActivate(Sender: TObject);
begin
  UpdateLines;
end;

function TFrmElecBoardInit.FormatNamedHintsInfo(group: RNamedGroup;
  nUserIndex: Integer): string;
begin
  Result := '';
  AppendStr(Result,FormatOrderHintsInfo(group.Group,nUserIndex));
  if Result = '' then
    Exit;
  AppendStr(Result,Format(#10#13 + '车次:%s - %s',[group.strCheci1,group.strCheci2]));
end;

function TFrmElecBoardInit.FormatOrderHintsInfo(group: RGroup;
  nUserIndex: Integer): string;
begin
  Result := '';
  case nUserIndex of
  0: Result := FormatTrainmanHintsInfo(Group.Trainman1);
  1: Result := FormatTrainmanHintsInfo(group.Trainman2);
  2: Result := FormatTrainmanHintsInfo(group.Trainman3);
  end;
end;

function TFrmElecBoardInit.FormatReadyHintsInfo(readyUser: ROherGroup): string;
begin
  Result := '';
  AppendStr(Result,FormatTrainmanHintsInfo(readyUser.Trainman));
  if Result = '' then
    Exit;
  AppendStr(Result,Format(#10#13 + '车站:%s',[readyUser.Station.strStationName]));
end;

function TFrmElecBoardInit.FormatTogetherHintsInfo(group: RTogetherTrain;
  nUserGroupIndex, nUserIndex: Integer): string;
begin
  Result := '';
  AppendStr(Result,FormatOrderHintsInfo(group.Groups[nUserGroupIndex].Group,nUserIndex));
  if Result = '' then
    Exit;
  AppendStr(Result,Format(#10#13 + '包乘机车:%s-%s',[group.strTrainTypeName,
    group.strTrainNumber]));
end;

function TFrmElecBoardInit.FormatTrainmanHintsInfo(trainman: RTrainman): string;
begin
  Result := '';
  if Trim(trainman.strTrainmanNumber) = '' then
    Exit;
  AppendStr(Result,Format('工号:%s' + #10#13,[trainman.strTrainmanNumber]));   
  AppendStr(Result,Format('姓名:%s' + #10#13,[trainman.strTrainmanName]));
  AppendStr(Result,Format('职位:%s' + #10#13,[TPostNameAry[trainman.nPostID]]));
  AppendStr(Result,Format('状态:%s' + #10#13,[TTrainmanStateNameAry[trainman.nTrainmanState]]));
  AppendStr(Result,Format('电话:%s',[trainman.strTelNumber]));
end;

procedure TFrmElecBoardInit.AddNamedGroup;
var
  frmCheCi:TFrmAddCheCi;
  frm:TFrmAddGroup;
  nCount,I:Integer;
  group:RNamedGroup;   
  elecCtrl:TElecnameBoardControl;
  turn:TTurnGroupInfo;
begin
//  frm := nil;
//  frmCheCi := TFrmAddCheCi.Create(Self);
//  nCount := 0;
//  turn := nil;
//  elecCtrl := nil;
//  try
//    if frmCheCi.ShowModal <> mrOk then
//      Exit;
//    group.strTrainmanJiaoluGUID :=
//      m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strTrainmanJiaoluGUID;
//    case m_ElecBoardPos of
//      csd_Up:
//      begin
//        group.Group.Station.strStationGUID :=
//          m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strStartStationGUID;
//        nCount := elcnmbrdcntrlStart.lstGroupInfo.Count; 
//        elecCtrl := elcnmbrdcntrlStart;
//      end;
//      csd_Down:
//      begin
//        group.Group.Station.strStationGUID :=
//          m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strEndStationGUID;
//        nCount := elcnmbrdcntrlEnd.lstGroupInfo.Count;
//        elecCtrl := elcnmbrdcntrlEnd;
//      end;
//    end;
//    
//    frm := TFrmAddGroup.Create(Self);
//    if frm.ShowModal <> mrOk then
//      Exit;
//    group.strCheciGUID := NewGUID;
//    group.nCheciOrder := nCount;
//    group.Group.strGroupGUID := NewGUID;
//    group.Group.Trainman1 := frm.Trainman1;
//    group.Group.Trainman2 := frm.Trainman2;
//    group.Group.Trainman3 := frm.Trainman3;
////    group.strCheci1 := frmCheCi.CheCiGo;
////    group.strCheci2 := frmCheCi.CheCiBack;
////    if frmCheCi.XiuBan then
////      group.nCheciType := cctRest
////    else
////      group.nCheciType := cctCheci;
////
////    if m_dbTrainmanJiaoLu.AddNamedGroup(m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strTrainmanJiaoluGUID,
////      group) then
//    begin
//      UpdateNamedBaseInfo(group.strTrainmanJiaoluGUID);
////      MessageBox(Handle,'添加班组成功','恭喜您',MB_OK);
//      turn := TTurnGroupInfo.Create;
//
//      for I := elecCtrl.lstGroupInfo.Count - 1 downto 0 do
//      begin
//        if elecCtrl.lstGroupInfo.Items[I].Key = group.Group.strGroupGUID then
//        begin
//          turn.nIndex := I;
//          turn.ActiveUserIndex := 0;
//          elecCtrl.SelectUser(turn);
//        end;
//      end;
//    end
//    else
//      MessageBox(Handle,'添加班组失败','很遗憾',MB_ICONERROR);
//  finally
//    FreeAndNil(frmCheCi);
//    if Assigned(frm) then    
//      FreeAndNil(frm);
//    if Assigned(turn) then
//      FreeAndNil(turn);
//  end;
end;

procedure TFrmElecBoardInit.AddOrderGroup;
var
  frm:TFrmAddGroup;
  group:ROrderGroup;
  nCount,I:Integer;
  elecCtrl:TElecnameBoardControl;
  turn:TTurnGroupInfo;
begin
//  frm := TFrmAddGroup.Create(Self);
//  nCount := 0;
//  turn := nil;
//  try
//    if frm.ShowModal <> mrOk then
//      Exit;
//    group.strTrainmanJiaoluGUID :=
//      m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strTrainmanJiaoluGUID;
//    case m_ElecBoardPos of
//      csd_Up:
//      begin
//        group.Group.Station.strStationGUID :=
//          m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strStartStationGUID;
//        nCount := elcnmbrdcntrlStart.lstGroupInfo.Count;
//        elecCtrl := elcnmbrdcntrlStart;
//      end;
//      csd_Down:
//      begin
//        group.Group.Station.strStationGUID :=
//          m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strEndStationGUID;
//        nCount := elcnmbrdcntrlEnd.lstGroupInfo.Count;
//        elecCtrl := elcnmbrdcntrlEnd;
//      end;
//    end;
//
//    group.nOrder := nCount;
//    group.strOrderGUID := NewGUID;
//    group.Group.strGroupGUID := NewGUID;
//    group.Group.Trainman1 := frm.Trainman1;
//    group.Group.Trainman2 := frm.Trainman2;
//    group.Group.Trainman3 := frm.Trainman3;
//
//    if m_dbTrainmanJiaoLu.AddOrderGroup(GlobalDM.ADOConnection,
//      m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strTrainmanJiaoluGUID,
//      group) then
//    begin
//      UpdateOrderBaseInfo(group.strTrainmanJiaoluGUID);   
////      MessageBox(Handle,'添加班组成功','恭喜您',MB_OK);
//      turn := TTurnGroupInfo.Create;
//
//      for I := elecCtrl.lstGroupInfo.Count - 1 downto 0 do
//      begin
//        if elecCtrl.lstGroupInfo.Items[I].Key = group.Group.strGroupGUID then
//        begin
//          turn.nIndex := I;
//          turn.ActiveUserIndex := 0;
//          elecCtrl.SelectUser(turn);
//        end;
//      end;
//    end
//    else
//      MessageBox(Handle,'添加班组失败','很遗憾',MB_ICONERROR);
//  finally
//    FreeAndNil(frm);
//    if Assigned(turn) then
//      FreeAndNil(turn);
//  end;
end;

procedure TFrmElecBoardInit.AddReadyUser;
var
  frmUser:TFrmAddUser;
  group:ROherGroup;
  nIndex:Integer;
  jlInfo:RTrainmanJiaoLu;
begin
//  frmUser := TFrmAddUser.Create(Self);
//  try
//    if frmUser.ShowModal <> mrOk then
//      Exit;
//    group.strTrainmanJiaoluGUID :=
//      m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strTrainmanJiaoluGUID;
//    group.Trainman := frmUser.UserInfo;
////    group.Station := m_PreStationAry[rztbcntrlNoWork.TabIndex];
//    if m_dbTrainmanJiaoLu.AddTrainmanToOther(GlobalDM.ADOConnection,
//      m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType,group) then
//    begin
//      jlInfo := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index];
//      UpdateJiaoLuInfo(group.strTrainmanJiaoluGUID,jlInfo.nJiaoluType);
//      UpdatePrepareStations(group.strTrainmanJiaoluGUID);
////      MessageBox(Handle,'添加预备人员成功','恭喜您',MB_OK);
//    end
//    else
//      MessageBox(Handle,'添加预备人员失败','很遗憾',MB_ICONERROR);
//  finally
//    FreeAndNil(frmUser);
//  end;
end;

procedure TFrmElecBoardInit.AddTogetherGroup;
var
  group:ROrderGroupInTrain;
  JiChe:TContractGroupInfo;
  nCount,I,J:Integer;
  frm:TFrmAddGroup;
  station:RStation;
  strJLGUID:string;
  together:TContractGroupInfo;
  turnList:TTurnGroupInfoList;
begin
//  nCount := 0;
//  strJLGUID := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strTrainmanJiaoluGUID;
//  JiChe := nil;
//
//  JiChe := TContractGroupInfo(m_SelectedObjStart);   
//  nCount := elcnmbrdcntrlStart.lstGroupInfo.Count;
//  station.strStationGUID := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strStartStationGUID;
//  station.strStationName := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strTrainmanJiaoluName;
//  
//  if (not Assigned(JiChe)) or (JiChe.nIndex < 0) then
//    raise Exception.Create('请选择添加班组所属的包乘机车');
//  group.strTrainGUID := TContractGroupInfoList(elcnmbrdcntrlStart.lstGroupInfo).Items[JiChe.nIndex].Key;
//  group.nOrder := nCount;
//  frm := TFrmAddGroup.Create(Self);
//  together := nil;
//  try
//    if frm.ShowModal <> mrOk then
//      Exit;
//    group.strOrderGUID := NewGUID;
//    group.Group.strGroupGUID := NewGUID;
//    group.strTrainGUID := JiChe.Key;
//    group.Group.Trainman1 := frm.Trainman1;
//    group.Group.Trainman2 := frm.Trainman2;
//    group.Group.Trainman3 := frm.Trainman3;
//    group.Group.Station := station;
//
//    if m_dbTrainmanJiaoLu.AddGroupToTrain(GlobalDM.ADOConnection,group.strTrainGUID,
//      group) then
//    begin  
//      UpdateTogetherBaseInfo(strJLGUID);
////      MessageBox(Handle,'添加包乘班组成功','恭喜您',MB_OK);
//      together := TContractGroupInfo.Create;
//      for I := elcnmbrdcntrlStart.lstGroupInfo.Count - 1 downto 0 do
//      begin
//        if elcnmbrdcntrlStart.lstGroupInfo.Items[I].Key = group.strTrainGUID then
//        begin
//          together.nIndex := I;
//          turnList := TContractGroupInfoList(elcnmbrdcntrlStart.lstGroupInfo).Items[I].ChildGroupList;
//          for J := turnList.Count - 1 downto 0 do
//          begin
//            if turnList.Items[J].Key = group.Group.strGroupGUID then
//            begin
//              together.ActiveUserGroupIndex := J;
//              together.ActiveUserIndex := 0;
//              elcnmbrdcntrlStart.SelectUser(together);
//              Break;
//            end;
//          end;
//          Break;
//        end;
//      end;
//
//    end
//    else
//    begin
//      MessageBox(Handle,'添加包乘班组失败','很遗憾',MB_ICONERROR);
//    end;   
//  finally
//    FreeAndNil(frm);
//    if Assigned(together) then
//      FreeAndNil(together);
//  end;
end;

procedure TFrmElecBoardInit.AddUnRunUser;
var
  frmUser:TFrmAddUser;
  group:ROherGroup;
begin
//  frmUser := TFrmAddUser.Create(Self);
//  try
//    if frmUser.ShowModal <> mrOk then
//      Exit;
//    group.strTrainmanJiaoluGUID :=
//      m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].strTrainmanJiaoluGUID;
//    group.Trainman := frmUser.UserInfo;
//    if m_dbTrainmanJiaoLu.AddTrainmanToOther(GlobalDM.ADOConnection,
//      m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index].nJiaoluType,group) then
//    begin
//      UpdateNoWorkBaseInfo(group.strTrainmanJiaoluGUID);
////      MessageBox(Handle,'添加非运转人员成功','恭喜您',MB_OK);
//    end
//    else
//      MessageBox(Handle,'添加非运转人员失败','很遗憾',MB_ICONERROR);
//  finally
//    FreeAndNil(frmUser);
//  end;
end;

procedure TFrmElecBoardInit.AddUserToGroupList(group: TTurnGroupInfo; Trainman:RTrainman);
var
  user: TElecBoardUserInfo;
begin
  user := TElecBoardUserInfo.Create;
  SetUserInfoOfGroupList(user,Trainman);
  group.UserList.Add(user);
end;

procedure TFrmElecBoardInit.rztbcntrlLineClick(Sender: TObject);
var
  line:RLine;
begin
  if rztbcntrlLine.TabIndex < 0 then
    Exit;
  if Assigned(elcnmbrdcntrlStart.lstGroupInfo) then
  begin
    elcnmbrdcntrlStart.lstGroupInfo.Clear;
    elcnmbrdcntrlStart.ReUpdate;
  end;
  if Assigned(elcnmbrdcntrlEnd.lstGroupInfo) then
  begin
    elcnmbrdcntrlEnd.lstGroupInfo.Clear;
    elcnmbrdcntrlEnd.ReUpdate;
  end;

  line := m_LineAry[rztbcntrlLine.TabIndex];
  UpdateJiaoLus(line.strLineGUID);
end;

procedure TFrmElecBoardInit.SetUserInfoOfGroupList(user: TElecBoardUserInfo;
  trainman: RTrainman);
begin
  user.Key := trainman.strTrainmanGUID;      
  user.clBack := TTrainmanStateBackColorAry[Trainman.nTrainmanState];
  user.ftFont.Color := TTrainmanStateFontColorAry[Trainman.nTrainmanState];
  user.strGongHao := Trainman.strTrainmanNumber;
  user.strName := Trainman.strTrainmanName;
end;

procedure TFrmElecBoardInit.UpdateJiaoLus(strLineGUID: string);
var
  I,nCount:Integer;
  Item:TListItem;
begin
  lvJiBanJiaoLu.Items.BeginUpdate;
  try
    lvJiBanJiaoLu.Items.Clear;
    m_dbTrainmanJiaoLu.GetLineTrainmanJiaolus(GlobalDM.ADOConnection,
      GlobalDM.SiteInfo.strSiteGUID,strLineGUID,m_TrainJiaoLuAry);
    nCount := Length(m_TrainJiaoLuAry);
    for I := 0 to nCount - 1 do
    begin
      Item := lvJiBanJiaoLu.Items.Add;
      Item.ImageIndex := Ord(m_TrainJiaoLuAry[I].nJiaoluType);
      Item.Caption := m_TrainJiaoLuAry[I].strTrainmanJiaoluName;
    end;
    if nCount > 0 then
    begin
      lvJiBanJiaoLu.Selected := lvJiBanJiaoLu.Items.Item[0];
      lvJiBanJiaoLuClick(Self);
    end;
  finally
    lvJiBanJiaoLu.Items.EndUpdate;
  end;
end;

procedure TFrmElecBoardInit.UpdateLines;
var
  I,nCount:Integer;
  tab:TRzTabCollectionItem;
begin
  TDBLine.GetLines(GlobalDM.ADOConnection,GlobalDM.SiteInfo.strSiteGUID,m_LineAry);
  rztbcntrlLine.Tabs.BeginUpdate;
  try
    rztbcntrlLine.Tabs.Clear;
    lvJiBanJiaoLu.Items.Clear;
    if Assigned(elcnmbrdcntrlStart.lstGroupInfo) then
    begin
      elcnmbrdcntrlStart.lstGroupInfo.Clear;
      elcnmbrdcntrlStart.ReUpdate;
    end;
    if Assigned(elcnmbrdcntrlEnd.lstGroupInfo) then
    begin
      elcnmbrdcntrlEnd.lstGroupInfo.Clear;
      elcnmbrdcntrlEnd.ReUpdate;
    end;
    
    nCount := Length(m_LineAry);
    for I := 0 to nCount - 1 do
    begin
      tab := rztbcntrlLine.Tabs.Add;
      tab.Caption := m_LineAry[I].strLineName;
    end;
    if nCount > 0 then
    begin
      rztbcntrlLine.TabIndex := 0;
      rztbcntrlLineClick(Self);
    end;
  finally
    rztbcntrlLine.Tabs.EndUpdate;
  end;
end;

procedure TFrmElecBoardInit.UpdateNamedBaseInfo(strJLGUID: string);
var
  I:Integer;
  jlInfo:RTrainmanJiaolu;
  group: TCheckRailGroupInfo;
begin
  jlInfo := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index];

  elcnmbrdcntrlStart.MemberType := mt_CheckRailModel;
  elcnmbrdcntrlStart.nMaxCountInGroup := 3;
  
  group := TCheckRailGroupInfo.Create;
  try
//    m_dbTrainmanJiaoLu.GetNamedJiaoluGroups(GlobalDM.ADOConnection,strJLGUID,m_NamedGroupAry);
    for I := 0 to Length(m_NamedGroupAry) - 1 do
    begin
      group.Clear;
      group.Key := m_NamedGroupAry[I].Group.strGroupGUID;
      group.LstCheCi.Add(m_NamedGroupAry[I].strCheci1);
      group.LstCheCi.Add(m_NamedGroupAry[I].strCheci2);

      AddUserToGroupList(group,m_NamedGroupAry[I].Group.Trainman1);
      //
      AddUserToGroupList(group,m_NamedGroupAry[I].Group.Trainman2);
      //
      AddUserToGroupList(group,m_NamedGroupAry[I].Group.Trainman3);

     elcnmbrdcntrlStart.lstGroupInfo.AddCopy(group);
    end;
  finally
    elcnmbrdcntrlStart.ReUpdate;
    FreeAndNil(group);
  end;
end;

procedure TFrmElecBoardInit.UpdateNoWorkBaseInfo(strJLGUID: string);
var
  I:Integer;
  group:TTurnGroupInfo;
begin
  elcnmbrdcntrlStart.MemberType := mt_TurnModel; 
  elcnmbrdcntrlStart.nMaxCountInGroup := 1;
  group := nil;
  try
    m_dbTrainmanJiaoLu.GetOtherGroups(GlobalDM.ADOConnection,strJLGUID,m_OtherGroupAry);
    group := TTurnGroupInfo.Create;
    for I := 0 to Length(m_OtherGroupAry) - 1 do
    begin
      group.Clear;
      group.Key := m_OtherGroupAry[I].Trainman.strTrainmanGUID;
      AddUserToGroupList(group,m_OtherGroupAry[I].Trainman);
      elcnmbrdcntrlStart.lstGroupInfo.AddCopy(group);
    end;
  finally
    elcnmbrdcntrlStart.ReUpdate;
    if Assigned(group) then    
      FreeAndNil(group);
  end;
end;

procedure TFrmElecBoardInit.UpdateOrderBaseInfo(strJLGUID: string);
var
  I:Integer;
  jlInfo:RTrainmanJiaolu;
  group: TTurnGroupInfo;
begin
//  jlInfo := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index];
//
//  elcnmbrdcntrlStart.MemberType := mt_TurnModel;
//  elcnmbrdcntrlStart.nMaxCountInGroup := 3;
//  
//  elcnmbrdcntrlEnd.MemberType := mt_TurnModel;
//  group := TTurnGroupInfo.Create;
//  try
//    m_dbTrainmanJiaoLu.GetOrderJiaoluGroups(GlobalDM.ADOConnection,strJLGUID,m_OrderGroupAry);
//    for I := 0 to Length(m_OrderGroupAry) - 1 do
//    begin  
//      group.Clear;
//      group.Key := m_OrderGroupAry[I].Group.strGroupGUID;
//      AddUserToGroupList(group, m_OrderGroupAry[I].Group.Trainman1);
//      //
//      AddUserToGroupList(group,m_OrderGroupAry[I].Group.Trainman2);
//      //
//      AddUserToGroupList(group,m_OrderGroupAry[I].Group.Trainman3);
//      
//      if Trim(jlInfo.strStartStationGUID) =
//        Trim(m_OrderGroupAry[I].Group.Station.strStationGUID) then
//        elcnmbrdcntrlStart.lstGroupInfo.AddCopy(group)
//      else if Trim(jlInfo.strEndStationGUID) =
//        Trim(m_OrderGroupAry[I].Group.Station.strStationGUID) then
//        elcnmbrdcntrlEnd.lstGroupInfo.AddCopy(group);      
//    end;
//  finally
//    elcnmbrdcntrlStart.ReUpdate;
//    elcnmbrdcntrlEnd.ReUpdate;
//    FreeAndNil(group);
//  end;
end;

procedure TFrmElecBoardInit.UpdateTogetherBaseInfo(strJLGUID: string);
var
  I,J:Integer;
  jlInfo:RTrainmanJiaolu;
  group: TContractGroupInfo;
  turn:TTurnGroupInfo;
begin
//  jlInfo := m_TrainJiaoLuAry[lvJiBanJiaoLu.Selected.Index];
//
//  elcnmbrdcntrlStart.MemberType := mt_ContractModel;  
//  elcnmbrdcntrlStart.nMaxCountInGroup := 3;
//
//  group := nil;
//  turn := nil;
//  try
//    m_dbTrainmanJiaoLu.GetTogetherTrains(GlobalDM.ADOConnection,strJLGUID,m_TogetherTrainAry);
//    group := TContractGroupInfo.Create;
//    turn := TTurnGroupInfo.Create;
//    for I := 0 to Length(m_TogetherTrainAry) - 1 do
//    begin
//      group.Clear;
//      group.Key := m_TogetherTrainAry[I].strTrainGUID;
//      group.Title := m_TogetherTrainAry[I].strTrainTypeName +
//        m_TogetherTrainAry[I].strTrainNumber;
//
//      for J := 0 to Length(m_TogetherTrainAry[I].Groups) - 1 do
//      begin
//        turn.Clear;
//        turn.Key := m_TogetherTrainAry[I].Groups[J].Group.strGroupGUID;
//        AddUserToGroupList(turn,m_TogetherTrainAry[I].Groups[J].Group.Trainman1);
//        //
//        AddUserToGroupList(turn,m_TogetherTrainAry[I].Groups[J].Group.Trainman2);
//        //
//        AddUserToGroupList(turn,m_TogetherTrainAry[I].Groups[J].Group.Trainman3);
//        group.ChildGroupList.AddCopy(turn);
//      end;
//
//      elcnmbrdcntrlStart.lstGroupInfo.AddCopy(group);
//    end;
//  finally
//    elcnmbrdcntrlStart.ReUpdate;
//    if Assigned(turn) then
//      FreeAndNil(turn);
//    if Assigned(group) then
//      FreeAndNil(group);
//  end;
end;

end.
