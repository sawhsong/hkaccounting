/**************************************************************************************************
 * Framework Generated Javascript Source
 * - Rkm0802List.js
 *************************************************************************************************/
jsconfig.put("useJqTooltip", false);
var popup = null;
var searchResultDataCount = 0;

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

	$("#icnDeDateOfBirth").click(function(event) {
		commonJs.openCalendar(event, "deDateOfBirth");
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

	$("#wageType").change(function() {
		doSearch();
	});

	$(document).keypress(function(event) {
		if (event.which == 13) {
			var element = event.target;
		}
	});

	setDataEntryActionButtonContextMenu = function() {
		ctxMenu.dataEntryAction[0].fun = function() {};
		ctxMenu.dataEntryAction[1].fun = function() {};
		ctxMenu.dataEntryAction[2].fun = function() {};

		$("#icnDataEntryAction").contextMenu(ctxMenu.dataEntryAction, {
			classPrefix:com.constants.ctxClassPrefixGrid,
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
		commonJs.showProcMessageOnElement("divScrollablePanel");

		setTimeout(function() {
			commonJs.ajaxSubmit({
				url:"/rkm/0802/getList.do",
				dataType:"json",
				formId:"fmDefault",
				success:function(data, textStatus) {
					var result = commonJs.parseAjaxResult(data, textStatus, "json");

					if (result.isSuccess == true || result.isSuccess == "true") {
						renderDataGridTable(result);
					}
				}
			});
		}, 200);

		setSummaryDataForAdminTool();
	};

	renderDataGridTable = function(result) {
		var ds = result.dataSet;
		var html = "";
		var totGridTr = new UiGridTr();

		searchResultDataCount = ds.getRowCnt();
		$("#tblGridBody").html("");

		if (ds.getRowCnt() > 0) {
			for (var i=0; i<ds.getRowCnt(); i++) {
				var gridTr = new UiGridTr();

				var uiChk = new UiCheckbox();
				uiChk.setId("chkForDel").setName("chkForDel").setValue(ds.getValue(i, "EMPLOYEE_ID"));
				gridTr.addChild(new UiGridTd().addClassName("Ct").addChild(uiChk));

				var uiAncSurname = new UiAnchor();
				uiAncSurname.setText(ds.getValue(i, "SURNAME")).setScript("getDetail('"+ds.getValue(i, "EMPLOYEE_ID")+"')");
				gridTr.addChild(new UiGridTd().addClassName("Lt").addChild(uiAncSurname));

				var uiAncGivenName = new UiAnchor();
				uiAncGivenName.setText(ds.getValue(i, "GIVEN_NAME")).setScript("getDetail('"+ds.getValue(i, "EMPLOYEE_ID")+"')");
				gridTr.addChild(new UiGridTd().addClassName("Lt").addChild(uiAncGivenName));

				gridTr.addChild(new UiGridTd().addClassName("Ct").setText(commonJs.getFormatString(ds.getValue(i, "TFN"), "??? ??? ???")));
				gridTr.addChild(new UiGridTd().addClassName("Ct").setText(ds.getValue(i, "DATE_OF_BIRTH")));
				gridTr.addChild(new UiGridTd().addClassName("Lt").setText(ds.getValue(i, "ADDRESS")));
				gridTr.addChild(new UiGridTd().addClassName("Ct").setText(ds.getValue(i, "WAGE_TYPE_DESC")));
				gridTr.addChild(new UiGridTd().addClassName("Ct").setText(ds.getValue(i, "VISA_TYPE_DESC")));
				gridTr.addChild(new UiGridTd().addClassName("Ct").setText(ds.getValue(i, "START_DATE")));
				gridTr.addChild(new UiGridTd().addClassName("Ct").setText(ds.getValue(i, "END_DATE")));
				gridTr.addChild(new UiGridTd().addClassName("Ct").setText(ds.getValue(i, "IS_ACTIVE")));
				gridTr.addChild(new UiGridTd().addClassName("Ct").setText(ds.getValue(i, "UPDATE_DATE")));

				var iconAction = new UiIcon();
				iconAction.setId("icnAction").setName("icnAction").addClassName("fa-tasks fa-lg").addAttribute("employeeId:"+ds.getValue(i, "EMPLOYEE_ID")).setScript("doAction(this)");
				gridTr.addChild(new UiGridTd().addClassName("Ct").addChild(iconAction));

				html += gridTr.toHtmlString();
			}
		} else {
			var gridTr = new UiGridTr();

			gridTr.addChild(new UiGridTd().addClassName("Ct").setAttribute("colspan:13").setText(com.message.I001));
			html += gridTr.toHtmlString();
		}

		$("#tblGridBody").append($(html));

		$("#tblGrid").fixedHeaderTable({
			attachTo:$("#divDataArea"),
			pagingArea:$("#divPagingArea"),
			isPageable:true,
			isFilter:false,
			filterColumn:[],
			totalResultRows:result.totalResultRows,
			script:"doSearch"
		});

		$("[name=icnAction]").each(function(index) {
			$(this).contextMenu(ctxMenu.dataEntryListAction);
		});

		commonJs.hideProcMessageOnElement("divScrollablePanel");
	};

	getDetail = function(articleId) {
		openPopup({mode:"Detail", articleId:articleId});
	};

	openPopup = function(param) {
		var url = "", header = "";
		var height = 510;

		if (param.mode == "Detail") {
			url = "/rkm/0802/getDetail.do";
			header = com.header.popHeaderDetail;
		} else if (param.mode == "New" || param.mode == "Reply") {
			url = "/rkm/0802/getInsert.do";
			header = com.header.popHeaderEdit;
		} else if (param.mode == "Edit") {
			url = "/rkm/0802/getUpdate.do";
			header = com.header.popHeaderEdit;
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
			commonJs.warn(com.message.I902);
			return;
		}

		commonJs.confirm({
			contents:com.message.Q002,
			buttons:[{
				caption:com.caption.yes,
				callback:function() {
					commonJs.ajaxSubmit({
						url:"/rkm/0802/exeDelete.do",
						dataType:"json",
						formId:"fmDefault",
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
				caption:com.caption.no,
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
			classPrefix:com.constants.ctxClassPrefixGrid,
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
			commonJs.warn(com.message.I001);
			return;
		}

		commonJs.confirm({
			contents:com.message.Q003,
			buttons:[{
				caption:com.caption.yes,
				callback:function() {
					popup = commonJs.openPopup({
						popupId:"exportFile",
						url:"/rkm/0802/exeExport.do",
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
				caption:com.caption.no,
				callback:function() {
				}
			}],
			blind:true
		});
	};

	/*!
	 * load event (document / window)
	 */
	$(window).load(function() {
		setDataEntryActionButtonContextMenu();

		commonJs.setFieldDateMask("deDateOfBirth");
		commonJs.setFieldDateMask("deStartDate");
		commonJs.setFieldDateMask("deEndDate");
		$("#deTfn").mask("999 999 999", {placeholder:"_"});

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

		doSearch();
	});
});