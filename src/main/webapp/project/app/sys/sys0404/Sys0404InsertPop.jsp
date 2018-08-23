<%/************************************************************************************************
* Description - Sys0404 - Authority Group
*   - Generated by Source Generator
************************************************************************************************/%>
<%@ include file="/shared/page/incCommon.jsp"%>
<%/************************************************************************************************
* Declare objects & variables
************************************************************************************************/%>
<%
	ParamEntity paramEntity = (ParamEntity)request.getAttribute("paramEntity");
	DataSet requestDataSet = (DataSet)paramEntity.getRequestDataSet();
	SysUser sysUser = (SysUser)session.getAttribute("SysUser");
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
$(function() {
	/*!
	 * event
	 */
	$("#btnSave").click(function(event) {
		if (!commonJs.doValidate("fmDefault")) {
			return;
		}

		commonJs.confirm({
			contents:"<tag:msg key="Q001"/>",
			buttons:[{
				caption:"Yes",
				callback:function() {
					commonJs.ajaxSubmit({
						url:"/sys/0404/exeInsert.do",
						dataType:"json",
						formId:"fmDefault",
						data:{
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

	/*!
	 * process
	 */

	/*!
	 * load event (document / window)
	 */
	$(window).load(function() {
		$("#txtWriterName").focus();
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
<div id="divLocationPathArea"><%@ include file="/project/common/include/bodyLocationPathArea.jsp"%></div>
<%/************************************************************************************************
* Real Contents - fixed panel(tab, button, search, information)
************************************************************************************************/%>
<div id="divTabArea"></div>
<div id="divButtonArea" class="areaContainerPopup">
	<div id="divButtonAreaLeft"></div>
	<div id="divButtonAreaRight">
		<tag:buttonGroup id="buttonGroup">
			<tag:button id="btnSave" caption="button.com.save" iconClass="fa-save"/>
			<tag:button id="btnClose" caption="button.com.close" iconClass="fa-times"/>
		</tag:buttonGroup>
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
			<col width="18%"/>
			<col width="32%"/>
			<col width="18%"/>
			<col width="32%"/>
		</colgroup>
		<tr>
			<th class="thEdit"><tag:msg key="sys0404.header.groupId"/></th>
			<td class="tdEdit">
				<input type="text" id="groupId" name="groupId" class="txtDpl" readonly/>
			</td>
			<th class="thEdit mandatory"><tag:msg key="sys0404.header.isActive"/></th>
			<td class="tdEdit">
				<tag:select id="isActive" name="isActive" codeType="IS_ACTIVE" options="mandatory"/>
			</td>
		</tr>
		<tr>
			<th class="thEdit mandatory"><tag:msg key="sys0404.header.groupName"/></th>
			<td class="tdEdit" colspan="3">
				<input type="text" id="groupName" name="groupName" class="txtEn" checkName="<tag:msg key="sys0404.header.groupName"/>" mandatory/>
			</td>
		</tr>
		<tr>
			<th class="thEdit"><tag:msg key="sys0404.header.description"/></th>
			<td class="tdEdit" colspan="3">
				<input type="text" id="description" name="description" class="txtEn" checkName="<tag:msg key="sys0404.header.description"/>"/>
			</td>
		</tr>
		<tr>
			<th class="thEdit"><tag:msg key="page.com.insertUser"/></th>
			<td class="tdEdit">
				<input type="text" id="insertUser" name="insertUser" class="txtDpl" readonly/>
			</td>
			<th class="thEdit"><tag:msg key="page.com.insertDate"/></th>
			<td class="tdEdit">
				<input type="text" id="insertDate" name="insertDate" class="txtDpl" readonly/>
			</td>
		</tr>
		<tr>
			<th class="thEdit"><tag:msg key="page.com.updateUser"/></th>
			<td class="tdEdit">
				<input type="text" id="updateUser" name="updateUser" class="txtDpl" readonly/>
			</td>
			<th class="thEdit"><tag:msg key="page.com.updateDate"/></th>
			<td class="tdEdit">
				<input type="text" id="updateDate" name="updateDate" class="txtDpl" readonly/>
			</td>
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