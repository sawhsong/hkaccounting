<%/************************************************************************************************
* Description - Ads0204 - Invoice Management
*	- Generated by Source Generator
************************************************************************************************/%>
<%@ include file="/shared/page/incCommon.jsp"%>
<%/************************************************************************************************
* Declare objects & variables
************************************************************************************************/%>
<%
	ParamEntity paramEntity = (ParamEntity)request.getAttribute("paramEntity");
	DataSet requestDataSet = (DataSet)paramEntity.getRequestDataSet();
	String invoiceId = requestDataSet.getValue("invoiceId");
	String dateFormat = ConfigUtil.getProperty("format.date.java");
	String paymentDueDate = CommonUtil.getCalcDate("D", CommonUtil.getSysdate(dateFormat), dateFormat, 30);
%>
<%/************************************************************************************************
* HTML
************************************************************************************************/%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<link rel="icon" type="image/png" href="<mc:cp key="imgIcon"/>/faviconHKAccount.png">
<title><mc:msg key="main.system.title"/></title>
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
.dragHandler, .dragHandler > i {cursor:move;}
.deleteButton {cursor:pointer;}
</style>
<script type="text/javascript" src="<mc:cp key="viewPageJsName"/>"></script>
<script type="text/javascript">
var invoiceId = "<%=invoiceId%>";
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
	<div id="divButtonAreaLeft">
		<ui:buttonGroup id="buttonGroup">
			<ui:button id="btnBringMyInfo" caption="Bring My Info" iconClass="fa-reply-all"/>
			<ui:button id="btnBringOrgInfo" caption="Bring Org Info" iconClass="fa-reply-all"/>
			<ui:button id="btnDiscardBasicInfo" caption="Discard Basic Info" iconClass="fa-trash"/>
			<ui:button id="btnRemoveLogo" caption="Remove Logo" iconClass="fa-trash"/>
			<ui:button id="btnCreateFromQuotation" caption="Create From Quotation" iconClass="fa-link"/>
		</ui:buttonGroup>
	</div>
	<div id="divButtonAreaRight">
		<ui:buttonGroup id="buttonGroup">
			<ui:button id="btnPreview" caption="Preview" iconClass="fa-search-plus"/>
			<ui:button id="btnSave" caption="button.com.save" iconClass="fa-save"/>
			<ui:button id="btnClose" caption="button.com.close" iconClass="fa-times"/>
		</ui:buttonGroup>
	</div>
