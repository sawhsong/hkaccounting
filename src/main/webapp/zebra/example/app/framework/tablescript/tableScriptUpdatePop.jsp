<%/************************************************************************************************
* Description
* - 
************************************************************************************************/%>
<%@ include file="/shared/page/incCommon.jsp"%>
<%/************************************************************************************************
* Declare objects & variables
************************************************************************************************/%>
<%
	ParamEntity pe = (ParamEntity)request.getAttribute("paramEntity");
	DataSet dsRequest = (DataSet)pe.getRequestDataSet();
	DataSet dsResult = (DataSet)pe.getObject("resultDataSet");
	String fileName = (String)dsRequest.getValue("fileName");
	String tableName = dsResult.getValue("TABLE_NAME");
	String tableDesc = dsResult.getValue("TABLE_DESCRIPTION");
	String system = (CommonUtil.containsIgnoreCase(fileName, "ZEBRA")) ? "Framework" : "Project";
	String delimiter = ConfigUtil.getProperty("dataDelimiter");
	String selectFramework = "", selectProject = "";
	if (CommonUtil.equalsIgnoreCase(system, "Project")) {
		selectFramework = "false";
		selectProject = "true";
	} else {
		selectFramework = "true";
		selectProject = "false";
	}
%>
<%/************************************************************************************************
* HTML
************************************************************************************************/%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<link rel="icon" type="image/png" href="<mc:cp key="imgIcon"/>/zebraFavicon.png">
<title><mc:msg key="fwk.main.system.title"/></title>
<%/************************************************************************************************
* Stylesheet & Javascript
************************************************************************************************/%>
<%@ include file="/shared/page/incCssJs.jsp"%>
<style type="text/css">
.thGrid {border-bottom:0px;}
.tblGrid tr:not(.default):not(.active):not(.info):not(.success):not(.warning):not(.danger):hover td {background:#FFFFFF;}
#liDummy {display:none;}
#divDataArea.areaContainerPopup {padding-top:0px;}
.dummyDetail {list-style:none;}
.dragHandler {cursor:move;}
.deleteButton {cursor:pointer;}
</style>
<script type="text/javascript">
jsconfig.put("useJqTooltip", false);
jsconfig.put("useJqSelectmenu", false);

var delimiter = jsconfig.get("dataDelimiter");

$(function() {
	/*!
	 * event
	 */
	$("#btnSave").click(function(event) {
		var isValid = true;

		$("#liDummy").find(":input").each(function(index) {
			$(this).removeAttr("mandatory");
			$(this).removeAttr("option");
		});

		if (!commonJs.doValidate("fmDefault")) {
			isValid = false;
			return;
		}

		$("#ulColumnDetailHolder").find(".dummyDetail").each(function(groupIndex) {
			$(this).find(":input").each(function(index) {
				var id = $(this).attr("id"), name = $(this).attr("name");

				if (!commonJs.isEmpty(id)) {id = (id.indexOf(delimiter) != -1) ? id.substring(0, id.indexOf(delimiter)) : id;}
				else {id = "";}

				if (!commonJs.isEmpty(name)) {name = (name.indexOf(delimiter) != -1) ? name.substring(0, name.indexOf(delimiter)) : name;}
				else {name = "";}

				$(this).attr("id", id+delimiter+groupIndex).attr("name", name+delimiter+groupIndex);

				if (commonJs.containsIgnoreCase(name, "columnName") && commonJs.isEmpty($(this).val())) {
					isValid = false;
					commonJs.doValidatorMessage($(this), "mandatory");
				}

				if (!isValid) {return;}

				if (commonJs.containsIgnoreCase(name, "description") && commonJs.isEmpty($(this).val())) {
					isValid = false;
					commonJs.doValidatorMessage($(this), "mandatory");
				}

				if (!isValid) {return;}
			});
		});

		if (!isValid) {return;}

		commonJs.confirm({
			contents:"<mc:msg key="Q001"/>",
			buttons:[{
				caption:"Yes",
				callback:function() {
					exeSave();
				}
			}, {
				caption:"No",
				callback:function() {
				}
			}]
		});
	});

	$("#btnClose").click(function(event) {
		parent.popup.close();
	});

	$("#btnAdd").click(function(event) {
		var elem = $("#liDummy").clone(), elemId = $(elem).attr("id");

		$(elem).css("display", "block").appendTo($("#ulColumnDetailHolder"));

		$("#ulColumnDetailHolder").find(".dummyDetail").each(function(groupIndex) {
			$(this).attr("index", groupIndex).attr("id", elemId+delimiter+groupIndex);

			$(this).find("i").each(function(index) {
				var id = $(this).attr("id"), id = (id.indexOf(delimiter) != -1) ? id.substring(0, id.indexOf(delimiter)) : id;
				$(this).attr("index", groupIndex).attr("id", id+delimiter+groupIndex);
			});

			$(this).find(".dragHandler").each(function(index) {
				var id = $(this).attr("id"), id = (id.indexOf(delimiter) != -1) ? id.substring(0, id.indexOf(delimiter)) : id;
				$(this).attr("index", groupIndex).attr("id", id+delimiter+groupIndex);
			});

			$(this).find(".deleteButton").each(function(index) {
				var id = $(this).attr("id"), id = (id.indexOf(delimiter) != -1) ? id.substring(0, id.indexOf(delimiter)) : id;
				$(this).attr("index", groupIndex).attr("id", id+delimiter+groupIndex);
			});

			$(this).find("input, select").each(function(index) {
				var id = $(this).attr("id"), name = $(this).attr("name");

				if (!commonJs.isEmpty(id)) {id = (id.indexOf(delimiter) != -1) ? id.substring(0, id.indexOf(delimiter)) : id;}
				else {id = "";}

				if (!commonJs.isEmpty(name)) {name = (name.indexOf(delimiter) != -1) ? name.substring(0, name.indexOf(delimiter)) : name;}
				else {name = "";}

				$(this).attr("id", id+delimiter+groupIndex).attr("name", name+delimiter+groupIndex);

				if (groupIndex == ($("#ulColumnDetailHolder .dummyDetail").length - 1)) {
					if (name.indexOf("nullable") != -1) {
						if ($(this).val() == "Y") {$(this).prop("checked", true);}
					}
				}

				if ($(this).is("select")) {
					setSelectBoxes($(this));
				}
			});
		});

		$("#tblGrid").fixedHeaderTable({
			attachTo:$("#divDataArea")
		});
	});

	/*!
	 * process
	 */
	exeSave = function() {
		var detailLength = $("#ulColumnDetailHolder .dummyDetail").length;

		commonJs.ajaxSubmit({
			url:"/zebra/framework/tablescript/exeUpdate.do",
			dataType:"json",
			formId:"fmDefault",
			data:{
				fileName:"<%=dsRequest.getValue("fileName")%>",
				detailLength:detailLength
			},
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
								parent.popup.close();
								parent.doSearch();
							}
						}]
					});
				} else {
					commonJs.error(result.message);
				}
			}
		});
	};

	setSortable = function() {
		$("#ulColumnDetailHolder").sortable({
			axis:"y",
			handle:".dragHandler",
			stop:function() {
				$("#ulColumnDetailHolder").find(".dummyDetail").each(function(groupIndex) {
					$(this).find("input").each(function(index) {
						var id = $(this).attr("id"), name = $(this).attr("name");

						$(this).attr("id", id+delimiter+groupIndex).attr("name", name+delimiter+groupIndex);
					});
				});
			}
		});

		$("#ulColumnDetailHolder").disableSelection();
	};

	setSelectBoxes = function(jqObj) {
		$(jqObj).selectpicker({
			width:"auto",
			container:"body",
			style:$(jqObj).attr("class")
		});
	};

	validate = function(obj) {
		var objName = $(obj).attr("name"), currRowIdx = objName.split(delimiter)[1];
		var nameSuffix = delimiter+currRowIdx;

		if (commonJs.containsIgnoreCase(objName, "dataType")) {
			if ($("#dataType"+nameSuffix).val() == "CLOB") {
				$("#dataLength"+nameSuffix).selectpicker("show");
				$("#dataLength"+nameSuffix).selectpicker("val", "4000");
				$("#dataLength"+nameSuffix).prop("disabled", true);
				$("#dataLength"+nameSuffix).selectpicker("refresh");

				$("#defaultValue"+nameSuffix).val("EMPTY_CLOB()");
			} else if ($("#dataType"+nameSuffix).val() == "NUMBER") {
				$("#dataLength"+nameSuffix).selectpicker("hide");

				$("#dataLengthNumber"+nameSuffix).css("display", "block");
			} else if ($("#dataType"+nameSuffix).val() == "DATE") {
				$("#dataLength"+nameSuffix).selectpicker("show");
				$("#dataLength"+nameSuffix).prop("disabled", true);
				$("#dataLength"+nameSuffix).selectpicker("refresh");

				$("#defaultValue"+nameSuffix).val("");
				$("#dataLengthNumber"+nameSuffix).css("display", "none");
			} else {
				$("#dataLength"+nameSuffix).selectpicker("show");
				$("#defaultValue"+nameSuffix).val("");
				$("#dataLength"+nameSuffix).prop("disabled", false);
				$("#dataLength"+nameSuffix).selectpicker("refresh");

				$("#dataLengthNumber"+nameSuffix).css("display", "none");
			}
		}

		if (commonJs.containsIgnoreCase(objName, "keyType")) {
			if (!commonJs.isEmpty($("#keyType"+nameSuffix).val())) {
				$("[name = nullable"+nameSuffix+"]").each(function() {
					if ($(this).val() == "N") {
						$(this).prop("checked", true);
					}
				});
			}

			if ($("#keyType"+nameSuffix).val() == "FK") {
				$("#fkRef"+nameSuffix).removeClass("txtDis").addClass("txtEn").removeAttr("readonly");
			} else {
				$("#fkRef"+nameSuffix).removeClass("txtEn").addClass("txtDis").attr("readonly", "readonly").val("");
			}
		}

		if (commonJs.containsIgnoreCase(objName, "fkRef") && !commonJs.isEmpty($("#fkRef"+nameSuffix).val())) {
			if (!commonJs.contains($("#fkRef"+nameSuffix).val(), ".")) {
				commonJs.doValidatorMessage($("#fkRef"+nameSuffix), "notValid");
			}
		}
	};

	addColumnDetails = function() {
		var ds = commonJs.getDataSetFromJavaDataSet("<%=dsResult.toStringForJs()%>");

		for (var i=0; i<ds.getRowCnt(); i++) {
			var rowIdx = delimiter+i;

			$("#btnAdd").trigger("click");

			$("[name=columnName"+rowIdx+"]").val(ds.getValue(i, "COLUMN_NAME"));
			$("[name=dataType"+rowIdx+"]").selectpicker("val", ds.getValue(i, "DATA_TYPE"));
			validate($("[name=dataType"+rowIdx+"]"));
			if (commonJs.contains(ds.getValue(i, "DATA_LENGTH"), ",")) {
				$("[name=dataLengthNumber"+rowIdx+"]").val(ds.getValue(i, "DATA_LENGTH"));
			} else {
				if (commonJs.containsIgnoreCase(ds.getValue(i, "DATA_TYPE"), "DATE")) {
					$("[name=dataLength"+rowIdx+"]").selectpicker("val", "");
				} else {
					$("[name=dataLength"+rowIdx+"]").selectpicker("val", ds.getValue(i, "DATA_LENGTH"));
				}
			}
			validate($("[name=dataLength"+rowIdx+"]"));
			$("[name=defaultValue"+rowIdx+"]").val(ds.getValue(i, "DEFAULT_VALUE"));
			commonJs.setCheckboxValue("nullable"+rowIdx, ds.getValue(i, "NULLABLE"));
			$("[name=keyType"+rowIdx+"]").selectpicker("val", ds.getValue(i, "KEY_TYPE"));
			$("[name=fkRef"+rowIdx+"]").val(ds.getValue(i, "FK_TABLE_COLUMN"));
			validate($("[name=fkRef"+rowIdx+"]"));
			if (ds.getValue(i, "KEY_TYPE") == "FK") {
				$("[name=fkRef"+rowIdx+"]").removeClass("txtDis").addClass("txtEn").removeAttr("readonly");
			}
			$("[name=description"+rowIdx+"]").val(ds.getValue(i, "COLUMN_DESCRIPTION"));
		}
	};

	/*!
	 * load event (document / window)
	 */
	$(document).click(function(event) {
		var obj = event.target;

		if ($(obj).hasClass("deleteButton") || ($(obj).is("i") && $(obj).parent("th").hasClass("deleteButton"))) {
			$("#ulColumnDetailHolder").find(".dummyDetail").each(function(index) {
				if ($(this).attr("index") == $(obj).attr("index")) {
					$(this).remove();

					$("#tblGrid").fixedHeaderTable({
						attachTo:$("#divDataArea")
					});
				}
			});
		}
	});

	$(window).load(function() {
		$("#tableName").focus();

		setSortable();

		setTimeout(function() {
			commonJs.showProcMessageOnElement("divScrollablePanelPopup");
		}, 300);

		setTimeout(function() {
			$("#tblGrid").fixedHeaderTable({
				attachTo:$("#divDataArea")
			});
		}, 600);

		setTimeout(function() {
			addColumnDetails();
		}, 900);

		setTimeout(function() {
			commonJs.hideProcMessageOnElement("divScrollablePanelPopup");
		}, 1400);
	});
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
<div id="divLocationPathArea"><%@ include file="/zebra/example/common/include/bodyLocationPathArea.jsp"%></div>
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
<div id="divInformArea" class="areaContainerPopup">
	<table class="tblEdit">
		<colgroup>
			<col width="9%"/>
			<col width="12%"/>
			<col width="8%"/>
			<col width="21%"/>
			<col width="10%"/>
			<col width="*"/>
		</colgroup>
		<tr>
			<th class="thEdit Rt mandatory"><mc:msg key="fwk.tablescript.header.system"/></th>
			<td class="tdEdit">
				<ui:radio name="system" inputClassName="inTbl" value="Project" text="fwk.tablescript.header.project" isSelected="<%=selectProject%>"/>
				<ui:radio name="system" inputClassName="inTbl" value="Framework" text="fwk.tablescript.header.framework" isSelected="<%=selectFramework%>"/>
			</td>
			<th class="thEdit Rt mandatory"><mc:msg key="fwk.tablescript.header.tableName"/></th>
			<td class="tdEdit">
				<ui:text name="tableName" id="tableName" value="<%=tableName%>" className="defClass" style="text-transform:uppercase" checkName="fwk.tablescript.header.tableName" options="mandatory" maxbyte="30"/>
			</td>
			<th class="thEdit Rt mandatory"><mc:msg key="fwk.tablescript.header.tableDesc"/></th>
			<td class="tdEdit">
				<ui:text name="tableDescription" id="tableDescription" value="<%=tableDesc%>" className="defClass" checkName="fwk.tablescript.header.tableDesc" options="mandatory"/>
			</td>
		</tr>
	</table>
