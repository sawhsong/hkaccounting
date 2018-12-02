/**************************************************************************************************
 * Framework Generated Javascript Source
 * - Sba0202DetailPop.js
 *************************************************************************************************/
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

	$(document).keypress(function(event) {
		if (event.which == 13) {
			var element = event.target;
		}
	});

	/*!
	 * process
	 */
	doProcessByButton = function(param) {
		var actionString = "";

		if (param.mode == "Update") {
			actionString = "/sba/0202/getUpdate.do";
		} else if (param.mode == "Delete") {
			actionString = "/sba/0202/exeDelete.do";
		}

		if (param.mode == "Update") {
			parent.popup.resizeTo(0, 116);
		}

		if (param.mode == "Delete") {
			commonJs.confirm({
				contents:com.message.Q002,
				buttons:[{
					caption:com.caption.yes,
					callback:function() {
						commonJs.ajaxSubmit({
							url:actionString,
							dataType:"json",
							formId:"fmDefault",
							data:{
								orgId:orgId
							},
							success:function(data, textStatus) {
								var result = commonJs.parseAjaxResult(data, textStatus, "json");

								if (result.isSuccess == true || result.isSuccess == "true") {
									commonJs.openDialog({
										type:com.message.I000,
										contents:result.message,
										blind:true,
										width:300,
										buttons:[{
											caption:com.caption.ok,
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
					caption:com.caption.no,
					callback:function() {
					}
				}]
			});
		} else {
			commonJs.doSubmit({
				form:"fmDefault",
				action:actionString,
				data:{
					mode:param.mode,
					orgId:orgId
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