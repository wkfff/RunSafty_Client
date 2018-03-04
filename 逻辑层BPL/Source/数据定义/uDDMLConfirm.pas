unit uDDMLConfirm;

interface
  uses Classes,Contnrs;
type
   /////////////////////////////////////////////////////////////////////////////
	/// ����:TDDML_Confirm
	/// ˵��:�������
	/////////////////////////////////////////////////////////////////////////////
	TDDML_Confirm = Class
	Protected
		//����ID
		m_nID : Integer;
		//
		m_strGUID : string;
		//����GUID
		m_strWorkShopGUID : string;
		//������
		m_strWorkShopNumber : string;
		//��������
		m_strWorkShopName : string;
		//��Ȩʱ��
		m_dtConfirmTime : TDateTime;
		//ֵ��Ա����
		m_strDutyUserNumber : string;
		//ֵ��Ա����
		m_strDutyUserName : string;
	published
		//����ID
		property nID : Integer read m_nID write m_nID;
		//
		property strGUID : string read m_strGUID write m_strGUID;
		//����GUID
		property strWorkShopGUID : string read m_strWorkShopGUID write m_strWorkShopGUID;
		//������
		property strWorkShopNumber : string read m_strWorkShopNumber write m_strWorkShopNumber;
		//��������
		property strWorkShopName : string read m_strWorkShopName write m_strWorkShopName;
		//��Ȩʱ��
		property dtConfirmTime : TDateTime read m_dtConfirmTime write m_dtConfirmTime;
		//ֵ��Ա����
		property strDutyUserNumber : string read m_strDutyUserNumber write m_strDutyUserNumber;
		//ֵ��Ա����
		property strDutyUserName : string read m_strDutyUserName write m_strDutyUserName;
	end;
implementation

end.