</div>
<div class="breaker" style="height:5px;"></div>
<div class="divButtonArea areaContainerPopup">
	<div class="divButtonAreaLeft"></div>
	<div class="divButtonAreaRight">
		<ui:buttonGroup id="subButtonGroup">
			<ui:button id="btnAdd" caption="button.com.add" iconClass="fa-plus"/>
		</ui:buttonGroup>
	</div>
</div>
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
	<table id="tblGrid" class="tblGrid">
		<colgroup>
			<col width="2%"/>
			<col width="2%"/>
			<col width="16%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="7%"/>
			<col width="18%"/>
			<col width="*"/>
		</colgroup>
		<thead>
			<tr>
				<th class="thGrid"></th>
				<th class="thGrid"></th>
				<th class="thGrid mandatory"><mc:msg key="fwk.tablescript.header.colName"/></th>
				<th class="thGrid "><mc:msg key="fwk.tablescript.header.dataType"/></th>
				<th class="thGrid"><mc:msg key="fwk.tablescript.header.length"/></th>
				<th class="thGrid"><mc:msg key="fwk.tablescript.header.defaultValue"/></th>
				<th class="thGrid mandatory"><mc:msg key="fwk.tablescript.header.nullable"/></th>
				<th class="thGrid"><mc:msg key="fwk.tablescript.header.keyType"/></th>
				<th class="thGrid"><mc:msg key="fwk.tablescript.header.fkRef"/></th>
				<th class="thGrid mandatory"><mc:msg key="fwk.tablescript.header.description"/></th>
			</tr>
		</thead>
		<tbody id="tblGridBody">
			<tr>
				<td colspan="10" style="padding:0px;border-top:0px"><ul id="ulColumnDetailHolder"></ul></td>
			</tr>
		</tbody>
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
<li id="liDummy" class="dummyDetail">
	<table class="tblGrid" style="border:0px">
		<colgroup>
			<col width="2%"/>
			<col width="2%"/>
			<col width="16%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="6%"/>
			<col width="7%"/>
			<col width="18%"/>
			<col width="*"/>
		</colgroup>
		<tr class="noBorderAll">
			<th id="thDragHander" class="thEdit Ct dragHandler" title="<mc:msg key="fwk.commoncode.msg.drag"/>"><i id="iDragHandler" class="fa fa-lg fa-sort"></i></th>
			<th id="thDeleteButton" class="thEdit Ct deleteButton" title="<mc:msg key="fwk.commoncode.msg.delete"/>"><i id="iDeleteButton" class="fa fa-lg fa-times"></i></th>
			<td class="tdGrid Ct"><ui:text id="columnName" name="columnName" className="defClass" style="text-transform:uppercase" checkName="fwk.tablescript.header.colName" options="mandatory" script="onchange:validate(this)"/></td>
			<td class="tdGrid Ct"><ui:ccselect id="dataType" name="dataType" codeType="DOMAIN_DATA_TYPE" options="mandatory" source="framework" script="onchange:validate(this)"/></td>
			<td class="tdGrid Ct">
				<ui:ccselect id="dataLength" name="dataLength" codeType="DOMAIN_DATA_LENGTH" caption="=Select=" source="framework" script="onchange:validate(this)"/>
				<ui:text id="dataLengthNumber" name="dataLengthNumber" className="defClass Ct" checkName="fwk.tablescript.header.length" script="onchange:validate(this)" style="display:none"/>
			</td>
			<td class="tdGrid Ct"><ui:text id="defaultValue" name="defaultValue" className="defClass" style="text-transform:uppercase" checkName="fwk.tablescript.header.defaultValue" script="onchange:validate(this)"/></td>
			<td class="tdGrid Ct"><ui:radio name="nullable" value="Y" text="Y" displayType="inline" isSelected="true"/><ui:radio name="nullable" value="N" text="N" displayType="inline" script="onclick:validate(this)"/></td>
			<td class="tdGrid Ct"><ui:ccselect id="keyType" name="keyType" codeType="CONSTRAINT_TYPE" caption="=Select=" source="framework" script="onchange:validate(this)"/></td>
			<td class="tdGrid Ct"><ui:text id="fkRef" name="fkRef" className="defClass" style="text-transform:uppercase" checkName="fwk.tablescript.header.fkRef" status="disabled" script="onchange:validate(this)"/></td>
			<td class="tdGrid Ct">
				<ui:text id="description" name="description" className="defClass" checkName="fwk.tablescript.header.description" options="mandatory" script="onchange:validate(this)"/>
			</td>
		</tr>
	</table>
</li>
</form>
<%/************************************************************************************************
* Additional Form
************************************************************************************************/%>
<form id="fmHidden" name="fmHidden" method="post" action=""></form>
</body>
</html>