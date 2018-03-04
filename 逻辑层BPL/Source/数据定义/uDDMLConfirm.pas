unit uDDMLConfirm;

interface
  uses Classes,Contnrs;
type
   /////////////////////////////////////////////////////////////////////////////
	/// 类名:TDDML_Confirm
	/// 说明:调令审核
	/////////////////////////////////////////////////////////////////////////////
	TDDML_Confirm = Class
	Protected
		//自增ID
		m_nID : Integer;
		//
		m_strGUID : string;
		//车间GUID
		m_strWorkShopGUID : string;
		//车间编号
		m_strWorkShopNumber : string;
		//车间名称
		m_strWorkShopName : string;
		//授权时间
		m_dtConfirmTime : TDateTime;
		//值班员工号
		m_strDutyUserNumber : string;
		//值班员姓名
		m_strDutyUserName : string;
	published
		//自增ID
		property nID : Integer read m_nID write m_nID;
		//
		property strGUID : string read m_strGUID write m_strGUID;
		//车间GUID
		property strWorkShopGUID : string read m_strWorkShopGUID write m_strWorkShopGUID;
		//车间编号
		property strWorkShopNumber : string read m_strWorkShopNumber write m_strWorkShopNumber;
		//车间名称
		property strWorkShopName : string read m_strWorkShopName write m_strWorkShopName;
		//授权时间
		property dtConfirmTime : TDateTime read m_dtConfirmTime write m_dtConfirmTime;
		//值班员工号
		property strDutyUserNumber : string read m_strDutyUserNumber write m_strDutyUserNumber;
		//值班员姓名
		property strDutyUserName : string read m_strDutyUserName write m_strDutyUserName;
	end;
implementation

end.
