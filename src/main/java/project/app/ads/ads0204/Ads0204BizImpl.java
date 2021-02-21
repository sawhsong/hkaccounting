/**************************************************************************************************
 * project
 * Description - Ads0204 - Invoice Management
 *	- Generated by Source Generator
 *************************************************************************************************/
package project.app.ads.ads0204;

import java.util.Random;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;

import project.common.extend.BaseBiz;
import project.common.extend.InvoicePdfExportHelper;
import project.conf.resource.ormapper.dao.SysOrg.SysOrgDao;
import project.conf.resource.ormapper.dao.SysUser.SysUserDao;
import project.conf.resource.ormapper.dao.UsrBankAccnt.UsrBankAccntDao;
import project.conf.resource.ormapper.dao.UsrInvoice.UsrInvoiceDao;
import project.conf.resource.ormapper.dao.UsrInvoiceD.UsrInvoiceDDao;
import project.conf.resource.ormapper.dao.UsrQuotation.UsrQuotationDao;
import project.conf.resource.ormapper.dao.UsrQuotationD.UsrQuotationDDao;
import project.conf.resource.ormapper.dto.oracle.SysOrg;
import project.conf.resource.ormapper.dto.oracle.UsrInvoice;
import project.conf.resource.ormapper.dto.oracle.UsrQuotation;
import zebra.config.MemoryBean;
import zebra.data.DataSet;
import zebra.data.ParamEntity;
import zebra.data.QueryAdvisor;
import zebra.exception.FrameworkException;
import zebra.util.CommonUtil;
import zebra.util.ConfigUtil;
import zebra.util.FileUtil;

public class Ads0204BizImpl extends BaseBiz implements Ads0204Biz {
	@Autowired
	private SysUserDao sysUserDao;
	@Autowired
	private SysOrgDao sysOrgDao;
	@Autowired
	private UsrQuotationDao usrQuotationDao;
	@Autowired
	private UsrQuotationDDao usrQuotationDDao;
	@Autowired
	private UsrInvoiceDao usrInvoiceDao;
	@Autowired
	private UsrInvoiceDDao usrInvoiceDDao;
	@Autowired
	private UsrBankAccntDao usrBankAccntDao;

