<%/************************************************************************************************
* Description - Sba0414 - Lending Type
*   - Generated by Source Generator
************************************************************************************************/%>
<%@ include file="/shared/page/incCommon.jsp"%>
<%/************************************************************************************************
* Declare objects & variables
************************************************************************************************/%>
<%
	ParamEntity paramEntity = (ParamEntity)request.getAttribute("paramEntity");
%>
<%/************************************************************************************************
* HTML
************************************************************************************************/%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<link rel="icon" type="image/png" href="<tag:cp key="imgIcon"/>/favicon.png">
<title><tag:msg key="main.system.title"/></title>
<%/************************************************************************************************
* Stylesheet & Javascript
************************************************************************************************/%>
<%@ include file="/shared/page/incCssJs.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript">
var popup = null;
var searchResultDataCount = 0;

$(function() {
	/*!
	 * event
	 */
		$("#icnCheck").click(function(event) {
			commonJs.toggleCheckboxes("chkToAssign");
		});

		$("#orgCategory").change(function(event) {
			doSearch();
		});

		$(document).keypress(function(event) {
			if (event.which == 13) {
				var element = event.target;
			}
		});

	/*!
	 * context menus
	 */

	/*!
	 * process
	 */
	doSearch = function() {
		commonJs.showProcMessageOnElement("tblGrid");

		setTimeout(function() {
			commonJs.ajaxSubmit({
				url:"/sba/0414/getList.do",
				dataType:"json",
				formId:"fmDefault",
				success:function(data, textStatus) {
					var result = commonJs.parseAjaxResult(data, textStatus, "json");

					if (result.isSuccess == true || result.isSuccess == "true") {
						renderDataGridTable(result);
					}
				}
			});
		}, 100);
	};

	renderDataGridTable = function(result) {
		var ds = result.dataSet;
		var html = "";

		searchResultDataCount = ds.getRowCnt();
		$("#tblGridBody").html("");

		if (ds.getRowCnt() > 0) {
			for (var i=0; i<ds.getRowCnt(); i++) {
				var checkString = "";

				if (!commonJs.isEmpty(ds.getValue(i, "LENDING_TYPE_ID"))) {
					checkString = "checked";
				}

				html += "<tr>";
				html += "<td class=\"tdGridCt\"><input type=\"checkbox\" id=\"chkToAssign\" name=\"chkToAssign\" class=\"chkEn inTblGrid\" "+checkString+" value=\""+ds.getValue(i, "LENDING_TYPE_ID")+"_"+ds.getValue(i, "LENDING_TYPE_CODE")+"\"/></td>";
				html += "<td class=\"tdGrid\"><a onclick=\"getDetail('"+ds.getValue(i, "LENDING_TYPE_ID")+"', '"+ds.getValue(i, "LENDING_TYPE_CODE")+"')\" class=\"aEn\">"+ds.getValue(i, "LENDING_TYPE_NAME")+"</a>";
				html += "<td class=\"tdGridCt\">"+ds.getValue(i, "IS_APPLY_GST")+"</td>";
				html += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(ds.getValue(i, "GST_PERCENTAGE"), "#,###.##")+"</td>";
				html += "<td class=\"tdGridCt\">"+ds.getValue(i, "ACCOUNT_CODE")+"</td>";
				html += "<td class=\"tdGridCt\">"+ds.getValue(i, "INSERT_DATE")+"</td>";
				html += "<td class=\"tdGridCt\">"+ds.getValue(i, "UPDATE_DATE")+"</td>";
				html += "</tr>";
			}
		} else {
			html += "<tr>";
			html += "<td class=\"tdGridCt\" colspan=\"7\"><tag:msg key="I001"/></td>";
			html += "</tr>";
		}

		$("#tblGridBody").append($(html));
		if (commonJs.browser.FireFox) {
			gridWidthAdjust = 76;
		} else {
			gridWidthAdjust = 82;
		}

		$("#tblGrid").fixedHeaderTable({
			baseDivElement:"divScrollablePanel",
			blockElementId:"tblGrid",
			widthAdjust:gridWidthAdjust
		});

		commonJs.hideProcMessageOnElement("tblGrid");
	};

	getDetail = function(taxMasterId) {
		openPopup({mode:"Detail", taxMasterId:taxMasterId});
	};

	openPopup = function(param) {
		var url = "", header = "";
		var height = 510;

		if (param.mode == "Detail") {
			url = "/sba/0414/getDetail.do";
			header = "<tag:msg key="sba0414.header.popupHeaderDetail"/>";
		} else if (param.mode == "New") {
			url = "/sba/0414/getInsert.do";
			header = "<tag:msg key="sba0414.header.popupHeaderEdit"/>";
		} else if (param.mode == "Edit") {
			url = "/sba/0414/getUpdate.do";
			header = "<tag:msg key="sba0414.header.popupHeaderEdit"/>";
			height = 634;
		}

		var popParam = {
			popupId:"notice"+param.mode,
			url:url,
			paramData:{
				mode:param.mode,
				articleId:commonJs.nvl(param.articleId, "")
			},
			header:header,
			blind:true,
			width:800,
			height:height
		};

		popup = commonJs.openPopup(popParam);
	};

	/*!
	 * load event (document / window)
	 */
	$(window).load(function() {
		setTimeout(function() {
			doSearch();
		}, 400);
	});
});
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
		<tag:buttonGroup id="buttonGroup">
			<tag:button id="btnSave" caption="button.com.save" iconClass="fa-save"/>
		</tag:buttonGroup>
	</div>
</div>
<div id="divSearchCriteriaArea" class="areaContainer">
	<table class="tblSearch">
		<caption><tag:msg key="page.com.searchCriteria"/></caption>
		<tr>
			<td class="tdSearch">
				<label for="orgCategory" class="lblEn hor mandatory"><tag:msg key="sba0414.search.orgCategory"/></label>
				<div style="float:left;padding-right:4px;">
					<tag:select id="orgCategory" name="orgCategory" codeType="ORG_CATEGORY" caption=""/>
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
			<col width="4%"/>
			<col width="*"/>
			<col width="15%"/>
			<col width="15%"/>
			<col width="15%"/>
			<col width="10%"/>
			<col width="10%"/>
		</colgroup>
		<thead>
			<tr>
				<th class="thGrid"><i id="icnCheck" class="fa fa-check-square-o fa-lg icnEn"></i></th>
				<th class="thGrid sortable:alphanumeric"><tag:msg key="sba0414.grid.lendingType"/></th>
				<th class="thGrid"><tag:msg key="sba0414.grid.isApplyGst"/></th>
				<th class="thGrid"><tag:msg key="sba0414.grid.gstPercentage"/></th>
				<th class="thGrid"><tag:msg key="sba0414.grid.accountCode"/></th>
				<th class="thGrid"><tag:msg key="sba0414.grid.insertDate"/></th>
				<th class="thGrid"><tag:msg key="sba0414.grid.updateDate"/></th>
			</tr>
		</thead>
		<tbody id="tblGridBody">
			<tr>
				<td class="tdGridCt" colspan="7"><tag:msg key="I002"/></td>
			</tr>
		</tbody>
	</table>
	<div id="divPagingArea"></div>
</div>
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