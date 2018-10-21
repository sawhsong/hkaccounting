<%/************************************************************************************************
* Description - Sys0406 - User
*   - Generated by Source Generator
************************************************************************************************/%>
<%@ include file="/webapp/shared/page/incCommon.jsp"%>
<%/************************************************************************************************
* Declare objects & variables
************************************************************************************************/%>
<%
	ParamEntity paramEntity = (ParamEntity)request.getAttribute("paramEntity");
	DataSet resultDataSet = (DataSet)paramEntity.getObject("resultDataSet");
	DataSet authGroupDataSet = (DataSet)paramEntity.getObject("authGroupDataSet");
	String viewMode = CommonUtil.nvl((String)paramEntity.getObject("viewMode"));
	String langCode = (String)session.getAttribute("langCode");
	String messageCode = CommonUtil.isBlank(viewMode) ? "I001" : "I002";
%>
<%/************************************************************************************************
* HTML
************************************************************************************************/%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title><tag:msg key="main.system.title"/></title>
<%/************************************************************************************************
* Stylesheet & Javascript
************************************************************************************************/%>
<%@ include file="/webapp/shared/page/incCssJs.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript">
var popup = null;

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

	$(document).keypress(function(event) {
		if (event.which == 13) {
			var element = event.target;

			if ($(element).is("[name=userId]") || $(element).is("[name=userName]")) {
				doSearch();
			}
		}
	});

	/*!
	 * process
	 */
	doSearch = function() {
		commonJs.doSubmit({action:"/sys/0406/getList.do"});
	};

	getDetail = function(userId) {
		openPopup({mode:"Detail", userId:userId});
	};

	openPopup = function(param) {
		var url = "", header = "", width = 880, height = 516;

		if (param.mode == "Detail") {
			url = "/sys/0406/getDetail.do";
			header = "<tag:msg key="sys0406.header.popupHeaderDetail"/>";
			height = 446;
		} else if (param.mode == "New") {
			url = "/sys/0406/getInsert.do";
			header = "<tag:msg key="sys0406.header.popupHeaderEdit"/>";
			height = 616;
		} else if (param.mode == "Edit") {
			url = "/sys/0406/getUpdate.do";
			header = "<tag:msg key="sys0406.header.popupHeaderEdit"/>";
			height = 616;
		} else if (param.mode == "UpdateAuthGroup") {
			url = "/sys/0406/getActionContextMenu.do";
			header = "<tag:msg key="sys0406.ctxMenu.auth"/>";
			width = 330; height = 236;
		} else if (param.mode == "UpdateUserType") {
			url = "/sys/0406/getActionContextMenu.do";
			header = "<tag:msg key="sys0406.ctxMenu.type"/>";
			width = 330; height = 176;
		} else if (param.mode == "UpdateUserStatus") {
			url = "/sys/0406/getActionContextMenu.do";
			header = "<tag:msg key="sys0406.ctxMenu.status"/>";
			width = 330; height = 216;
		} else if (param.mode == "UpdateActiveStatus") {
			url = "/sys/0406/getActionContextMenu.do";
			header = "<tag:msg key="sys0406.ctxMenu.active"/>";
			width = 330; height = 176;
		}

		if (url.indexOf("getActionContextMenu") != -1) {
			if (commonJs.getCountChecked("chkForDel") == 0) {
				commonJs.warn("<tag:msg key="I902"/>");
				return;
			}
		}

		var popParam = {
			popupId:"user"+param.mode,
			url:url,
			paramData:{
				mode:param.mode,
				userId:commonJs.nvl(param.userId, "")
			},
			header:header,
			blind:true,
			width:width,
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
					exeDelete();
				}
			}, {
				caption:"No",
				callback:function() {
				}
			}],
			blind:true
		});
	};

	exeDelete = function() {
		commonJs.ajaxSubmit({
			url:"/sys/0406/exeDelete.do",
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
					commonJs.warn(result.message);
				}
			}
		});
	};

	doAction = function(img) {
		var userId = $(img).attr("userId");

		$("input:checkbox[name=chkForDel]").each(function(index) {
			if (!$(this).is(":disabled") && $(this).val() == userId) {
				$(this).prop("checked", true);
			} else {
				$(this).prop("checked", false);
			}
		});

		ctxMenu.commonAction[0].fun = function() {getDetail(userId);};
		ctxMenu.commonAction[1].fun = function() {openPopup({mode:"Edit", userId:userId});};
		ctxMenu.commonAction[2].fun = function() {doDelete();};

		$(img).contextMenu(ctxMenu.commonAction, {
			classPrefix:"actionInGrid",
			displayAround:"trigger",
			position:"bottom",
			horAdjust:0,
			verAdjust:2,
			containment:$("#divScrollablePanel")
		});
	};

	setActionButtonContextMenu = function() {
		var ctxMenu = [{
			name:"<tag:msg key="sys0406.ctxMenu.auth"/>",
			img:"fa-sitemap",
			fun:function() {openPopup({mode:"UpdateAuthGroup"});}
		}, {
			name:"<tag:msg key="sys0406.ctxMenu.type"/>",
			img:"fa-users",
			fun:function() {openPopup({mode:"UpdateUserType"});}
		}, {
			name:"<tag:msg key="sys0406.ctxMenu.status"/>",
			img:"fa-sliders",
			fun:function() {openPopup({mode:"UpdateUserStatus"});}
		}, {
			name:"<tag:msg key="sys0406.ctxMenu.active"/>",
			img:"fa-adjust",
			fun:function() {openPopup({mode:"UpdateActiveStatus"});}
		}];

		$("#btnAction").contextMenu(ctxMenu, {
			classPrefix:"actionButton",
			effectDuration:300,
			effect:"slide",
			borderRadius:"bottom 4px",
			displayAround:"trigger",
			position:"bottom",
			horAdjust:-157
		});
	};

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

	exeExport = function(menuObject) {
		var rowCnt = <%=resultDataSet.getRowCnt()%>;
		$("[name=fileType]").remove();
		$("[name=dataRange]").remove();

		if (rowCnt <= 0) {
			commonJs.warn("<tag:msg key="I001"/>");
			return;
		}

		commonJs.confirm({
			contents:"<tag:msg key="Q003"/>",
			buttons:[{
				caption:"Yes",
				callback:function() {
					commonJs.doSubmit({
						form:"fmDefault",
						action:"/sys/0406/exeExport.do",
						data:{
							fileType:menuObject.fileType,
							dataRange:menuObject.dataRange
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

	exeActionContextMenu = function(param) {
		commonJs.ajaxSubmit({
			url:"/sys/0406/exeActionContextMenu.do",
			dataType:"json",
			formId:"fmDefault",
			data:param,
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
	};

	/*!
	 * load event (document / window)
	 */
	$(window).load(function() {
		$("#tblGrid").fixedHeaderTable({
			baseDivElement:"divScrollablePanel",
			widthAdjust:72
		});

		$("[name=icnAction]").each(function(index) {
			$(this).contextMenu(ctxMenu.commonAction);
		});

		commonJs.setAutoComplete($("#userName"), {
			method:"getUserName",
			label:"user_name",
			value:"user_name",
			select:function(event, ui) {
				doSearch();
			}
		});

		commonJs.setAutoComplete($("#userId"), {
			method:"getUserId",
			label:"user_id",
			value:"user_id",
			select:function(event, ui) {
				doSearch();
			}
		});

		$("#userId").focus();
		setActionButtonContextMenu();
		setExportButtonContextMenu();
	});
});
</script>
</head>
<%/************************************************************************************************
* Page & Header
************************************************************************************************/%>
<body>
<form id="fmDefault" name="fmDefault" method="post" action="">
<div id="divHeaderHolder" class="ui-layout-north"><%@ include file="/webapp/project/common/include/header.jsp"%></div>
<div id="divBodyHolder" class="ui-layout-center">
<div id="divBodyLeft" class="ui-layout-west"><%@ include file="/webapp/project/common/include/bodyLeft.jsp"%></div>
<div id="divBodyCenter" class="ui-layout-center">
<div id="divFixedPanel">
<div id="divLocationPathArea"><%@ include file="/webapp/project/common/include/bodyLocationPathArea.jsp"%></div>
<%/************************************************************************************************
* Real Contents - fixed panel(tab, button, search, information)
************************************************************************************************/%>
<div id="divTabArea"></div>
<div id="divButtonArea" class="areaContainer">
	<div id="divButtonAreaLeft"></div>
	<div id="divButtonAreaRight">
		<tag:buttonGroup id="buttonGroup">
			<tag:button id="btnAction" caption="button.com.action" iconClass="fa-caret-down"/>
			<tag:button id="btnNew" caption="button.com.new" iconClass="fa-plus-square"/>
			<tag:button id="btnDelete" caption="button.com.delete" iconClass="fa-trash"/>
			<tag:button id="btnSearch" caption="button.com.search" iconClass="fa-search"/>
			<tag:button id="btnClear" caption="button.com.clear" iconClass="fa-refresh"/>
			<tag:button id="btnExport" caption="button.com.export" iconClass="fa-download"/>
		</tag:buttonGroup>
	</div>
</div>
<div id="divSearchCriteriaArea" class="areaContainer">
	<div class="panel panel-default">
		<div class="panel-body">
			<table class="tblDefault withPadding">
				<colgroup>
					<col width="10%"/>
					<col width="23%"/>
					<col width="10%"/>
					<col width="23%"/>
					<col width="10%"/>
					<col width="24%"/>
				</colgroup>
				<tr>
					<th class="thDefault"><tag:msg key="sys0406.search.id"/></th>
					<td class="tdDefault"><input type="text" id="userId" name="userId" class="txtEn" style="width:200px"/></td>
					<th class="thDefault"><tag:msg key="sys0406.search.name"/></th>
					<td class="tdDefault"><input type="text" id="userName" name="userName" class="txtEn"/></td>
					<th class="thDefault"><tag:msg key="sys0406.search.auth"/></th>
					<td class="tdDefault">
						<select id="authGroup" name="authGroup" class="bootstrapSelect">
							<option value="">==Select==</option>
<%
						for (int i=0; i<authGroupDataSet.getRowCnt(); i++) {
%>
							<option value="<%=authGroupDataSet.getValue(i, "GROUP_ID")%>"><%=authGroupDataSet.getValue(i, "GROUP_NAME")%></option>
<%
						}
%>
						</select>
					</td>
				</tr>
				<tr>
					<th class="thDefault"><tag:msg key="sys0406.search.type"/></th>
					<td class="tdDefault"><tag:select id="userType" name="userType" codeType="USER_TYPE" caption="==Select=="/></td>
					<th class="thDefault"><tag:msg key="sys0406.search.status"/></th>
					<td class="tdDefault"><tag:select id="userStatus" name="userStatus" codeType="USER_STATUS" caption="==Select=="/></td>
					<th class="thDefault"><tag:msg key="sys0406.search.active"/></th>
					<td class="tdDefault"><tag:select id="isActive" name="isActive" codeType="IS_ACTIVE" caption="==Select=="/></td>
				</tr>
			</table>
		</div>
	</div>
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
			<col width="10%"/>
			<col width="7%"/>
			<col width="9%"/>
			<col width="10%"/>
			<col width="8%"/>
			<col width="8%"/>
			<col width="*"/>
			<col width="5%"/>
			<col width="7%"/>
			<col width="3%"/>
		</colgroup>
		<thead>
			<tr>
				<th class="thGrid"><i id="icnCheck" class="fa fa-check-square-o fa-lg icnEn" title="<tag:msg key="page.com.selectToDelete"/>"></i></th>
				<th class="thGrid sortable:numeric"><tag:msg key="sys0406.grid.userId"/></th>
				<th class="thGrid sortable:alphanumeric"><tag:msg key="sys0406.grid.userName"/></th>
				<th class="thGrid sortable:alphanumeric"><tag:msg key="sys0406.grid.loginId"/></th>
				<th class="thGrid sortable:numeric"><tag:msg key="sys0406.grid.personId"/></th>
				<th class="thGrid sortable:alphanumeric"><tag:msg key="sys0406.grid.authGroup"/></th>
				<th class="thGrid sortable:alphanumeric"><tag:msg key="sys0406.grid.type"/></th>
				<th class="thGrid sortable:alphanumeric"><tag:msg key="sys0406.grid.status"/></th>
				<th class="thGrid"><tag:msg key="sys0406.grid.email"/></th>
				<th class="thGrid"><tag:msg key="sys0406.grid.active"/></th>
				<th class="thGrid sortable:date"><tag:msg key="sys0406.grid.date"/></th>
				<th class="thGrid"><tag:msg key="page.com.action"/></th>
			</tr>
		</thead>
		<tbody>
<%
		if (resultDataSet.getRowCnt() > 0) {
			for (int i=0; i<resultDataSet.getRowCnt(); i++) {
%>
			<tr>
				<td class="tdGridCt"><input type="checkbox" id="chkForDel" name="chkForDel" class="chkEn inTblGrid" value="<%=resultDataSet.getValue(i, "USER_ID")%>"/></td>
				<td class="tdGridCt"><%=resultDataSet.getValue(i, "USER_ID")%></td>
				<td class="tdGrid"><a onclick="getDetail('<%=resultDataSet.getValue(i, "USER_ID")%>')" class="aEn"><%=resultDataSet.getValue(i, "USER_NAME")%></a></td>
				<td class="tdGrid"><%=resultDataSet.getValue(i, "LOGIN_ID")%></td>
				<td class="tdGridCt"><%=resultDataSet.getValue(i, "PERSON_ID")%></td>
				<td class="tdGrid"><%=resultDataSet.getValue(i, "AUTH_GROUP_NAME")%></td>
				<td class="tdGrid"><%=resultDataSet.getValue(i, "USER_TYPE_NAME")%></td>
				<td class="tdGrid"><%=resultDataSet.getValue(i, "USER_STATUS_NAME")%></td>
				<td class="tdGrid"><%=resultDataSet.getValue(i, "EMAIL")%></td>
				<td class="tdGridCt"><%=resultDataSet.getValue(i, "IS_ACTIVE")%></td>
				<td class="tdGridCt"><%=resultDataSet.getValue(i, "UPDATE_DATE")%></td>
				<td class="tdGridCt">
					<i id="icnAction" name="icnAction" class="fa fa-tasks fa-lg icnEn" userId="<%=resultDataSet.getValue(i, "USER_ID")%>" onclick="doAction(this)" title="<tag:msg key="page.com.action"/>"></i>
				</td>
			</tr>
<%
			}
		} else {
%>
			<tr>
				<td class="tdGridCt" colspan="12"><tag:msg key="<%=messageCode%>"/></td>
			</tr>
<%
		}
%>
		</tbody>
	</table>
</div>
<div id="divPagingArea" class="areaContainer"><tag:pagination totalRows="<%=paramEntity.getTotalResultRows()%>" script="doSearch"/></div>
<%/************************************************************************************************
* Right & Footer
************************************************************************************************/%>
</div>
</div>
<div id="divBodyRight" class="ui-layout-east"><%@ include file="/webapp/project/common/include/bodyRight.jsp"%></div>
</div>
<div id="divFooterHolder" class="ui-layout-south"><%@ include file="/webapp/project/common/include/footer.jsp"%></div>
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