	public ParamEntity getDefault(ParamEntity paramEntity) throws Exception {
		try {
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getList(ParamEntity paramEntity) throws Exception {
		DataSet req = paramEntity.getRequestDataSet();
		QueryAdvisor qa = paramEntity.getQueryAdvisor();
		HttpSession session = paramEntity.getSession();
		String userId = (String)session.getAttribute("UserId");
		String fromDate = req.getValue("fromDate");
		String toDate = req.getValue("toDate");
		String customerName = req.getValue("customerName");
		String status = req.getValue("status");

		try {
			qa.setObject("userId", userId);
			qa.setObject("fromDate", fromDate);
			qa.setObject("toDate", toDate);
			qa.setObject("customerName", customerName);
			qa.setObject("status", status);
			qa.setPagination(true);

			paramEntity.setAjaxResponseDataSet(usrInvoiceDao.getDataSetBySearchCriteria(qa));
			paramEntity.setTotalResultRows(qa.getTotalResultRows());
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getEdit(ParamEntity paramEntity) throws Exception {
		try {
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getInvoiceNumber(ParamEntity paramEntity) throws Exception {
		DataSet ds = new DataSet();
		String prefix = "INVN-";
		Random random = new Random();
		String uid = CommonUtil.uid();
		String randomNumber1 = CommonUtil.substring(uid, 7, 11);
		String randomNumber2 = CommonUtil.leftPad(CommonUtil.toString(random.nextInt(9999)), 4, "0");

		try {
			ds.addRow();
			ds.addColumn("Number", prefix+randomNumber1+randomNumber2);
			paramEntity.setAjaxResponseDataSet(ds);
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getMyInfo(ParamEntity paramEntity) throws Exception {
		HttpSession session = paramEntity.getSession();
		String userId = (String)session.getAttribute("UserId");

		try {
			paramEntity.setAjaxResponseDataSet(sysUserDao.getUserInfoDataSetByUserId(userId));
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getOrgInfo(ParamEntity paramEntity) throws Exception {
		HttpSession session = paramEntity.getSession();
		String orgId = (String)session.getAttribute("OrgId");

		try {
			paramEntity.setAjaxResponseDataSet(sysOrgDao.getDataSetByOrgId(orgId));
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getInvoiceMasterInfo(ParamEntity paramEntity) throws Exception {
		DataSet req = paramEntity.getRequestDataSet();
		String invoiceId = req.getValue("invoiceId");

		try {
			paramEntity.setAjaxResponseDataSet(usrInvoiceDao.getDataSetByInvoiceId(invoiceId));
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getInvoiceDetailInfo(ParamEntity paramEntity) throws Exception {
		DataSet req = paramEntity.getRequestDataSet();
		String invoiceId = req.getValue("invoiceId");

		try {
			paramEntity.setAjaxResponseDataSet(usrInvoiceDDao.getDataSetByInvoiceId(invoiceId));
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getQuotationMasterInfo(ParamEntity paramEntity) throws Exception {
		DataSet req = paramEntity.getRequestDataSet();
		String quotationId = req.getValue("quotationId");

		try {
			paramEntity.setAjaxResponseDataSet(usrQuotationDao.getDataSetByQuotationId(quotationId));
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getQuotationDetailInfo(ParamEntity paramEntity) throws Exception {
		DataSet req = paramEntity.getRequestDataSet();
		String quotationId = req.getValue("quotationId");

		try {
			paramEntity.setAjaxResponseDataSet(usrQuotationDDao.getDataSetByQuotationId(quotationId));
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getBankAccountInfo(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		String bankAccntId = requestDataSet.getValue("bankAccntId");

		try {
			paramEntity.setAjaxResponseDataSet(usrBankAccntDao.getDataSetByBankAccntId(bankAccntId));
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity doRemoveLogo(ParamEntity paramEntity) throws Exception {
		DataSet req = paramEntity.getRequestDataSet();
		String invoiceId = req.getValue("invoiceId");
		UsrInvoice usrInvoice = new UsrInvoice();
		int result = -1;

		try {
			usrInvoice.addUpdateColumn("PROVIDER_LOGO_PATH", "");
			result = usrInvoiceDao.updateColumn(invoiceId, usrInvoice);

			if (result <= 0) {
				throw new FrameworkException("E801", getMessage("E801", paramEntity));
			}

			paramEntity.setSuccess(true);
			paramEntity.setMessage("I801", getMessage("I801", paramEntity));
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity doSave(ParamEntity paramEntity) throws Exception {
		DataSet req = paramEntity.getRequestDataSet();
		DataSet fileDataSet = paramEntity.getRequestFileDataSet();
		HttpSession session = paramEntity.getSession();
		String userId = (String)session.getAttribute("UserId");
		String delimiter = ConfigUtil.getProperty("delimiter.data");
		String invoiceId = req.getValue("invoiceId");
		String webLogoPath = ConfigUtil.getProperty("path.image.orgLogo");
		String uploadLogoPath = ConfigUtil.getProperty("path.dir.uploadedOrgLogo");
		String webRootPath = (String)MemoryBean.get("applicationRealPath");
		String dateFormat = ConfigUtil.getProperty("format.date.java");
		String providerOrgId = req.getValue("providerOrgId");
		String quotationId = req.getValue("quotationId");
		String pathToCopy = "";
		int detailLength = CommonUtil.toInt(req.getValue("detailLength"));
		UsrInvoice usrInvoice = new UsrInvoice();
		DataSet detail = new DataSet();
		String header[] = new String[] {"INVOICE_D_ID", "ROW_INDEX", "UNIT", "PRICE", "AMOUNT", "DESCRIPTION", "USER_ID"};
		int result = -1;

		try {
			if (detailLength > 0) {
				detail.addName(header);
				for (int i=0; i<detailLength; i++) {
					detail.addRow();
					detail.setValue(i, "INVOICE_D_ID", req.getValue("invoiceDId"+delimiter+i));
					detail.setValue(i, "ROW_INDEX", req.getValue("rowIndex"+delimiter+i));
					detail.setValue(i, "UNIT", req.getValue("unit"+delimiter+i));
					detail.setValue(i, "PRICE", req.getValue("price"+delimiter+i));
					detail.setValue(i, "AMOUNT", req.getValue("amount"+delimiter+i));
					detail.setValue(i, "DESCRIPTION", req.getValue("descriptionD"+delimiter+i));
					detail.setValue(i, "USER_ID", userId);
				}
			}

			if (CommonUtil.isBlank(invoiceId)) {
				if (CommonUtil.isNotBlank(providerOrgId)) {
					SysOrg sysOrg = sysOrgDao.getOrgByOrgId(providerOrgId);
					usrInvoice.setProviderLogoPath(sysOrg.getLogoPath());
				}

				if (CommonUtil.isNotBlank(quotationId)) {
					UsrQuotation usrQuotation = usrQuotationDao.getQuotationByQuotationId(quotationId);
					usrInvoice.setProviderLogoPath(usrQuotation.getProviderLogoPath());
				}
			}

			if (fileDataSet.getRowCnt() > 0) {
				String fileName = fileDataSet.getValue("NEW_NAME");

				// Copy the file to web source
				pathToCopy = webRootPath + webLogoPath + "/" + fileName;
				FileUtil.copyFile(fileDataSet, pathToCopy);

				// Move the file to repository
				pathToCopy = uploadLogoPath + "/" + fileName;
				FileUtil.moveFile(fileDataSet, pathToCopy);

				usrInvoice.setProviderLogoPath(webLogoPath + "/" + fileName);
			}

			usrInvoice.setInvoiceNumber(req.getValue("invoiceNumber"));
			usrInvoice.setIssueDate(CommonUtil.toDate(req.getValue("issueDate"), dateFormat));
			usrInvoice.setUserId(userId);
			usrInvoice.setQuotationId(req.getValue("quotationId"));
			usrInvoice.setStatus(req.getValue("status"));
			usrInvoice.setProviderOrgId(providerOrgId);
			usrInvoice.setProviderName(req.getValue("providerName"));
			usrInvoice.setProviderTelephone(CommonUtil.remove(req.getValue("providerTelephone"), " "));
			usrInvoice.setProviderMobile(CommonUtil.remove(req.getValue("providerMobile"), " "));
			usrInvoice.setProviderEmail(req.getValue("providerEmail"));
			usrInvoice.setProviderAddress(req.getValue("providerAddress"));
			usrInvoice.setProviderAbn(CommonUtil.remove(req.getValue("providerAbn"), " "));
			usrInvoice.setProviderAcn(CommonUtil.remove(req.getValue("providerAcn"), " "));
			usrInvoice.setClientOrgId("");
			usrInvoice.setClientUserId("");
			usrInvoice.setClientName(req.getValue("clientName"));
			usrInvoice.setClientTelephone(CommonUtil.remove(req.getValue("clientTelephone"), " "));
			usrInvoice.setClientMobile(CommonUtil.remove(req.getValue("clientMobile"), " "));
			usrInvoice.setClientEmail(req.getValue("clientEmail"));
			usrInvoice.setClientAddress(req.getValue("clientAddress"));
			usrInvoice.setNetAmt(CommonUtil.toDouble(req.getValue("netAmt")));
			usrInvoice.setGstAmt(CommonUtil.toDouble(req.getValue("gstAmt")));
			usrInvoice.setTotalAmt(CommonUtil.toDouble(req.getValue("totalAmt")));
			usrInvoice.setDescription(req.getValue("descriptionM"));
			usrInvoice.setAdditionalRemark(req.getValue("additionalRemark"));
			usrInvoice.setPaymentDueDate(CommonUtil.toDate(req.getValue("paymentDueDate"), dateFormat));
			usrInvoice.setPaymentMethod(req.getValue("paymentMethod"));
			usrInvoice.setBankAccntId(req.getValue("bankAccntId"));
			usrInvoice.setBankCode(req.getValue("bankCode"));
			usrInvoice.setBsb(CommonUtil.remove(req.getValue("bsb"), " "));
			usrInvoice.setBankAccntNumber(req.getValue("bankAccntNumber"));
			usrInvoice.setBankAccntName(req.getValue("bankAccntName"));
			usrInvoice.setRefNumber(req.getValue("refNumber"));

			if (CommonUtil.isBlank(invoiceId)) {
				usrInvoice.setInvoiceId(CommonUtil.uid());
				usrInvoice.setInsertUserId(userId);
				usrInvoice.setInsertDate(CommonUtil.toDate(CommonUtil.getSysdate()));

				result = usrInvoiceDao.insert(usrInvoice, detail);
			} else {
				usrInvoice.setInvoiceId(invoiceId);
				usrInvoice.setUpdateUserId(userId);
				usrInvoice.setUpdateDate(CommonUtil.toDate(CommonUtil.getSysdate()));
				usrInvoice.addUpdateColumnFromField();

				result = usrInvoiceDao.update(invoiceId, usrInvoice, detail);
			}

			if (result <= 0) {
				throw new FrameworkException("E801", getMessage("E801", paramEntity));
			}

			paramEntity.setAjaxResponseDataSet(usrInvoice.getDataSet());
			paramEntity.setSuccess(true);
			paramEntity.setMessage("I801", getMessage("I801", paramEntity));
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity doDelete(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		String invoiceId = requestDataSet.getValue("invoiceId");
		String chkForDel = requestDataSet.getValue("chkForDel");
		String invoiceIds[] = CommonUtil.splitWithTrim(chkForDel, ConfigUtil.getProperty("delimiter.record"));
		int result = 0;

		try {
			if (CommonUtil.isBlank(invoiceId)) {
				result = usrInvoiceDao.delete(invoiceIds);
			} else {
				result = usrInvoiceDao.delete(invoiceId);
			}

			if (result <= 0) {
				throw new FrameworkException("E801", getMessage("E801", paramEntity));
			}

			paramEntity.setSuccess(true);
			paramEntity.setMessage("I801", getMessage("I801", paramEntity));
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getPreview(ParamEntity paramEntity) throws Exception {
		DataSet req = paramEntity.getRequestDataSet();
		String invoiceId = req.getValue("invoiceId");
		UsrInvoice usrInvoice;
		DataSet invoiceDetail;

		try {
			usrInvoice = usrInvoiceDao.getInvoiceByInvoiceId(invoiceId);
			invoiceDetail = usrInvoiceDDao.getDataSetByInvoiceId(invoiceId);

			paramEntity.setObject("usrInvoice", usrInvoice);
			paramEntity.setObject("invoiceDetail", invoiceDetail);
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity doExport(ParamEntity paramEntity) throws Exception {
		DataSet req = paramEntity.getRequestDataSet();
		InvoicePdfExportHelper exportHelper;
		String invoiceId = req.getValue("invoiceId");
		UsrInvoice usrInvoice;
		DataSet invoiceDetail;

		try {
			usrInvoice = usrInvoiceDao.getInvoiceByInvoiceId(invoiceId);
			invoiceDetail = usrInvoiceDDao.getDataSetByInvoiceId(invoiceId);

			exportHelper = new project.common.extend.InvoicePdfExportHelper();
			exportHelper.setFileType("pdf");
			exportHelper.setFileExtention("pdf");

			exportHelper.setUsrInvoice(usrInvoice);
			exportHelper.setUsrInvoiceDDataSet(invoiceDetail);
			exportHelper.setFileName("Invoice-"+usrInvoice.getInvoiceNumber());

			paramEntity.setSuccess(true);
			paramEntity.setFileToExport(exportHelper.createFile());
			paramEntity.setFileNameToExport(exportHelper.getFileName());
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}
}