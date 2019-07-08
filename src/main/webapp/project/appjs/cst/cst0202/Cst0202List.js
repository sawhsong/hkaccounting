/**************************************************************************************************
 * Framework Generated Javascript Source
 * - Bbs0202List.js
 *************************************************************************************************/
jsconfig.put("useJqTooltip", false);

var popup = null;
var searchResultDataCount = 0;
var attchedFileContextMenu = [];

$(function() {
	/*!
	 * event
	 */
	$("#financialYear").change(function() {
		doSearch();
	});

	$("#quarterName").change(function() {
		doSearch();
	});

	$("#btnSearch").click(function(event) {
		doSearch();
	});

	$("#btnClear").click(function(event) {
		commonJs.clearSearchCriteria();
	});

	$(document).keypress(function(event) {
		if (event.which == 13) {
			var element = event.target;
		}
	});

	/*!
	 * process
	 */
	doSearch = function() {
		commonJs.showProcMessageOnElement("divScrollablePanel");

		if (commonJs.doValidate($("#fmDefault"))) {
			setTimeout(function() {
				commonJs.ajaxSubmit({
					url:"/cst/0202/getList",
					dataType:"json",
					formId:"fmDefault",
					success:function(data, textStatus) {
						var result = commonJs.parseAjaxResult(data, textStatus, "json");

						if (result.isSuccess == true || result.isSuccess == "true") {
							renderDataGridTable(result);
						} else {
							commonJs.error(result.message);
						}
					}
				});
			}, 200);

			setTimeout(function() {
				commonJs.ajaxSubmit({
					url:"/cst/0202/getChart",
					dataType:"json",
					formId:"fmDefault",
					success:function(data, textStatus) {
						var result = commonJs.parseAjaxResult(data, textStatus, "json");

						if (result.isSuccess == true || result.isSuccess == "true") {
							var ds = result.dataSet;
console.log("chartFilePath : "+ds.getValue(0, "chartFilePath"));
							$("#imgChart").attr("src", ds.getValue(0, "chartFilePath"));
						} else {
							commonJs.error(result.message);
						}
					}
				});
			}, 400);
		}
	};

	renderDataGridTable = function(result) {
		var ds = result.dataSet;
		var html = "", totHtml = "", totGross = 0, totGst = 0, totNet = 0;
		var totGridTr = new UiGridTr();

		searchResultDataCount = ds.getRowCnt();
		$("#tblGridBody").html("");

		if (ds.getRowCnt() > 0) {
			for (var i=0; i<ds.getRowCnt(); i++) {
				var gridTr = new UiGridTr();

				if (i == (ds.getRowCnt() - 1)) {
					gridTr.addChild(new UiGridTd().addAttribute("colspan:13").addClassName("Rt").setText("Total Profit / Loss"));
					gridTr.addChild(new UiGridTd().addClassName("Rt").setText(ds.getValue(i, "TOT")));
					gridTr.setStyle("font-weight:bold;background:#f6f6f6;");
				} else {
					gridTr.addChild(new UiGridTd().addClassName("Lt").setText(ds.getValue(i, "TYPE_NAME")));
					gridTr.addChild(new UiGridTd().addClassName("Rt").setText(ds.getValue(i, "JUL")));
					gridTr.addChild(new UiGridTd().addClassName("Rt").setText(ds.getValue(i, "AUG")));
					gridTr.addChild(new UiGridTd().addClassName("Rt").setText(ds.getValue(i, "SEP")));
					gridTr.addChild(new UiGridTd().addClassName("Rt").setText(ds.getValue(i, "OCT")));
					gridTr.addChild(new UiGridTd().addClassName("Rt").setText(ds.getValue(i, "NOV")));
					gridTr.addChild(new UiGridTd().addClassName("Rt").setText(ds.getValue(i, "DEC")));
					gridTr.addChild(new UiGridTd().addClassName("Rt").setText(ds.getValue(i, "JAN")));
					gridTr.addChild(new UiGridTd().addClassName("Rt").setText(ds.getValue(i, "FEB")));
					gridTr.addChild(new UiGridTd().addClassName("Rt").setText(ds.getValue(i, "MAR")));
					gridTr.addChild(new UiGridTd().addClassName("Rt").setText(ds.getValue(i, "APR")));
					gridTr.addChild(new UiGridTd().addClassName("Rt").setText(ds.getValue(i, "MAY")));
					gridTr.addChild(new UiGridTd().addClassName("Rt").setText(ds.getValue(i, "JUN")));
					gridTr.addChild(new UiGridTd().addClassName("Rt").setText(ds.getValue(i, "TOT")));

					if (ds.getValue(i, "TYPE_NAME") == "Income Total" || ds.getValue(i, "TYPE_NAME") == "Expense Total") {
						gridTr.setStyle("font-weight:bold;background:#f6f6f6;");
					}
				}
				html += gridTr.toHtmlString();
			}
		} else {
			var gridTr = new UiGridTr();

			gridTr.addChild(new UiGridTd().addClassName("Ct").setAttribute("colspan:14").setText(com.message.I001));
			html += gridTr.toHtmlString();
		}

		$("#tblGridBody").append($(html));

		$("#tblGrid").fixedHeaderTable({
			attachTo:$("#divDataArea"),
			pagingArea:$("#divPagingArea"),
			isPageable:false,
			isFilter:false,
			filterColumn:[],
			totalResultRows:result.totalResultRows,
			script:"doSearch"
		});

		commonJs.hideProcMessageOnElement("divScrollablePanel");
	};

	/*!
	 * load event (document / window)
	 */
	$(window).load(function() {
		doSearch();
	});
});