</div>
<div id="divSearchCriteriaArea" class="areaContainerPopup">
	<table class="tblEdit">
		<caption>Supplier Information</caption>
		<colgroup>
			<col width="8%"/>
			<col width="16%"/>
			<col width="8%"/>
			<col width="19%"/>
			<col width="8%"/>
			<col width="16%"/>
			<col width="9%"/>
			<col width="*"/>
		</colgroup>
		<tr>
			<td class="tdEdit" colspan="2" rowspan="3" id="tdLogo"></td>
			<th class="thEdit rt">Invoice ID</th>
			<td class="tdEdit"><ui:text name="invoiceId" status="display"/></td>
			<th class="thEdit rt mandatory">Number</th>
			<td class="tdEdit"><ui:text name="invoiceNumber" checkName="Invoice Number" options="mandatory"/></td>
			<th class="thEdit rt mandatory">Issue Date</th>
			<td class="tdEdit">
				<ui:text name="issueDate" className="Ct hor" value="<%=CommonUtil.getSysdate(dateFormat)%>" style="width:90px" option="date"/>
				<ui:icon id="icnIssueDate" className="fa-calendar hor"/>
			</td>
		</tr>
		<tr>
			<th class="thEdit rt">Organisation</th>
			<td class="tdEdit"><ui:hidden name="providerOrgId"/><ui:text name="providerOrgName"/></td>
			<th class="thEdit rt">ABN</th>
			<td class="tdEdit"><ui:text name="providerAbn"/></td>
			<th class="thEdit rt">ACN</th>
			<td class="tdEdit"><ui:text name="providerAcn"/></td>
		</tr>
		<tr>
			<th class="thEdit rt mandatory">Name</th>
			<td class="tdEdit"><ui:text name="providerName" checkName="Provider Name" options="mandatory"/></td>
			<th class="thEdit rt">Email</th>
			<td class="tdEdit"><ui:text name="providerEmail" option="email"/></td>
			<th class="thEdit rt">Telephone</th>
			<td class="tdEdit"><ui:text name="providerTelephone"/></td>
		</tr>
		<tr>
			<th class="thEdit rt">Logo Image</th>
			<td class="tdEdit"><ui:file name="providerLogoPath" style="width:244px"/></td>
			<th class="thEdit rt">Mobile</th>
			<td class="tdEdit"><ui:text name="providerMobile"/></td>
			<th class="thEdit rt">Address</th>
			<td class="tdEdit" colspan="3"><ui:text name="providerAddress"/></td>
		</tr>
		<tr>
			<th class="thEdit rt">Quote Number</th>
			<td class="tdEdit"><ui:hidden name="quotationId"/><ui:text name="quotationNumber" status="disabled"/></td>
			<th class="thEdit rt mandatory">Status</th>
			<td class="tdEdit"><ui:ccselect name="status" codeType="INVOICE_STATUS" caption="==Select==" checkName="Status" options="mandatory"/></td>
			<th class="thEdit rt">Payment Due</th>
			<td class="tdEdit">
				<ui:text name="paymentDueDate" className="Ct hor" value="<%=paymentDueDate%>" style="width:90px" option="date"/>
				<ui:icon id="icnPaymentDueDate" className="fa-calendar hor"/>
			</td>
			<th class="thEdit rt mandatory">Pay Method</th>
			<td class="tdEdit"><ui:ccselect name="paymentMethod" codeType="INVOICE_PAYMENT_TYPE" caption="==Select==" checkName="Payment Method" options="mandatory"/></td>
		</tr>
		<tr>
			<th class="thEdit rt">Bank Account</th>
			<td class="tdEdit">
				<ui:hidden name="bankAccntId"/><ui:text name="bankAccntName" className="hor" status="disabled" style="width:220px"/>
				<ui:icon id="icnBankAccntSearch" className="fa-search hor"/>
			</td>
			<th class="thEdit rt">Bank Code</th>
			<td class="tdEdit"><ui:ccselect name="bankCode" codeType="BANK_TYPE" caption="==Select==" attribute="data-width:100%"/></td>
			<th class="thEdit rt">BSB</th>
			<td class="tdEdit"><ui:text name="bsb"/></td>
			<th class="thEdit rt">Account Number</th>
			<td class="tdEdit"><ui:text name="bankAccntNumber"/></td>
		</tr>
		<tr>
			<th class="thEdit rt">Ref Number</th>
			<td class="tdEdit"><ui:text name="refNumber"/></td>
			<th class="thEdit rt"></th>
			<td class="tdEdit"></td>
			<th class="thEdit rt"></th>
			<td class="tdEdit"></td>
			<th class="thEdit rt"></th>
			<td class="tdEdit"></td>
		</tr>
	</table>
	<div class="verGap4"></div>
	<div style="float:left;width:40%">
		<table class="tblEdit">
			<caption>Customer Information</caption>
			<colgroup>
				<col width="15%"/>
				<col width="40%"/>
				<col width="15%"/>
				<col width="*"/>
			</colgroup>
			<tr>
				<th class="thEdit rt mandatory">Name</th>
				<td class="tdEdit"><ui:text name="clientName" checkName="Customer Name" options="mandatory"/></td>
				<th class="thEdit rt">Telephone</th>
				<td class="tdEdit"><ui:text name="clientTelephone" option="numeric"/></td>
			</tr>
			<tr>
				<th class="thEdit rt">Email</th>
				<td class="tdEdit"><ui:text name="clientEmail" option="email"/></td>
				<th class="thEdit rt">Mobile</th>
				<td class="tdEdit"><ui:text name="clientMobile" option="numeric"/></td>
			</tr>
			<tr>
				<th class="thEdit rt">Address</th>
				<td class="tdEdit" colspan="3"><ui:text name="clientAddress"/></td>
			</tr>
		</table>
	</div>
	<div style="float:right;width:59%">
		<table class="tblInform">
			<caption>Invoice Information</caption>
			<colgroup>
				<col width="13%"/>
				<col width="20%"/>
				<col width="13%"/>
				<col width="*"/>
			</colgroup>
			<tr>
				<th class="thInform rt">Net Amount</th>
				<td class="tdInform"><ui:text name="netAmt" checkName="Net Amount" className="Rt numeric" option="numeric"/></td>
				<th class="thInform rt">Description</th>
				<td class="tdInform"><ui:text name="descriptionM"/></td>
			</tr>
			<tr>
				<th class="thInform rt">GST Amount</th>
				<td class="tdInform"><ui:text name="gstAmt" className="Rt numeric" option="numeric"/></td>
				<th class="thInform rt" rowspan="2">Additioanl Remark</th>
				<td class="tdInform" rowspan="2"><ui:txa name="additionalRemark" style="height:66px"/></td>
			</tr>
			<tr>
				<th class="thInform rt">Total Amount</th>
				<td class="tdInform"><ui:text name="totalAmt" checkName="Total Amount" className="Rt numeric" option="numeric" status="disabled"/></td>
			</tr>
		</table>
	</div>
