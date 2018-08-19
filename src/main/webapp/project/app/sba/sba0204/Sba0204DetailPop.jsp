<%/************************************************************************************************
* Description - Sys0406 - User
*   - Generated by Source Generator
************************************************************************************************/%>
<%@ include file="/shared/page/incCommon.jsp"%>
<%/************************************************************************************************
* Declare objects & variables
************************************************************************************************/%>
<%
	ParamEntity paramEntity = (ParamEntity)request.getAttribute("paramEntity");
	SysUser sysUser = (SysUser)paramEntity.getObject("sysUser");
	String dateFormat = ConfigUtil.getProperty("format.date.java");
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
	$("#btnEdit").click(function(event) {
		doProcessByButton({mode:"Update"});
	});

	$("#btnDelete").click(function(event) {
		doProcessByButton({mode:"Delete"});
	});

	$("#btnClose").click(function(event) {
		parent.popup.close();
	});

	/*!
	 * process
	 */
	doProcessByButton = function(param) {
		var userId = "<%=sysUser.getUserId()%>";
		var action = "";

		if (param.mode == "Update") {
			action = "/sba/0204/getUpdate.do";
		} else if (param.mode == "Delete") {
			action = "/sba/0204/exeDelete.do";
		}

		if (param.mode == "Update") {
			parent.popup.resizeTo(0, 174);
		}

		if (param.mode == "Delete") {
			commonJs.confirm({
				contents:"<tag:msg key="Q002"/>",
				buttons:[{
					caption:"Yes",
					callback:function() {
						commonJs.ajaxSubmit({
							url:action,
							dataType:"json",
							formId:"fmDefault",
							data:{
								userId:userId
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
		} else {
			commonJs.doSubmit({
				form:"fmDefault",
				action:action,
				data:{
					mode:param.mode,
					userId:userId
				}
			});
		}
	};

	/*!
	 * load event (document / window)
	 */
	$(window).load(function() {
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
			<tag:button id="btnEdit" caption="button.com.edit" iconClass="fa-edit"/>
			<tag:button id="btnDelete" caption="button.com.delete" iconClass="fa-save"/>
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
	<div class="panel panel-default" style="width:120px;height:110px;">
		<div class="panel-body">
			<table class="tblDefault">
				<tr>
					<td class="tdDefaultCt">
						<img id="img<%=sysUser.getUserId()%>" src="<%=sysUser.getPhotoPath()%>" class="imgDis" style="width:90px;height:90px;" title="<%=sysUser.getUserName()%>"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<table class="tblEdit">
		<colgroup>
			<col width="18%"/>
			<col width="32%"/>
			<col width="18%"/>
			<col width="32%"/>
		</colgroup>
		<tr>
			<th class="thEdit"><tag:msg key="sba0204.header.userId"/></th>
			<td class="tdEdit"><%=sysUser.getUserId()%></td>
			<th class="thEdit"><tag:msg key="sba0204.header.userName"/></th>
			<td class="tdEdit"><%=sysUser.getUserName()%></td>
		</tr>
		<tr>
			<th class="thEdit"><tag:msg key="sba0204.header.loginId"/></th>
			<td class="tdEdit"><%=sysUser.getLoginId()%></td>
			<th class="thEdit"><tag:msg key="sba0204.header.password"/></th>
			<td class="tdEdit"><%=sysUser.getLoginPassword()%></td>
		</tr>
		<tr>
			<th class="thEdit"><tag:msg key="sba0204.header.orgId"/></th>
			<td class="tdEdit"><%=sysUser.getOrgId()%></td>
			<th class="thEdit"><tag:msg key="sba0204.header.authGroup"/></th>
			<td class="tdEdit"><%=DataHelper.getAuthGroupNameById(sysUser.getAuthGroupId())%></td>
		</tr>
		<tr>
			<th class="thEdit"><tag:msg key="sba0204.header.language"/></th>
			<td class="tdEdit"><%=CommonCodeManager.getCodeDescription("LANGUAGE_TYPE", sysUser.getLanguage())%></td>
			<th class="thEdit"><tag:msg key="sba0204.header.themeType"/></th>
			<td class="tdEdit"><%=CommonCodeManager.getCodeDescription("USER_THEME_TYPE", sysUser.getThemeType())%></td>
		</tr>
		<tr>
			<th class="thEdit"><tag:msg key="sba0204.header.type"/></th>
			<td class="tdEdit"><%=CommonCodeManager.getCodeDescription("USER_TYPE", sysUser.getUserType())%></td>
			<th class="thEdit"><tag:msg key="sba0204.header.email"/></th>
			<td class="tdEdit"><%=sysUser.getEmail()%></td>
		</tr>
		<tr>
			<th class="thEdit"><tag:msg key="sba0204.header.maxRowsPerPage"/></th>
			<td class="tdEdit"><%=CommonUtil.toString(sysUser.getMaxRowPerPage(), "#,###")%></td>
			<th class="thEdit"><tag:msg key="sba0204.header.pageNumsPerPage"/></th>
			<td class="tdEdit"><%=CommonUtil.toString(sysUser.getPageNumPerPage(), "#,###")%></td>
		</tr>
		<tr>
			<th class="thEdit"><tag:msg key="sba0204.header.status"/></th>
			<td class="tdEdit"><%=CommonCodeManager.getCodeDescription("USER_STATUS", sysUser.getUserStatus())%></td>
			<th class="thEdit"><tag:msg key="sba0204.header.active"/></th>
			<td class="tdEdit"><%=CommonCodeManager.getCodeDescription("IS_ACTIVE", sysUser.getIsActive())%></td>
		</tr>
		<tr>
			<th class="thEdit"><tag:msg key="sba0204.header.insertUser"/></th>
			<td class="tdEdit"><%=sysUser.getInsertUserName()%></td>
			<th class="thEdit"><tag:msg key="sba0204.header.insertDate"/></th>
			<td class="tdEdit"><%=CommonUtil.toString(sysUser.getInsertDate(), dateFormat)%></td>
		</tr>
		<tr>
			<th class="thEdit"><tag:msg key="sba0204.header.updateUser"/></th>
			<td class="tdEdit"><%=sysUser.getUpdateUserName()%></td>
			<th class="thEdit"><tag:msg key="sba0204.header.updateDate"/></th>
			<td class="tdEdit"><%=CommonUtil.toString(sysUser.getUpdateDate(), dateFormat)%></td>
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