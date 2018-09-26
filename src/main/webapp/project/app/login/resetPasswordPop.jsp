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
%>
<%/************************************************************************************************
* HTML
************************************************************************************************/%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<link rel="icon" type="image/png" href="<mc:cp key="imgIcon"/>/favicon.png">
<title><mc:msg key="main.system.title"/></title>
<%/************************************************************************************************
* Stylesheet & Javascript
************************************************************************************************/%>
<%@ include file="/shared/page/incCssJs.jsp"%>
<style type="text/css">
.panelHolder {margin:0px auto;width:100%;text-align:center;}
.panel {margin-top:20px;display:inline-block;width:360px;}
.panel-title {padding-top:4px;padding-left:36px;text-align:left;font-size:14px;height:23px;background:url(<mc:cp key="imgIcon"/>/login.png) no-repeat 0px 0px;}
.panel-body {padding:25px 25px 20px 25px;}
.addonIcon {width:16px;}
.input-group {padding-bottom:4px;}
.buttonDiv {padding-top:18px;padding-bottom:0px;}
</style>
<script type="text/javascript">
var popup = null;

$(function() {
	/*!
	 * event
	 */
	$(document).keypress(function(event) {
		if (event.which == 13) {
			var element = event.target;

			if ($(element).is("[name=loginId]") || $(element).is("[name=email]")) {
				doProcess();
			}
		}
	});

	$("#btnReset").click(function() {
		doProcess();
	});

	/*!
	 * process
	 */
	doProcess = function() {
		if (!commonJs.doValidate("fmDefault")) {
			return;
		}

		commonJs.ajaxSubmit({
			url:"/login/exeResetPassword.do",
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
								parent.popup.close();
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
		$("[name=loginId]").focus();
	});
});
</script>
</head>
<%/************************************************************************************************
* Page & Header
************************************************************************************************/%>
<body>
<form id="fmDefault" name="fmDefault" method="post" action="">
<div id="divPopupWindowHolder" class="panelHolder">
	<div class="panel panel-default">
		<div class="panel-body">
			<div class="input-group">
				<div class="input-group-addon"><ui:icon className="fa-user fa-lg addonIcon"/></div>
				<ui:text id="loginId" name="loginId" className="form-control" placeHolder="login.header.loginId" checkName="login.header.loginId" options="mandatory"/>
			</div>
			<div class="input-group">
				<div class="input-group-addon"><ui:icon className="fa-envelope fa-lg addonIcon"/></div>
				<ui:text id="email" name="email" className="form-control" placeHolder="login.header.email" checkName="login.header.email" options="mandatory" option="email"/>
			</div>
			<div class="buttonDiv">
				<ui:button id="btnReset" type="warning" caption="login.button.emailResetpassword" iconClass="fa-send" buttonStyle="padding-top:8px;width:100%;height:40px;font-size:14px;"/>
			</div>
		</div>
	</div>
</div>
</form>
</body>
</html>