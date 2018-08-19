<%/************************************************************************************************
* Description - Rkm0804 - Payment
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
	String selectedFinancialYear = CommonUtil.nvl(paramFinancialYear, defaultPeriodYear);
	String selectedQuarterName = CommonUtil.nvl(paramQuarterName, defaultQuarterName);
	String surname = CommonUtil.nvl(requestDataSet.getValue("surname"));
	String givenName = CommonUtil.nvl(requestDataSet.getValue("givenName"));
	String visaType = CommonUtil.nvl(requestDataSet.getValue("visaType"));
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
var widthEmpListDiv, widthWageListDiv, empListWidthAdjust, wageListWidthAdjust;

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

	$("#icnDeStartDate").click(function(event) {
		commonJs.openCalendar(event, "deStartDate");
	});

	$("#icnDeEndDate").click(function(event) {
		commonJs.openCalendar(event, "deEndDate");
	});

	$("#financialYear").change(function() {
		doSearch();
	});

	$("#quarterName").change(function() {
		doSearch();
	});

	$("#visaType").change(function() {
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
		commonJs.showProcMessageOnElement("tblEmpList");

		setTimeout(function() {
			commonJs.ajaxSubmit({
				url:"/rkm/0804/getEmployeeList.do",
				dataType:"json",
				formId:"fmDefault",
				success:function(data, textStatus) {
					var result = commonJs.parseAjaxResult(data, textStatus, "json");

					if (result.isSuccess == true || result.isSuccess == "true") {
						renderEmpListGridTable(result);
					}
				}
			});
		}, 100);

		setSummaryDataForAdminTool();
	};

	renderEmpListGridTable = function(result) {
		var ds = result.dataSet;
		var html = "", totHtml = "";
		var grossTotal = 0, taxTotal = 0, netTotal = 0, superTotal = 0;

		$("#tblEmpListBody").html("");
		$("#tblEmpListFoot").html("");

		if (ds.getRowCnt() > 0) {
			for (var i=0; i<ds.getRowCnt(); i++) {
				grossTotal += parseFloat(ds.getValue(i, "GROSS_WAGE"));
				taxTotal += parseFloat(ds.getValue(i, "TAX"));
				netTotal += parseFloat(ds.getValue(i, "NET_WAGE"));
				superTotal += parseFloat(ds.getValue(i, "SUPER_AMT"));

				html += "<tr>";
				html += "<td class=\"tdGridCt\"><a onclick=\"getWageList('"+ds.getValue(i, "EMPLOYEE_ID")+"')\" class=\"aEn\">"+ds.getValue(i, "SURNAME")+"</a></td>";
				html += "<td class=\"tdGridCt\"><a onclick=\"getWageList('"+ds.getValue(i, "EMPLOYEE_ID")+"')\" class=\"aEn\">"+ds.getValue(i, "GIVEN_NAME")+"</a></td>";
				html += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(ds.getValue(i, "GROSS_WAGE"), "#,###.##")+"</td>";
				html += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(ds.getValue(i, "TAX"), "#,###.##")+"</td>";
				html += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(ds.getValue(i, "NET_WAGE"), "#,###.##")+"</td>";
				html += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(ds.getValue(i, "SUPER_AMT"), "#,###.##")+"</td>";
				html += "</tr>";
			}
		} else {
			html += "<tr>";
			html += "<td class=\"tdGridCt\" colspan=\"6\"><tag:msg key="I001"/></td>";
			html += "</tr>";
		}

		totHtml += "<tr>";
		totHtml += "<td class=\"tdGridCt\"><tag:msg key="rkm0804.grid.total"/></td>";
		totHtml += "<td class=\"tdGridCt\"></td>";
		totHtml += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(grossTotal, "#,###.##")+"</td>";
		totHtml += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(taxTotal, "#,###.##")+"</td>";
		totHtml += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(netTotal, "#,###.##")+"</td>";
		totHtml += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(superTotal, "#,###.##")+"</td>";
		totHtml += "</tr>";

		$("#tblEmpListBody").append($(html));
		$("#tblEmpListFoot").append($(totHtml));

		$("#tblEmpList").fixedHeaderTable({
			baseDivElement:"divEmpList",
			baseWidth:widthEmpListDiv,
			attachedPagingArea:true,
			pagingAreaId:"divEmpListPagingArea",
			totalResultRows:result.totalResultRows,
			setDummyPaging:true,
			widthAdjust:empListWidthAdjust
		});

		commonJs.hideProcMessageOnElement("tblEmpList");
		getWageList("");
	};

	getWageList = function(employeeId) {
		commonJs.showProcMessageOnElement("tblWageList");

		setTimeout(function() {
			commonJs.ajaxSubmit({
				url:"/rkm/0804/getWageList.do",
				dataType:"json",
				data:{employeeId:employeeId},
				success:function(data, textStatus) {
					var result = commonJs.parseAjaxResult(data, textStatus, "json");

					if (result.isSuccess == true || result.isSuccess == "true") {
						renderWageListGridTable(result);
					}
				}
			});
		}, 100);
	};

	renderWageListGridTable = function(result) {
		var ds = result.dataSet;
		var html = "", totHtml = "";
		var hourWorked = 0, grossTotal = 0, taxTotal = 0, netTotal = 0, superTotal = 0;

		$("#tblWageListBody").html("");
		$("#tblWageListFoot").html("");

		if (ds.getRowCnt() > 0) {
			for (var i=0; i<ds.getRowCnt(); i++) {
				hourWorked += parseFloat(ds.getValue(i, "HOUR_WORKED"));
				grossTotal += parseFloat(ds.getValue(i, "GROSS_WAGE"));
				taxTotal += parseFloat(ds.getValue(i, "TAX"));
				netTotal += parseFloat(ds.getValue(i, "NET_WAGE"));
				superTotal += parseFloat(ds.getValue(i, "SUPER_AMT"));

				html += "<tr>";
				html += "<td class=\"tdGridCt\">"+ds.getValue(i, "START_DATE")+"</td>";
				html += "<td class=\"tdGridCt\">"+ds.getValue(i, "END_DATE")+"</td>";
				html += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(ds.getValue(i, "HOURLY_RATE"), "#,###.##")+"</td>";
				html += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(ds.getValue(i, "HOUR_WORKED"), "#,###.##")+"</td>";
				html += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(ds.getValue(i, "GROSS_WAGE"), "#,###.##")+"</td>";
				html += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(ds.getValue(i, "TAX"), "#,###.##")+"</td>";
				html += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(ds.getValue(i, "NET_WAGE"), "#,###.##")+"</td>";
				html += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(ds.getValue(i, "SUPER_AMT"), "#,###.##")+"</td>";
				html += "<td class=\"tdGridCt\"><i id=\"icnAction\" name=\"icnAction\" class=\"fa fa-tasks fa-lg icnEn\" assetId=\""+ds.getValue(i, "EMPLOYEE_ID")+"\" onclick=\"doAction(this)\"></i></td>";
				html += "</tr>";
			}
		} else {
			html += "<tr>";
			html += "<td class=\"tdGridCt\" colspan=\"9\"><tag:msg key="I001"/></td>";
			html += "</tr>";
		}

		totHtml += "<tr>";
		totHtml += "<td class=\"tdGridCt\"><tag:msg key="rkm0804.grid.total"/></td>";
		totHtml += "<td class=\"tdGridCt\"></td>";
		totHtml += "<td class=\"tdGridCt\"></td>";
		totHtml += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(hourWorked, "#,###.##")+"</td>";
		totHtml += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(grossTotal, "#,###.##")+"</td>";
		totHtml += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(taxTotal, "#,###.##")+"</td>";
		totHtml += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(netTotal, "#,###.##")+"</td>";
		totHtml += "<td class=\"tdGridRt\">"+commonJs.getNumberMask(superTotal, "#,###.##")+"</td>";
		totHtml += "<td class=\"tdGridCt\"></td>";
		totHtml += "</tr>";

		$("#tblWageListBody").append($(html));
		$("#tblWageListFoot").append($(totHtml));

		$("#tblWageList").fixedHeaderTable({
			baseDivElement:"divWageList",
			baseWidth:widthWageListDiv,
			attachedPagingArea:true,
			pagingAreaId:"divWageListPagingArea",
			totalResultRows:result.totalResultRows,
			setDummyPaging:true,
			widthAdjust:wageListWidthAdjust
		});

		$("[name=icnAction]").each(function(index) {
			$(this).contextMenu(ctxMenu.dataEntrySalesAction);
		});

		commonJs.hideProcMessageOnElement("tblWageList");
	};

	openPopup = function(param) {
		var url = "", header = "";
		var height = 510;

		if (param.mode == "Detail") {
			url = "/rkm/0804/getDetail.do";
			header = "<tag:msg key="rkm0804.header.popupHeaderDetail"/>";
		} else if (param.mode == "New" || param.mode == "Reply") {
			url = "/rkm/0804/getInsert.do";
			header = "<tag:msg key="rkm0804.header.popupHeaderEdit"/>";
		} else if (param.mode == "Edit") {
			url = "/rkm/0804/getUpdate.do";
			header = "<tag:msg key="rkm0804.header.popupHeaderEdit"/>";
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
						url:"/rkm/0804/exeDelete.do",
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

		ctxMenu.boardAction[0].fun = function() {getDetail(articleId);};
		ctxMenu.boardAction[1].fun = function() {openPopup({mode:"Edit", articleId:articleId});};
		ctxMenu.boardAction[2].fun = function() {openPopup({mode:"Reply", articleId:articleId});};
		ctxMenu.boardAction[3].fun = function() {doDelete();};

		$(img).contextMenu(ctxMenu.boardAction, {
			classPrefix:"actionInGrid",
			displayAround:"trigger",
			position:"bottom",
			horAdjust:0,
			verAdjust:2
		});
	};

	getAttachedFile = function(img) {
		commonJs.ajaxSubmit({
			url:"/rkm/0804/getAttachedFile.do",
			dataType:"json",
			data:{
				articleId:$(img).attr("articleId")
			},
			blind:false,
			success:function(data, textStatus) {
				var result = commonJs.parseAjaxResult(data, textStatus, "json");

				if (result.isSuccess == true || result.isSuccess == "true") {
					var dataSet = result.dataSet;
					attchedFileContextMenu = [];

					for (var i=0; i<dataSet.getRowCnt(); i++) {
						var repositoryPath = dataSet.getValue(i, "REPOSITORY_PATH");
						var originalName = dataSet.getValue(i, "ORIGINAL_NAME");
						var newName = dataSet.getValue(i, "NEW_NAME");
						var fileIcon = dataSet.getValue(i, "FILE_ICON");
						var fileSize = dataSet.getValue(i, "FILE_SIZE")/1024;

						attchedFileContextMenu.push({
							name:originalName+" ("+commonJs.getNumberMask(fileSize, "0,0")+") KB",
							title:originalName,
							img:fileIcon,
							repositoryPath:repositoryPath,
							originalName:originalName,
							newName:newName,
							fun:function() {
								var index = $(this).index();

								downloadFile({
									repositoryPath:attchedFileContextMenu[index].repositoryPath,
									originalName:attchedFileContextMenu[index].originalName,
									newName:attchedFileContextMenu[index].newName
								});
							}
						});
					}

					$(img).contextMenu(attchedFileContextMenu, {
						classPrefix:"actionInGrid",
						displayAround:"trigger",
						position:"bottom",
						horAdjust:0,
						verAdjust:2
					});
				}
			}
		});
	};

	downloadFile = function(param) {
		commonJs.doSubmit({
			form:"fmDefault",
			action:"/download.do",
			data:{
				repositoryPath:param.repositoryPath,
				originalName:param.originalName,
				newName:param.newName
			}
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
						url:"/rkm/0804/exeExport.do",
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

	/*!
	 * load event (document / window)
	 */
	setGridSize = function() {
		var heightTemp = 0;
		if (commonJs.browser.FireFox) {
			heightTemp = 20;
		} else {
			heightTemp = 10;
		}

		$("#divEmpList").css("height", ($("#divScrollablePanel").height() - heightTemp));
		$("#divWageList").css("height", ($("#divScrollablePanel").height() - heightTemp));
		widthSourceDataDiv = $("#divEmpList").width();
		widthTargetDataDiv = $("#divWageList").width();
// $("#divEmpList").css("border", "1px solid red");
// $("#divWageList").css("border", "1px solid red");
	};

	setGridWidthAdjust = function() {
		if (commonJs.browser.FireFox) {
			empListWidthAdjust = 13;
			wageListWidthAdjust = 41;
		} else {
			empListWidthAdjust = 12;
			wageListWidthAdjust = 42;
		}
	};

	$(window).load(function() {
		setGridSize();
		setGridWidthAdjust();

		setExportButtonContextMenu();
		setDataEntryActionButtonContextMenu();

		commonJs.setAutoComplete($("#surname"), {
			method:"getEmployeeSurname",
			label:"surname",
			value:"surname",
			focus:function(event, ui) {
				$("#surname").val(ui.item.label);
				return false;
			},
			select:function(event, ui) {
				doSearch();
			}
		});

		commonJs.setAutoComplete($("#givenName"), {
			method:"getEmployeeGivenName",
			label:"given_name",
			value:"given_name",
			focus:function(event, ui) {
				$("#givenName").val(ui.item.label);
				return false;
			},
			select:function(event, ui) {
				doSearch();
			}
		});

		commonJs.setFieldDateMask("deStartDate");
		commonJs.setFieldDateMask("deEndDate");
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
			<col width="16%"/>
			<col width="16%"/>
			<col width="20%"/>
			<col width="20%"/>
			<col width="14%"/>
			<col width="*"/>
		</colgroup>
		<tr>
			<td class="tdSearch">
				<label for="financialYear" class="lblEn hor mandatory"><tag:msg key="rkm0804.search.financialYear"/></label>
				<div style="float:left;padding-right:4px;">
					<tag:deSelect id="financialYear" name="financialYear" codeType="FinancialYear" selectedValue="<%=selectedFinancialYear%>"/>
				</div>
			</td>
			<td class="tdSearch">
				<label for="quarterName" class="lblEn hor mandatory"><tag:msg key="rkm0804.search.quarter"/></label>
				<div style="float:left;padding-right:4px;">
					<tag:select id="quarterName" name="quarterName" codeType="QUARTER_NAME" selectedValue="<%=selectedQuarterName%>"/>
				</div>
			</td>
			<td class="tdSearch">
				<label for="surname" class="lblEn hor"><tag:msg key="rkm0804.search.surname"/></label>
				<input type="text" id="surname" name="surname" class="txtEn hor" style="width:200px;"/>
			</td>
			<td class="tdSearch">
				<label for="givenName" class="lblEn hor"><tag:msg key="rkm0804.search.givenName"/></label>
				<input type="text" id="givenName" name="givenName" class="txtEn hor" style="width:200px;"/>
			</td>
			<td class="tdSearch">
				<label for="visaType" class="lblEn hor"><tag:msg key="rkm0804.search.visaType"/></label>
				<div style="float:left;padding-right:4px;">
					<tag:select id="visaType" name="visaType" codeType="VISA_TYPE" caption="==Select=="/>
				</div>
			</td>
		</tr>
	</table>
</div>
<div id="divInformArea" class="areaContainer">
	<table class="tblDataEntry">
		<caption><tag:msg key="page.com.dataEntry"/></caption>
		<colgroup>
			<col width="10%"/>
			<col width="10%"/>
			<col width="13%"/>
			<col width="13%"/>
			<col width="13%"/>
			<col width="12%"/>
			<col width="12%"/>
			<col width="12%"/>
			<col width="*"/>
		</colgroup>
		<tr>
			<th class="thDataEntryCt mandatory"><tag:msg key="rkm0804.de.startDate"/></th>
			<th class="thDataEntryCt mandatory"><tag:msg key="rkm0804.de.endDate"/></th>
			<th class="thDataEntryCt mandatory"><tag:msg key="rkm0804.de.hourlyRate"/></th>
			<th class="thDataEntryCt mandatory"><tag:msg key="rkm0804.de.hoursWorked"/></th>
			<th class="thDataEntryCt mandatory"><tag:msg key="rkm0804.de.grossWage"/></th>
			<th class="thDataEntryCt"><tag:msg key="rkm0804.de.tax"/></th>
			<th class="thDataEntryCt"><tag:msg key="rkm0804.de.netWage"/></th>
			<th class="thDataEntryCt"><tag:msg key="rkm0804.de.super"/></th>
			<th class="thDataEntryCt"><tag:msg key="rkm0804.de.action"/></th>
		</tr>
		<tr>
			<td class="tdDataEntryCt">
				<div style="display:inline-block;">
					<input type="text" id="deStartDate" name="deStartDate" class="txtEnCt hor" style="width:100px" checkName="<tag:msg key="rkm0804.de.startDate"/>" mandatory option="date"/>
					<i id="icnDeStartDate" class="fa fa-calendar icnEn hor"></i>
				</div>
			</td>
			<td class="tdDataEntryCt">
				<div style="display:inline-block;">
					<input type="text" id="deEndDate" name="deEndDate" class="txtEnCt hor" style="width:100px" checkName="<tag:msg key="rkm0804.de.endDate"/>" mandatory option="date"/>
					<i id="icnDeEndDate" class="fa fa-calendar icnEn hor"></i>
				</div>
			</td>
			<td class="tdDataEntryCt">
				<input type="text" id="deHourlyRate" name="deHourlyRate" class="txtEnRt numeric" checkName="<tag:msg key="rkm0804.de.hourlyRate"/>" mandatory option="numeric"/>
			</td>
			<td class="tdDataEntryCt">
				<input type="text" id="deHoursWorked" name="deHoursWorked" class="txtEnRt numeric" checkName="<tag:msg key="rkm0804.de.hoursWorked"/>" mandatory option="numeric"/>
			</td>
			<td class="tdDataEntryCt">
				<input type="text" id="deGrossWage" name="deGrossWage" class="txtEnRt numeric" checkName="<tag:msg key="rkm0804.de.grossWage"/>" mandatory option="numeric"/>
			</td>
			<td class="tdDataEntryCt">
				<input type="text" id="deTax" name="deTax" class="txtDplRt numeric"/>
			</td>
			<td class="tdDataEntryCt">
				<input type="text" id="deNetWage" name="deNetWage" class="txtDplRt numeric"/>
			</td>
			<td class="tdDataEntryCt">
				<input type="text" id="deSuper" name="deSuper" class="txtDplRt numeric"/>
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
	<div id="divEmpList" style="float:left;width:40%;">
		<table id="tblEmpList" class="tblGrid sort autosort">
			<colgroup>
				<col width="17%"/>
				<col width="*"/>
				<col width="16%"/>
				<col width="15%"/>
				<col width="15%"/>
				<col width="15%"/>
			</colgroup>
			<thead>
				<tr>
					<th class="thGrid sortable:alphanumeric"><tag:msg key="rkm0804.grid.surname"/></th>
					<th class="thGrid sortable:alphanumeric"><tag:msg key="rkm0804.grid.givenName"/></th>
					<th class="thGrid"><tag:msg key="rkm0804.grid.grossWage"/></th>
					<th class="thGrid"><tag:msg key="rkm0804.grid.tax"/></th>
					<th class="thGrid"><tag:msg key="rkm0804.grid.netWage"/></th>
					<th class="thGrid"><tag:msg key="rkm0804.grid.super"/></th>
				</tr>
			</thead>
			<tbody id="tblEmpListBody">
				<tr>
					<td class="tdGridCt" colspan="6"><tag:msg key="I002"/></td>
				</tr>
			</tbody>
			<tfoot id="tblEmpListFoot" style="font-weight:bold;">
			</tfoot>
		</table>
		<div id="divEmpListPagingArea"></div>
	</div>
	<div id="divWageList" style="float:right;width:59%;">
		<table id="tblWageList" class="tblGrid sort autosort">
			<colgroup>
				<col width="10%"/>
				<col width="10%"/>
				<col width="14%"/>
				<col width="14%"/>
				<col width="14%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="*"/>
			</colgroup>
			<thead>
				<tr>
					<th class="thGrid"><tag:msg key="rkm0804.grid.startDate"/></th>
					<th class="thGrid"><tag:msg key="rkm0804.grid.endDate"/></th>
					<th class="thGrid"><tag:msg key="rkm0804.grid.hoursWorked"/></th>
					<th class="thGrid"><tag:msg key="rkm0804.grid.hourlyRate"/></th>
					<th class="thGrid"><tag:msg key="rkm0804.grid.grossWage"/></th>
					<th class="thGrid"><tag:msg key="rkm0804.grid.tax"/></th>
					<th class="thGrid"><tag:msg key="rkm0804.grid.netWage"/></th>
					<th class="thGrid"><tag:msg key="rkm0804.grid.super"/></th>
					<th class="thGrid"><tag:msg key="page.com.action"/></th>
				</tr>
			</thead>
			<tbody id="tblWageListBody">
				<tr>
					<td class="tdGridCt" colspan="9"><tag:msg key="I002"/></td>
				</tr>
			</tbody>
			<tfoot id="tblWageListFoot" style="font-weight:bold;">
			</tfoot>
		</table>
		<div id="divWageListPagingArea"></div>
	</div>
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