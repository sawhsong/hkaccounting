<%/************************************************************************************************
* Description - Cst0202 - Performance
*	- Generated by Source Generator
************************************************************************************************/%>
<%@ include file="/shared/page/incCommon.jsp"%>
<%/************************************************************************************************
* Declare objects & variables
************************************************************************************************/%>
<%
	ParamEntity paramEntity = (ParamEntity)request.getAttribute("paramEntity");
	DataSet requestDataSet = (DataSet)paramEntity.getRequestDataSet();
	String defaultPeriodYear = (String)session.getAttribute("DefaultPeriodYear");
	String defaultQuarterName = (String)session.getAttribute("DefaultQuarterName");
	String paramFinancialYear = requestDataSet.getValue("financialYear");
	String paramQuarterName = requestDataSet.getValue("quarterName");
	String selectedFinancialYear = CommonUtil.nvl(paramFinancialYear, defaultPeriodYear);
	String selectedQuarterName = CommonUtil.nvl(paramQuarterName, defaultQuarterName);
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
			<ui:button id="btnSearch" caption="button.com.search" iconClass="fa-search"/>
			<ui:button id="btnClear" caption="button.com.clear" iconClass="fa-refresh"/>
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
			<col width="30%"/>
			<col width="*"/>
		</colgroup>
		<tr>
			<td class="tdSearch">
				<label for="financialYear" class="lblEn hor mandatory"><mc:msg key="cst0202.search.financialYear"/></label>
				<div style="float:left;padding-right:4px;">
					<ui:deSelect name="financialYear" codeType="FinancialYear" selectedValue="<%=selectedFinancialYear%>"/>
				</div>
			</td>
			<td class="tdSearch">
				<label for="quarterName" class="lblEn hor mandatory"><mc:msg key="cst0202.search.quarter"/></label>
				<div style="float:left;padding-right:4px;">
					<ui:ccselect name="quarterName" codeType="QUARTER_NAME" selectedValue="<%=selectedQuarterName%>"/>
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
			<col width="*"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="8%"/>
		</colgroup>
		<thead>
			<tr>
				<th class="thGrid"><mc:msg key="cst0202.grid.type"/></th>
				<th class="thGrid"><mc:msg key="cst0202.grid.jul"/></th>
				<th class="thGrid"><mc:msg key="cst0202.grid.aug"/></th>
				<th class="thGrid"><mc:msg key="cst0202.grid.sep"/></th>
				<th class="thGrid"><mc:msg key="cst0202.grid.oct"/></th>
				<th class="thGrid"><mc:msg key="cst0202.grid.nov"/></th>
				<th class="thGrid"><mc:msg key="cst0202.grid.dec"/></th>
				<th class="thGrid"><mc:msg key="cst0202.grid.jan"/></th>
				<th class="thGrid"><mc:msg key="cst0202.grid.feb"/></th>
				<th class="thGrid"><mc:msg key="cst0202.grid.mar"/></th>
				<th class="thGrid"><mc:msg key="cst0202.grid.apr"/></th>
				<th class="thGrid"><mc:msg key="cst0202.grid.may"/></th>
				<th class="thGrid"><mc:msg key="cst0202.grid.jun"/></th>
				<th class="thGrid"><mc:msg key="cst0202.grid.tot"/></th>
			</tr>
		</thead>
		<tbody id="tblGridBody">
			<tr>
				<td class="tdGrid Ct" colspan="14"><mc:msg key="I002"/></td>
			</tr>
		</tbody>
	</table>
</div>
<div id="divPagingArea"></div>
<div class="verGap10"></div>
<table class="tblDefault withPadding">
	<colgroup>
		<col width="*"/>
	</colgroup>
	<tr>
		<td class="tdDefault">
			<ui:img src="" id="imgChart"/>
		</td>
	</tr>
</table>
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