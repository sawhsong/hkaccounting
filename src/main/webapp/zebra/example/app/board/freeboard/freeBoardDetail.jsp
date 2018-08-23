<%/************************************************************************************************
* Description
* - 
************************************************************************************************/%>
<%@ include file="/shared/page/incCommon.jsp"%>
<%/************************************************************************************************
* Declare objects & variables
************************************************************************************************/%>
<%
	ParamEntity paramEntity = (ParamEntity)request.getAttribute("paramEntity");
	DataSet dsRequest = (DataSet)paramEntity.getRequestDataSet();
	ZebraBoard freeBoard = (ZebraBoard)paramEntity.getObject("freeBoard");
	DataSet fileDataSet = (DataSet)paramEntity.getObject("fileDataSet");
%>
<%/************************************************************************************************
* HTML
************************************************************************************************/%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<title><tag:msg key="fwk.main.system.title"/></title>
<%/************************************************************************************************
* Stylesheet & Javascript
************************************************************************************************/%>
<%@ include file="/shared/page/incCssJs.jsp"%>
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

	$("#btnBack").click(function(event) {
		history.go(-1);
	});

	/*!
	 * process
	 */
	setFCKEditor = function() {
		$("#articleContents").ckeditor({
			height:480,
			toolbar:"frameworkBasic",
			readOnly:true
		});
	};

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
		var articleId = "<%=freeBoard.getArticleId()%>";
		var actionString = "";
		var params = {};

		if (param.mode == "Update") {
			actionString = "/zebra/board/freeboard/getUpdate.do";
		} else if (param.mode == "Reply") {
			actionString = "/zebra/board/freeboard/getInsert.do";
		} else if (param.mode == "Delete") {
			actionString = "/zebra/board/freeboard/exeDelete.do";
		}

		params = {
			form:"fmDefault",
			action:actionString,
			data:{
				mode:param.mode,
				articleId:articleId
			}
		};

		if (param.mode == "Delete") {
			commonJs.confirm({
				contents:"<tag:msg key="Q002"/>",
				buttons:[{
					caption:"Yes",
					callback:function() {
						commonJs.doSubmit(params);
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
		setFCKEditor();
	});
});
</script>
</head>
<%/************************************************************************************************
* Page & Header
************************************************************************************************/%>
<body>
<form id="fmDefault" name="fmDefault" method="post" action="">
<div id="divHeaderHolder" class="ui-layout-north"><%@ include file="/zebra/example/common/include/header.jsp"%></div>
<div id="divBodyHolder" class="ui-layout-center">
<div id="divBodyLeft" class="ui-layout-west"><%@ include file="/zebra/example/common/include/bodyLeft.jsp"%></div>
<div id="divBodyCenter" class="ui-layout-center">
<div id="divFixedPanel">
<div id="divLocationPathArea"><%@ include file="/zebra/example/common/include/bodyLocationPathArea.jsp"%></div>
<%/************************************************************************************************
* Real Contents - fixed panel(tab, button, search, information)
************************************************************************************************/%>
<div id="divTabArea"></div>
<div id="divButtonArea" class="areaContainer">
	<div id="divButtonAreaLeft"></div>
	<div id="divButtonAreaRight">
		<tag:buttonGroup id="buttonGroup">
			<tag:button id="btnEdit" caption="button.com.edit" iconClass="fa-edit"/>
			<tag:button id="btnReply" caption="button.com.reply" iconClass="fa-reply-all"/>
			<tag:button id="btnDelete" caption="button.com.delete" iconClass="fa-save"/>
			<tag:button id="btnBack" caption="button.com.back" iconClass="fa-arrow-left"/>
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
<div id="divScrollablePanel">
<%/************************************************************************************************
* Real Contents - scrollable panel(data, paging)
************************************************************************************************/%>
<div id="divDataArea" class="areaContainer">
	<table class="tblEdit">
		<colgroup>
			<col width="12%"/>
			<col width="37%"/>
			<col width="12%"/>
			<col width="37%"/>
		</colgroup>
		<tr>
			<th class="thEditRt"><tag:msg key="fwk.bbs.header.writerName"/></th>
			<td class="tdEdit"><%=freeBoard.getWriterName()%>(<%=freeBoard.getWriterId()%>)</td>
			<th class="thEditRt"><tag:msg key="fwk.bbs.header.writerEmail"/></th>
			<td class="tdEdit"><%=freeBoard.getWriterEmail()%></td>
		</tr>
		<tr>
			<th class="thEditRt"><tag:msg key="fwk.bbs.header.updateDate"/></th>
			<td class="tdEdit"><%=CommonUtil.toViewDateString(freeBoard.getUpdateDate())%></td>
			<th class="thEditRt"><tag:msg key="fwk.bbs.header.visitCount"/></th>
			<td class="tdEdit"><%=CommonUtil.getNumberMask(freeBoard.getVisitCnt())%></td>
		</tr>
		<tr>
			<th class="thEditRt"><tag:msg key="fwk.bbs.header.articleSubject"/></th>
			<td class="tdEdit" colspan="3"><%=freeBoard.getArticleSubject()%></td>
		</tr>
		<tr>
			<th class="thEditRt"><tag:msg key="fwk.bbs.header.attachedFile"/></th>
			<td class="tdEdit" colspan="3">
				<table class="tblDefault withPadding">
					<tr>
						<td>
<%
				if (fileDataSet.getRowCnt() > 0) {
					for (int i=0; i<fileDataSet.getRowCnt(); i++) {
						String repositoryPath = fileDataSet.getValue(i, "REPOSITORY_PATH");
						String originalName = fileDataSet.getValue(i, "ORIGINAL_NAME");
						String newName = fileDataSet.getValue(i, "NEW_NAME");
						String icon = fileDataSet.getValue(i, "FILE_ICON");
						String delimiter = "";
						double fileSize = CommonUtil.toDouble(fileDataSet.getValue(i, "FILE_SIZE")) / 1024;

						if (i != 0) {
							delimiter = ", &nbsp;";
						}
%>
							<%=delimiter%>
							<img src="<%=icon%>" style="margin-top:-4px;"/>
							<a class="aEn" onclick="exeDownload('<%=repositoryPath%>', '<%=originalName%>', '<%=newName%>')">
								<%=fileDataSet.getValue(i, "ORIGINAL_NAME")%> (<%=CommonUtil.getNumberMask(fileSize)%> KB)
							</a>
<%
					}
				}
%>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<div class="breaker" style="height:5px"></div>
	<table class="tblDefault" style="width:100%;">
		<tr>
			<td class="tdDefault">
				<textarea id="articleContents" name="articleContents" class="txaRead"><%=freeBoard.getArticleContents()%></textarea>
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
<div id="divBodyRight" class="ui-layout-east"><%@ include file="/zebra/example/common/include/bodyRight.jsp"%></div>
</div>
<div id="divFooterHolder" class="ui-layout-south"><%@ include file="/zebra/example/common/include/footer.jsp"%></div>
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