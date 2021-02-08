<%/************************************************************************************************
* Description - Rkm0802 - Employee Management
*	- Generated by Source Generator
************************************************************************************************/%>
<%@ include file="/shared/page/incCommon.jsp"%>
<%/************************************************************************************************
* Declare objects & variables
************************************************************************************************/%>
<%
	ParamEntity paramEntity = (ParamEntity)request.getAttribute("paramEntity");
	DataSet requestDataSet = (DataSet)paramEntity.getRequestDataSet();
%>
<%/************************************************************************************************
* HTML
************************************************************************************************/%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<link rel="icon" type="image/png" href="<mc:cp key="imgIcon"/>/faviconHKAccount.png">
<title><mc:msg key="main.system.title"/></title>
<%/************************************************************************************************
* Stylesheet & Javascript
************************************************************************************************/%>
<%@ include file="/shared/page/incCssJs.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript" src="<mc:cp key="viewPageJsName"/>"></script>
<script type="text/javascript">
</script>
</head>
<%/************************************************************************************************
* Page & Header
************************************************************************************************/%>
<body>
<form id="fmDefault" name="fmDefault" method="post" action="">
<div id="divPopupWindowHolder">
<div id="divFixedPanelPopup">
<div id="divLocationPathArea"><%@ include file="/project/common/include/bodyLocationPathArea.jsp"%></div>
<%/************************************************************************************************
* Real Contents - fixed panel(tab, button, search, information)
************************************************************************************************/%>
<div id="divTabArea"></div>
<div id="divButtonArea" class="areaContainerPopup">
	<div id="divButtonAreaLeft"></div>
	<div id="divButtonAreaRight">
		<ui:buttonGroup id="buttonGroup">
			<ui:button id="btnSave" caption="button.com.save" iconClass="fa-save"/>
			<ui:button id="btnClose" caption="button.com.close" iconClass="fa-times"/>
		</ui:buttonGroup>
	</div>
</div>
<div id="divSearchCriteriaArea"></div>
<div id="divInformArea"></div>
<%/************************************************************************************************
* End of fixed panel
************************************************************************************************/%>
<div class="breaker"></div>
</div>
<div id="divScrollablePanelPopup">
<%/************************************************************************************************
* Real Contents - scrollable panel(data, paging)
************************************************************************************************/%>
<div id="divDataArea" class="areaContainerPopup">
	<table class="tblEdit">
		<colgroup>
			<col width="17%"/>
			<col width="33%"/>
			<col width="17%"/>
			<col width="33%"/>
		</colgroup>
		<tr>
			<th class="thEdit Rt"><mc:msg key="rkm0802.header.employeeId"/></th>
			<td class="tdEdit"><ui:text name="employeeId" status="display" checkName="rkm0802.header.employeeId"/></td>
			<th class="thEdit Rt mandatory"><mc:msg key="rkm0802.header.isActive"/></th>
			<td class="tdEdit"><ui:ccselect name="isActive" codeType="SIMPLE_YN" options="mandatory"/></td>
		</tr>
		<tr>
			<th class="thEdit Rt mandatory"><mc:msg key="rkm0802.header.surname"/></th>
			<td class="tdEdit"><ui:text name="surname" checkName="rkm0802.header.surname" options="mandatory"/></td>
			<th class="thEdit Rt mandatory"><mc:msg key="rkm0802.header.givenName"/></th>
			<td class="tdEdit"><ui:text name="givenName" checkName="rkm0802.header.givenName" options="mandatory"/></td>
		</tr>
		<tr>
			<th class="thEdit Rt mandatory"><mc:msg key="rkm0802.header.tfn"/></th>
			<td class="tdEdit"><ui:text name="tfn" checkName="rkm0802.header.tfn" options="mandatory"/></td>
			<th class="thEdit Rt mandatory"><mc:msg key="rkm0802.header.dob"/></th>
			<td class="tdEdit">
				<ui:text name="dob" className="ct hor" style="width:100px" checkName="rkm0802.header.dob" options="mandatory"/>
				<ui:icon id="icnDob" className="fa-calendar hor"/>
			</td>
		</tr>
		<tr>
			<th class="thEdit Rt mandatory"></th>
			<td class="tdEdit"></td>
			<th class="thEdit Rt mandatory"><mc:msg key="rkm0802.header.visaType"/></th>
			<td class="tdEdit"><ui:ccselect name="visaType" codeType="VISA_TYPE" options="mandatory"/></td>
		</tr>
		<tr>
			<th class="thEdit Rt"><mc:msg key="rkm0802.header.startDate"/></th>
			<td class="tdEdit">
				<ui:text name="startDate" className="ct hor" style="width:100px" checkName="rkm0802.header.startDate" option="date"/>
				<ui:icon id="icnStartDate" className="fa-calendar hor"/>
			</td>
			<th class="thEdit Rt"><mc:msg key="rkm0802.header.endDate"/></th>
			<td class="tdEdit">
				<ui:text name="endDate" className="ct hor" style="width:100px" checkName="rkm0802.header.endDate" option="date"/>
				<ui:icon id="icnEndDate" className="fa-calendar hor"/>
			</td>
		</tr>
		<tr>
			<th class="thEdit Rt"><mc:msg key="rkm0802.header.address"/></th>
			<td class="tdEdit" colspan="3"><ui:text name="address" checkName="rkm0802.header.address"/></td>
		</tr>
		<tr>
			<th class="thEdit Rt"><mc:msg key="rkm0802.header.description"/></th>
			<td class="tdEdit" colspan="3"><ui:text name="description" checkName="rkm0802.header.description"/></td>
		</tr>
	</table>
</div>
<div id="divPagingArea"></div>
<%/************************************************************************************************
* Right & Footer
************************************************************************************************/%>
</div>
</div>
<%/************************************************************************************************
* Additional Elements
************************************************************************************************/%>
</form>
<%/************************************************************************************************
* Additional Form
************************************************************************************************/%>
<form id="fmHidden" name="fmHidden" method="post" action=""></form>
</body>
</html>