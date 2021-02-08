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
	String orgCategory = CommonUtil.nvl((String)session.getAttribute("OrgCategoryForAdminTool"), (String)session.getAttribute("OrgCategory"));
	String defaultPeriodYear = (String)session.getAttribute("DefaultPeriodYear");
	String defaultQuarterName = (String)session.getAttribute("DefaultQuarterName");
	String paramFinancialYear = requestDataSet.getValue("financialYear");
	String paramQuarterName = requestDataSet.getValue("quarterName");
	String selectedFinancialYear = CommonUtil.nvl(paramFinancialYear, defaultPeriodYear);
	String selectedQuarterName = CommonUtil.nvl(paramQuarterName, defaultQuarterName);
	String surname = CommonUtil.nvl(requestDataSet.getValue("surname"));
	String givenName = CommonUtil.nvl(requestDataSet.getValue("givenName"));
	String visaType = CommonUtil.nvl(requestDataSet.getValue("visaType"));
	String wageType = CommonUtil.nvl(requestDataSet.getValue("wageType"));
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
<div id="divHeaderHolder" class="ui-layout-north"><%@ include file="/project/common/include/header.jsp"%></div>
<div id="divBodyHolder" class="ui-layout-center">
<div id="divBodyLeft" class="ui-layout-west"><%@ include file="/project/common/include/bodyLeft.jsp"%></div>
<div id="divBodyCenter" class="ui-layout-center">
<div id="divFixedPanel">
<div id="divLocationPathArea"><%@ include file="/project/common/include/bodyLocationPathArea.jsp"%></div>
<%/************************************************************************************************
* Real Contents - fixed panel(tab, button, search, information)
************************************************************************************************/%>
<div id="divTabArea"></div>
<div id="divButtonArea" class="areaContainer">
	<div id="divButtonAreaLeft"></div>
	<div id="divButtonAreaRight">
		<ui:buttonGroup id="buttonGroup">
			<ui:button id="btnNew" caption="button.com.new" iconClass="fa-plus-square"/>
			<ui:button id="btnDelete" caption="button.com.delete" iconClass="fa-trash"/>
			<ui:button id="btnSearch" caption="button.com.search" iconClass="fa-search"/>
			<ui:button id="btnClear" caption="button.com.clear" iconClass="fa-refresh"/>
			<ui:button id="btnExport" caption="button.com.export" iconClass="fa-download"/>
		</ui:buttonGroup>
	</div>
</div>
<div id="divAdminToolArea"><%@ include file="/project/common/include/bodyAdminToolArea.jsp"%></div>
<div id="divSearchCriteriaArea" class="areaContainer">
	<table class="tblSearch">
		<caption><mc:msg key="page.com.searchCriteria"/></caption>
		<colgroup>
			<col width="20%"/>
			<col width="20%"/>
			<col width="16%"/>
			<col width="*"/>
		</colgroup>
		<tr>
			<td class="tdSearch">
				<label for="surname" class="lblEn hor"><mc:msg key="rkm0802.search.surname"/></label>
				<ui:text name="surname" className="hor" style="width:200px;"/>
			</td>
			<td class="tdSearch">
				<label for="givenName" class="lblEn hor"><mc:msg key="rkm0802.search.givenName"/></label>
				<ui:text name="givenName" className="hor" style="width:200px;"/>
			</td>
			<td class="tdSearch">
			</td>
			<td class="tdSearch">
				<label for="visaType" class="lblEn hor"><mc:msg key="rkm0802.search.visaType"/></label>
				<div style="float:left;padding-right:4px;">
					<ui:ccselect name="visaType" codeType="VISA_TYPE" caption="==Select=="/>
				</div>
			</td>
		</tr>
	</table>
</div>
<div id="divInformArea"></div>
<%/************************************************************************************************
* End of fixed panel
************************************************************************************************/%>
<div class="breaker"></div>
</div>
<div id="divScrollablePanel">
<%/************************************************************************************************
* Real Contents - scrollable panel(data, paging)
************************************************************************************************/%>
<div id="divDataArea" class="areaContainer">
	<table id="tblGrid" class="tblGrid sort autosort">
		<colgroup>
			<col width="2%"/>
			<col width="9%"/>
			<col width="9%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="7%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="20%"/>
			<col width="*"/>
			<col width="4%"/>
			<col width="3%"/>
		</colgroup>
		<thead>
			<tr>
				<th class="thGrid"><ui:icon id="icnCheck" className="fa-check-square-o fa-lg"/></th>
				<th class="thGrid"><mc:msg key="rkm0802.grid.surname"/></th>
				<th class="thGrid"><mc:msg key="rkm0802.grid.givenName"/></th>
				<th class="thGrid"><mc:msg key="rkm0802.grid.tfn"/></th>
				<th class="thGrid"><mc:msg key="rkm0802.grid.dob"/></th>
				<th class="thGrid"><mc:msg key="rkm0802.grid.wageType"/></th>
				<th class="thGrid"><mc:msg key="rkm0802.grid.visaType"/></th>
				<th class="thGrid"><mc:msg key="rkm0802.grid.startDate"/></th>
				<th class="thGrid"><mc:msg key="rkm0802.grid.endDate"/></th>
				<th class="thGrid"><mc:msg key="rkm0802.grid.address"/></th>
				<th class="thGrid"><mc:msg key="rkm0802.grid.description"/></th>
				<th class="thGrid"><mc:msg key="rkm0802.grid.isActive"/></th>
				<th class="thGrid"><mc:msg key="page.com.action"/></th>
			</tr>
		</thead>
		<tbody id="tblGridBody">
			<tr>
				<td class="tdGridCt" colspan="13"><mc:msg key="I002"/></td>
			</tr>
		</tbody>
	</table>
</div>
<div id="divPagingArea" class="areaContainer"></div>
<%/************************************************************************************************
* Right & Footer
************************************************************************************************/%>
</div>
</div>
<div id="divBodyRight" class="ui-layout-east"><%@ include file="/project/common/include/bodyRight.jsp"%></div>
</div>
<div id="divFooterHolder" class="ui-layout-south"><%@ include file="/project/common/include/footer.jsp"%></div>
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