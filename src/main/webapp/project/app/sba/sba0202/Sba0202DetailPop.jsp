<%/************************************************************************************************
* Description - Sba0202 - Organisation Profile
*   - Generated by Source Generator
************************************************************************************************/%>
<%@ include file="/shared/page/incCommon.jsp"%>
<%/************************************************************************************************
* Declare objects & variables
************************************************************************************************/%>
<%
	ParamEntity paramEntity = (ParamEntity)request.getAttribute("paramEntity");
	DataSet requestDataSet = (DataSet)paramEntity.getRequestDataSet();
	SysBoard sysBoard = (SysBoard)paramEntity.getObject("sysBoard");
	DataSet fileDataSet = (DataSet)paramEntity.getObject("fileDataSet");
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

	$("#btnReply").click(function(event) {
		doProcessByButton({mode:"Reply"});
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
	exeDownload = function(repositoryPath, originalName, newName) {
		commonJs.doSubmit({
			form:"fmDefault",
			action:"/download.do",
			data:{
				repositoryPath:repositoryPath,
				originalName:originalName,
				newName:newName
			}
		});
	};

	doProcessByButton = function(param) {
		var articleId = "<%=sysBoard.getArticleId()%>";
		var actionString = "";
		var params = {};

		if (param.mode == "Update") {
			actionString = "/sba/0202/getUpdate.do";
		} else if (param.mode == "Reply") {
			actionString = "/sba/0202/getInsert.do";
		} else if (param.mode == "Delete") {
			actionString = "/sba/0202/exeDelete.do";
		}

		params = {
			form:"fmDefault",
			action:actionString,
			data:{
				mode:param.mode,
				articleId:articleId
			}
		};

		if (param.mode == "Update") {
			parent.popup.resizeTo(0, 124);
		}

		if (param.mode == "Delete") {
			commonJs.confirm({
				contents:"<tag:msg key="Q002"/>",
				buttons:[{
					caption:"Yes",
					callback:function() {
						commonJs.ajaxSubmit({
							url:"/sba/0202/exeDelete.do",
							dataType:"json",
							formId:"fmDefault",
							data:{
								articleId:articleId
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
			commonJs.doSubmit(params);
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
			<tag:button id="btnReply" caption="button.com.reply" iconClass="fa-reply-all"/>
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
	<table class="tblEdit">
		<colgroup>
			<col width="15%"/>
			<col width="35%"/>
			<col width="15%"/>
			<col width="35%"/>
		</colgroup>
		<tr>
			<th class="thEdit"><tag:msg key="sba0202.header.writerName"/></th>
			<td class="tdEdit"><%=sysBoard.getWriterName()%>(<%=sysBoard.getWriterId()%>)</td>
			<th class="thEdit"><tag:msg key="sba0202.header.writerEmail"/></th>
			<td class="tdEdit"><%=sysBoard.getWriterEmail()%></td>
		</tr>
		<tr>
			<th class="thEdit"><tag:msg key="sba0202.header.updateDate"/></th>
			<td class="tdEdit"><%=CommonUtil.toViewDateString(sysBoard.getUpdateDate())%></td>
			<th class="thEdit"><tag:msg key="sba0202.header.hitCount"/></th>
			<td class="tdEdit"><%=CommonUtil.getNumberMask(sysBoard.getHitCnt())%></td>
		</tr>
		<tr>
			<th class="thEdit"><tag:msg key="sba0202.header.articleSubject"/></th>
			<td class="tdEdit" colspan="3"><%=sysBoard.getArticleSubject()%></td>
		</tr>
		<tr>
			<th class="thEdit"><tag:msg key="sba0202.header.articleContents"/></th>
			<td class="tdEdit" colspan="3" style="height:226px;vertical-align:top">
				<%=sysBoard.getArticleContents()%>
			</td>
		</tr>
		<tr>
			<th class="thEdit"><tag:msg key="sba0202.header.attachedFile"/></th>
			<td class="tdEdit" colspan="3">
				<div id="divAttachedFile" style="width:100%;height:100px;overflow-y:auto;">
					<table class="tblDefault withPadding">
<%
					if (fileDataSet.getRowCnt() > 0) {
						for (int i=0; i<fileDataSet.getRowCnt(); i++) {
							String repositoryPath = fileDataSet.getValue(i, "REPOSITORY_PATH");
							String originalName = fileDataSet.getValue(i, "ORIGINAL_NAME");
							String newName = fileDataSet.getValue(i, "NEW_NAME");
							String icon = fileDataSet.getValue(i, "FILE_ICON");
							double fileSize = CommonUtil.toDouble(fileDataSet.getValue(i, "FILE_SIZE")) / 1024;
%>
						<tr>
							<td class="tdDefault">
								<img src="<%=icon%>" style="margin-top:-4px;"/>
								<a class="aEn" onclick="exeDownload('<%=repositoryPath%>', '<%=originalName%>', '<%=newName%>')">
									<%=fileDataSet.getValue(i, "ORIGINAL_NAME")%> (<%=CommonUtil.getNumberMask(fileSize)%> KB)
								</a>
							</td>
						</tr>
<%
						}
					}
%>
					</table>
				</div>
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