</div>
<div id="divInformArea"></div>
<div class="breaker" style="height:4px;"></div>
<div class="divButtonArea areaContainerPopup">
	<div class="divButtonAreaLeft"></div>
	<div class="divButtonAreaRight">
		<ui:buttonGroup>
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
	<div id="divGridWrapper">
		<table id="tblGrid" class="tblGrid">
			<colgroup>
				<col width="2%"/>
				<col width="2%"/>
				<col width="6%"/>
				<col width="10%"/>
				<col width="10%"/>
				<col width="12%"/>
				<col width="*"/>
			</colgroup>
			<thead>
				<tr>
					<th class="thGrid"></th>
					<th class="thGrid"></th>
					<th class="thGrid">Row No.</th>
					<th class="thGrid mandatory">Unit</th>
					<th class="thGrid mandatory">Price</th>
					<th class="thGrid mandatory">Amount</th>
					<th class="thGrid">Description</th>
				</tr>
			</thead>
			<tbody id="tblGridBody">
				<tr class="noStripe">
					<td colspan="7" style="padding:0px;border-top:0px"><ul id="ulDetailHolder"></ul></td>
				</tr>
			</tbody>
		</table>
	</div>
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
			<col width="6%"/>
			<col width="10%"/>
			<col width="10%"/>
			<col width="12%"/>
			<col width="*"/>
		</colgroup>
		<tr class="noBorderAll">
			<th id="thDragHander" class="thGrid dragHandler"><ui:icon id="iDragHandler" className="fa-lg fa-sort"/></th>
			<th id="thDeleteButton" class="thGrid deleteButton"><i id="iDeleteButton" class="fa fa-lg fa-times"></i></th>
			<td class="tdGrid Lt"><ui:hidden name="invoiceDId"/><ui:text name="rowIndex" className="Ct" status="disabled"/></td>
			<td class="tdGrid Ct"><ui:text name="unit" className="Rt" checkName="Unit" options="mandatory" option="numeric"/></td>
			<td class="tdGrid Ct"><ui:text name="price" className="Rt" checkName="Price" options="mandatory" option="numeric"/></td>
			<td class="tdGrid Ct"><ui:text name="amount" className="Rt" checkName="Amount" options="mandatory" option="numeric" status="disabled"/></td>
			<td class="tdGrid Ct"><ui:text name="descriptionD" className="Lt"/></td>
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