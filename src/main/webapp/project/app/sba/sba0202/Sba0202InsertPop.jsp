<%/************************************************************************************************
* Description - Sba0202 - Organisation Management
*	- Generated by Source Generator
************************************************************************************************/%>
<%@ include file="/shared/page/incCommon.jsp"%>
<%/************************************************************************************************
* Declare objects & variables
************************************************************************************************/%>
<%
	ParamEntity paramEntity = (ParamEntity)request.getAttribute("paramEntity");
	DataSet requestDataSet = (DataSet)paramEntity.getRequestDataSet();
	String dateFormat = ConfigUtil.getProperty("format.date.java");
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
$(function() {
// 	$(window).load(function() {
// 		commonJs.setFieldDateMask("registeredDate");
// 		$(".numeric").number(true, 0);
// 		$("#abn").focus();
// 	});
});
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
			<col width="14%"/>
			<col width="36%"/>
			<col width="14%"/>
			<col width="36%"/>
		</colgroup>
		<tr>
			<th class="thEdit Rt"><mc:msg key="sba0202.header.orgId"/></th>
			<td class="tdEdit"><ui:text name="orgId" status="display"/></td>
			<th class="thEdit Rt"><mc:msg key="sba0202.header.abn"/></th>
			<td class="tdEdit"><ui:text name="abn" checkName="sba0202.header.abn"/></td>
		</tr>
		<tr>
			<th class="thEdit Rt"><mc:msg key="sba0202.header.legalName"/></th>
			<td class="tdEdit"><ui:text name="legalName" checkName="sba0202.header.legalName" options="mandatory"/></td>
			<th class="thEdit Rt"><mc:msg key="sba0202.header.tradingName"/></th>
			<td class="tdEdit"><ui:text name="tradingName" checkName="sba0202.header.tradingName"/></td>
		</tr>
		<tr>
			<th class="thEdit Rt"><mc:msg key="sba0202.header.registeredDate"/></th>
			<td class="tdEdit">
				<ui:text name="registeredDate" className="Ct hor" style="width:100px" value="<%=CommonUtil.getSysdate(dateFormat)%>" checkName="sba0202.header.registeredDate" option="date"/>
				<ui:icon id="icnRegisteredDate" className="fa-calendar hor" title="sba0202.header.registeredDate"/>
			</td>
			<th class="thEdit Rt"><mc:msg key="sba0202.header.isActive"/></th>
			<td class="tdEdit"><ui:ccselect name="isActive" codeType="IS_ACTIVE"/></td>
		</tr>
		<tr>
			<th class="thEdit Rt"><mc:msg key="sba0202.header.orgCategory"/></th>
			<td class="tdEdit"><ui:ccselect name="orgCategory" codeType="ORG_CATEGORY" checkName="sba0202.header.orgCategory" options="mandatory"/></td>
			<th class="thEdit Rt"><mc:msg key="sba0202.header.email"/></th>
			<td class="tdEdit"><ui:text name="email" checkName="sba0202.header.email"/></td>
		</tr>
		<tr>
			<th class="thEdit Rt"><mc:msg key="sba0202.header.entityType"/></th>
			<td class="tdEdit"><ui:ccselect name="entityType" codeType="ENTITY_TYPE" checkName="sba0202.header.entityType" options="mandatory"/></td>
			<th class="thEdit Rt"><mc:msg key="sba0202.header.businessType"/></th>
			<td class="tdEdit"><ui:ccselect name="businessType" codeType="BUSINESS_TYPE" checkName="sba0202.header.businessType" options="mandatory"/></td>
		</tr>
		<tr>
			<th class="thEdit Rt"><mc:msg key="sba0202.header.baseType"/></th>
			<td class="tdEdit"><ui:ccselect name="baseType" codeType="BUSINESS_TYPE" checkName="sba0202.header.baseType" options="mandatory"/></td>
			<th class="thEdit Rt"><mc:msg key="sba0202.header.wageType"/></th>
			<td class="tdEdit"><ui:ccselect name="wageType" codeType="WAGE_TYPE" checkName="sba0202.header.wageType" options="mandatory"/></td>
		</tr>
		<tr>
			<th class="thEdit Rt"><mc:msg key="sba0202.header.rRangeFrom"/></th>
			<td class="tdEdit"><ui:text name="rRangeFrom" className="rt numeric" checkName="sba0202.header.rRangeFrom" option="numeric"/></td>
			<th class="thEdit Rt"><mc:msg key="sba0202.header.rRangeTo"/></th>
			<td class="tdEdit"><ui:text name="rRangeTo" className="rt numeric" checkName="sba0202.header.rRangeTo" option="numeric"/></td>
		</tr>
		<tr>
			<th class="thEdit Rt"><mc:msg key="sba0202.header.postalAddress"/></th>
			<td class="tdEdit" colspan="3"><ui:text name="email" checkName="sba0202.header.email"/></td>
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