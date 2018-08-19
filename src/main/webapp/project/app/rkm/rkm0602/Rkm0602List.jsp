<%/************************************************************************************************
* Description - Rkm0602 - Repayment
*   - Generated by Source Generator
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
	String paramRepaymentType = requestDataSet.getValue("repaymentType");
	String selectedFinancialYear = CommonUtil.nvl(paramFinancialYear, defaultPeriodYear);
	String selectedQuarterName = CommonUtil.nvl(paramQuarterName, defaultQuarterName);
	String selectedRepaymentType = CommonUtil.nvl(paramRepaymentType);
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
var repaymentTypeMenu = [];

$(function() {
	/*!
	 * event
	 */
	$("#btnNew").click(function(event) {
		openPopup({mode:"New"});
	});

	$("#btnDelete").click(function(event) {
		doDelete();
	});

	$("#btnSearch").click(function(event) {
		doSearch();
	});

	$("#btnClear").click(function(event) {
		commonJs.clearSearchCriteria();
	});

	$("#icnCheck").click(function(event) {
		commonJs.toggleCheckboxes("chkForDel");
	});

	$("#icnDataEntryDate").click(function(event) {
		commonJs.openCalendar(event, "deDate");
	});

	$("#financialYear").change(function() {
		doSearch();
	});

	$("#quarterName").change(function() {
		doSearch();
	});

	$("#repaymentType").change(function() {
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
	setExportButtonContextMenu = function() {
		ctxMenu.commonExport[0].fun = function() {exeExport(ctxMenu.commonExport[0]);};
		ctxMenu.commonExport[1].fun = function() {exeExport(ctxMenu.commonExport[1]);};
		ctxMenu.commonExport[2].fun = function() {exeExport(ctxMenu.commonExport[2]);};
		ctxMenu.commonExport[3].fun = function() {exeExport(ctxMenu.commonExport[3]);};
		ctxMenu.commonExport[4].fun = function() {exeExport(ctxMenu.commonExport[4]);};
		ctxMenu.commonExport[5].fun = function() {exeExport(ctxMenu.commonExport[5]);};

		$("#btnExport").contextMenu(ctxMenu.commonExport, {
			classPrefix:"actionButton",
			effectDuration:300,
			effect:"slide",
			borderRadius:"bottom 4px",
			displayAround:"trigger",
			position:"bottom",
			horAdjust:0
		});
	};

	setDeRepaymentTypeContextMenu = function() {
		commonJs.ajaxSubmit({
			url:"/common/entryTypeSupporter/getRepaymentTypeForContextMenu.do",
			dataType:"json",
			data:{},
			success:function(data, textStatus) {
				var result = commonJs.parseAjaxResult(data, textStatus, "json");
				if (result.isSuccess == true || result.isSuccess == "true") {
					var ds = result.dataSet;

					if (ds.getRowCnt() > 0) {
						for (var i=0; i<ds.getRowCnt(); i++) {
							var repaymentType = ds.getValue(i, "REPAYMENT_TYPE");

							repaymentTypeMenu.push({
								name:ds.getValue(i, "DESCRIPTION"),
								userData:repaymentType,
								fun:function() {
									setDeRepaymentTypeSelectbox($(this).attr("userData"));
								}
							});
						}
					}
				} else {
					commonJs.error(result.message);
				}
			}
		});

		$("#btnDeRepaymentType").contextMenu(repaymentTypeMenu, {
			borderRadius : "4px",
			displayAround : "trigger",
			position : "bottom",
			horAdjust : 0,
			verAdjust : 0
		});
	};

	setDataEntryActionButtonContextMenu = function() {
		ctxMenu.dataEntryAction[0].fun = function() {};
		ctxMenu.dataEntryAction[1].fun = function() {};
		ctxMenu.dataEntryAction[2].fun = function() {};

		$("#icnDataEntryAction").contextMenu(ctxMenu.dataEntryAction, {
			classPrefix:"actionInGrid",
			effectDuration:300,
			borderRadius:"bottom 4px",
			displayAround:"trigger",
			position:"bottom",
			horAdjust:0
		});
	};

	/*!
	 * process
	 */
	doSearch = function() {
		commonJs.showProcMessageOnElement("tblGrid");

		setTimeout(function() {
			commonJs.ajaxSubmit({
				url:"/rkm/0602/getList.do",
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

		setSummaryDataForAdminTool();
	};

	renderDataGridTable = function(result) {
		var ds = result.dataSet;
		var html = "", totHtml = "";
		var totAmt = 0;

		searchResultDataCount = ds.getRowCnt();
		$("#tblGridBody").html("");
		$("#tblGridFoot").html("");

		if (ds.getRowCnt() > 0) {
			for (var i=0; i<ds.getRowCnt(); i++) {
				totAmt += parseFloat(ds.getValue(i, "REPAYMENT_AMT"));

				html += "<tr>";
				html += "<td class=\"tdGridCt\"><input type=\"checkbox\" id=\"chkForDel\" name=\"chkForDel\" class=\"chkEn inTblGrid\" value=\""+ds.getValue(i, "FINANCE_ID")+"\"/></td>";
				html += "<td class=\"tdGridCt\"><a onclick=\"getDetail('"+ds.getValue(i, "FINANCE_ID")+"')\" class=\"aEn\">"+ds.getValue(i, "FINANCE_DATE")+"</a></td>";
				html += "<td class=\"tdGridLt\">"+commonJs.abbreviate(ds.getValue(i, "FINANCE_TYPE_DESC"), 60)+"</td>";
				html += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(ds.getValue(i, "REPAYMENT_AMT"), "#,###.##")+"</td>";
				html += "<td class=\"tdGridLt\">"+commonJs.abbreviate(ds.getValue(i, "DESCRIPTION"), 60)+"</td>";
				html += "<td class=\"tdGridCt\">"+ds.getValue(i, "IS_COMPLETED")+"</td>";
				html += "<td class=\"tdGridCt\">"+ds.getValue(i, "ENTRY_DATE")+"</td>";
				html += "<td class=\"tdGridCt\"><i id=\"icnAction\" name=\"icnAction\" class=\"fa fa-tasks fa-lg icnEn\" assetId=\""+ds.getValue(i, "FINANCE_ID")+"\" onclick=\"doAction(this)\"></i></td>";
				html += "</tr>";
			}
		} else {
			html += "<tr>";
			html += "<td class=\"tdGridCt\" colspan=\"8\"><tag:msg key="I001"/></td>";
			html += "</tr>";
		}

		totHtml += "<tr>";
		totHtml += "<td class=\"tdGridCt\"></td>";
		totHtml += "<td class=\"tdGridCt\"></td>";
		totHtml += "<td class=\"tdGridCt\"><tag:msg key="rkm0602.grid.repaymentTotal"/></td>";
		totHtml += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(totAmt, "#,###.##")+"</td>";
		totHtml += "<td class=\"tdGridCt\"></td>";
		totHtml += "<td class=\"tdGridCt\"></td>";
		totHtml += "<td class=\"tdGridCt\"></td>";
		totHtml += "<td class=\"tdGridCt\"></td>";
		totHtml += "</tr>";

		$("#tblGridBody").append($(html));
		$("#tblGridFoot").append($(totHtml));
		if (commonJs.browser.FireFox) {
			gridWidthAdjust = 31;
			baseHeight = $("#divScrollablePanel").height() - 1;
		} else {
			gridWidthAdjust = 33;
			baseHeight = $("#divScrollablePanel").height() - 1;
		}

		$("#tblGrid").fixedHeaderTable({
			baseDivElement:"divScrollablePanel",
			attachedPagingArea:true,
			blockElementId:"tblGrid",
			pagingAreaId:"divPagingArea",
			totalResultRows:result.totalResultRows,
			script:"doSearch",
			baseHeight:baseHeight,
			widthAdjust:gridWidthAdjust
		});

		$("[name=icnAction]").each(function(index) {
			$(this).contextMenu(ctxMenu.dataEntrySalesAction);
		});

		commonJs.hideProcMessageOnElement("tblGrid");
	};

	getDetail = function(articleId) {
		openPopup({mode:"Detail", articleId:articleId});
	};

	openPopup = function(param) {
		var url = "", header = "";
		var height = 510;

		if (param.mode == "Detail") {
			url = "/rkm/0602/getDetail.do";
			header = "<tag:msg key="rkm0602.header.popupHeaderDetail"/>";
		} else if (param.mode == "New" || param.mode == "Reply") {
			url = "/rkm/0602/getInsert.do";
			header = "<tag:msg key="rkm0602.header.popupHeaderEdit"/>";
		} else if (param.mode == "Edit") {
			url = "/rkm/0602/getUpdate.do";
			header = "<tag:msg key="rkm0602.header.popupHeaderEdit"/>";
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

	doDelete = function() {
		if (commonJs.getCountChecked("chkForDel") == 0) {
			commonJs.warn("<tag:msg key="I902"/>");
			return;
		}

		commonJs.confirm({
			contents:"<tag:msg key="Q002"/>",
			buttons:[{
				caption:"Yes",
				callback:function() {
					commonJs.ajaxSubmit({
						url:"/rkm/0602/exeDelete.do",
						dataType:"json",
						formId:"fmDefault",
						success:function(data, textStatus) {
							var result = commonJs.parseAjaxResult(data, textStatus, "json");

							if (result.isSuccess == true || result.isSuccess == "true") {
								commonJs.openDialog({
									type:"information",
									contents:result.message,
									blind:true,
									buttons:[{
										caption:"Ok",
										callback:function() {
											doSearch();
										}
									}]
								});
							} else {
								commonJs.error(result.message);
							}
						}
					});
				}
			}, {
				caption:"No",
				callback:function() {
				}
			}],
			blind:true
		});
	};

	doAction = function(img) {
		var articleId = $(img).attr("articleId");

		$("input:checkbox[name=chkForDel]").each(function(index) {
			if (!$(this).is(":disabled") && $(this).val() == articleId) {
				$(this).prop("checked", true);
			} else {
				$(this).prop("checked", false);
			}
		});

		ctxMenu.dataEntrySalesAction[0].fun = function() {openPopup({mode:"Edit", articleId:articleId});};
		ctxMenu.dataEntrySalesAction[1].fun = function() {doDelete();};

		$(img).contextMenu(ctxMenu.dataEntrySalesAction, {
			classPrefix:"actionInGrid",
			displayAround:"trigger",
			position:"bottom",
			horAdjust:0,
			verAdjust:2
		});
	};

	exeExport = function(menuObject) {
		$("[name=fileType]").remove();
		$("[name=dataRange]").remove();

		if (searchResultDataCount <= 0) {
			commonJs.warn("<tag:msg key="I001"/>");
			return;
		}

		commonJs.confirm({
			contents:"<tag:msg key="Q003"/>",
			buttons:[{
				caption:"Yes",
				callback:function() {
					popup = commonJs.openPopup({
						popupId:"exportFile",
						url:"/rkm/0602/exeExport.do",
						paramData:{
							fileType:menuObject.fileType,
							dataRange:menuObject.dataRange
						},
						header:"exportFile",
						blind:false,
						width:200,
						height:100
					});
					setTimeout(function() {popup.close();}, 3000);
				}
			}, {
				caption:"No",
				callback:function() {
				}
			}],
			blind:true
		});
	};

	setDeRepaymentTypeSelectbox = function(type) {
		$("#deRepaymentType").val(type);
		$("#deRepaymentType").selectpicker("val", type);
	};

	/*!
	 * load event (document / window)
	 */
	$(window).load(function() {
		setExportButtonContextMenu();
		setDeRepaymentTypeContextMenu();
		setDataEntryActionButtonContextMenu();

		commonJs.setFieldDateMask("deDate");
		$(".numeric").number(true, 2);

		setTimeout(function() {
			doSearch();
		}, 300);
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
			<tag:button id="btnNew" caption="button.com.new" iconClass="fa-plus-square"/>
			<tag:button id="btnDelete" caption="button.com.delete" iconClass="fa-trash"/>
			<tag:button id="btnSearch" caption="button.com.search" iconClass="fa-search"/>
			<tag:button id="btnClear" caption="button.com.clear" iconClass="fa-refresh"/>
			<tag:button id="btnExport" caption="button.com.export" iconClass="fa-download"/>
		</tag:buttonGroup>
	</div>
</div>
<div id="divAdminToolArea"><%@ include file="/project/common/include/bodyAdminToolArea.jsp"%></div>
<div id="divSearchCriteriaArea" class="areaContainer">
	<table class="tblSearch">
		<caption><tag:msg key="page.com.searchCriteria"/></caption>
		<colgroup>
			<col width="33%"/>
			<col width="33%"/>
			<col width="*"/>
		</colgroup>
		<tr>
			<td class="tdSearch">
				<label for="financialYear" class="lblEn hor mandatory"><tag:msg key="rkm0602.search.financialYear"/></label>
				<div style="float:left;padding-right:4px;">
					<tag:deSelect id="financialYear" name="financialYear" codeType="FinancialYear" selectedValue="<%=selectedFinancialYear%>"/>
				</div>
			</td>
			<td class="tdSearch">
				<label for="quarterName" class="lblEn hor mandatory"><tag:msg key="rkm0602.search.quarter"/></label>
				<div style="float:left;padding-right:4px;">
					<tag:select id="quarterName" name="quarterName" codeType="QUARTER_NAME" selectedValue="<%=selectedQuarterName%>"/>
				</div>
			</td>
			<td class="tdSearch">
				<label for="repaymentType" class="lblEn hor mandatory"><tag:msg key="rkm0602.search.repaymentType"/></label>
				<div style="float:left;padding-right:4px;">
					<tag:deSelect id="repaymentType" name="repaymentType" codeType="RepaymentType" caption="==Select==" orgCategory="<%=orgCategory%>" selectedValue="<%=selectedRepaymentType%>"/>
				</div>
			</td>
		</tr>
	</table>
</div>
<div id="divInformArea" class="areaContainer">
	<table class="tblDataEntry">
		<caption><tag:msg key="page.com.dataEntry"/></caption>
		<colgroup>
			<col width="9%"/>
			<col width="13%"/>
			<col width="13%"/>
			<col width="9%"/>
			<col width="*"/>
			<col width="4%"/>
		</colgroup>
		<tr>
			<th class="thDataEntryCt mandatory"><tag:msg key="rkm0602.de.date"/></th>
			<th class="thDataEntryCt mandatory"><tag:msg key="rkm0602.de.repaymentType"/></th>
			<th class="thDataEntryCt mandatory"><tag:msg key="rkm0602.de.repaymentType"/></th>
			<th class="thDataEntryCt mandatory"><tag:msg key="rkm0602.de.repaymentAmt"/></th>
			<th class="thDataEntryCt"><tag:msg key="rkm0602.de.remark"/></th>
			<th class="thDataEntryCt"><tag:msg key="rkm0602.de.action"/></th>
		</tr>
		<tr>
			<td class="tdDataEntryCt">
				<div style="display:inline-block;">
					<input type="text" id="deDate" name="deDate" class="txtEnCt hor" style="width:100px" checkName="<tag:msg key="rkm0602.de.date"/>" mandatory option="date"/>
					<i id="icnDataEntryDate" class="fa fa-calendar icnEn hor"></i>
				</div>
			</td>
			<td class="tdDataEntryCt">
				<tag:button id="btnDeRepaymentType" caption="rkm0602.de.repaymentType" iconClass="fa-caret-down"/>
			</td>
			<td class="tdDataEntryCt">
				<tag:deSelect id="deRepaymentType" name="deRepaymentType" codeType="RepaymentType" caption="==Select==" orgCategory="<%=orgCategory%>" options="mandatory"/>
			</td>
			<td class="tdDataEntryCt">
				<input type="text" id="deRepaymentAmt" name="deRepaymentAmt" class="txtEnRt numeric" checkName="<tag:msg key="rkm0602.de.repaymentAmt"/>" mandatory option="numeric"/>
			</td>
			<td class="tdDataEntryCt">
				<input type="text" id="deRemark" name="deRemark" class="txtEn"/>
			</td>
			<td class="tdDataEntryCt">
				<i id="icnDataEntryAction" class="fa fa-tasks fa-lg icnEn" onclick="doDataEntryAction(this)"></i>
			</td>
		</tr>
	</table>
</div>
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
			<col width="3%"/>
			<col width="6%"/>
			<col width="15%"/>
			<col width="12%"/>
			<col width="*"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="4%"/>
		</colgroup>
		<thead>
			<tr>
				<th class="thGrid"><i id="icnCheck" class="fa fa-check-square-o fa-lg icnEn"></i></th>
				<th class="thGrid sortable:date"><tag:msg key="rkm0602.grid.date"/></th>
				<th class="thGrid"><tag:msg key="rkm0602.grid.repaymentType"/></th>
				<th class="thGrid"><tag:msg key="rkm0602.grid.repaymentAmt"/></th>
				<th class="thGrid"><tag:msg key="rkm0602.grid.remark"/></th>
				<th class="thGrid"><tag:msg key="rkm0602.grid.isCompleted"/></th>
				<th class="thGrid sortable:date"><tag:msg key="rkm0602.grid.updateDate"/></th>
				<th class="thGrid"><tag:msg key="page.com.action"/></th>
			</tr>
		</thead>
		<tbody id="tblGridBody">
			<tr>
				<td class="tdGridCt" colspan="8"><tag:msg key="I002"/></td>
			</tr>
		</tbody>
		<tfoot id="tblGridFoot" style="font-weight:bold;">
		</tfoot>
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