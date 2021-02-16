/**************************************************************************************************
 * project
 * Description - Ads0202 - Quote Management
 *	- Generated by Source Generator
 *************************************************************************************************/
package project.app.ads.ads0202;

import java.util.Random;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;

import zebra.config.MemoryBean;
import zebra.data.DataSet;
import zebra.data.ParamEntity;
import zebra.data.QueryAdvisor;
import zebra.exception.FrameworkException;
import zebra.export.ExportHelper;
import zebra.util.CommonUtil;
import zebra.util.ConfigUtil;
import zebra.util.ExportUtil;
import zebra.util.FileUtil;
import project.common.extend.BaseBiz;
import project.common.module.commoncode.CommonCodeManager;
import project.conf.resource.ormapper.dao.SysBoard.SysBoardDao;
import project.conf.resource.ormapper.dao.SysBoardFile.SysBoardFileDao;
import project.conf.resource.ormapper.dao.SysOrg.SysOrgDao;
import project.conf.resource.ormapper.dao.SysUser.SysUserDao;
import project.conf.resource.ormapper.dao.UsrQuotation.UsrQuotationDao;
import project.conf.resource.ormapper.dao.UsrQuotationD.UsrQuotationDDao;
import project.conf.resource.ormapper.dto.oracle.SysBoard;
import project.conf.resource.ormapper.dto.oracle.UsrQuotation;

public class Ads0202BizImpl extends BaseBiz implements Ads0202Biz {
	@Autowired
	private SysUserDao sysUserDao;
	@Autowired
	private SysOrgDao sysOrgDao;
	@Autowired
	private UsrQuotationDao usrQuotationDao;
	@Autowired
	private UsrQuotationDDao usrQuotationDDao;

	public ParamEntity getDefault(ParamEntity paramEntity) throws Exception {
		try {
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getList(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		QueryAdvisor queryAdvisor = paramEntity.getQueryAdvisor();
		HttpSession session = paramEntity.getSession();
		String userId = (String)session.getAttribute("UserId");

		try {
			queryAdvisor.setPagination(true);

			paramEntity.setAjaxResponseDataSet(new DataSet());
			paramEntity.setTotalResultRows(queryAdvisor.getTotalResultRows());
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

	public ParamEntity getQuotationNumber(ParamEntity paramEntity) throws Exception {
		DataSet ds = new DataSet();
		String prefix = "QN-";
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

	public ParamEntity doRemoveLogo(ParamEntity paramEntity) throws Exception {
		HttpSession session = paramEntity.getSession();
		String quotationId = (String)session.getAttribute("quotationId");
		UsrQuotation usrQuotation = new UsrQuotation();
		int result = -1;

		try {
			usrQuotation.addUpdateColumn("PROVIDER_LOGO_PATH", "");
			result = usrQuotationDao.updateColumn(quotationId, usrQuotation);

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
		String quotationId = req.getValue("quotationId");
		String webLogoPath = ConfigUtil.getProperty("path.image.orgLogo");
		String uploadLogoPath = ConfigUtil.getProperty("path.dir.uploadedOrgLogo");
		String webRootPath = (String)MemoryBean.get("applicationRealPath");
		String dateFormat = ConfigUtil.getProperty("format.date.java");
		String pathToCopy = "";
		int detailLength = CommonUtil.toInt(req.getValue("detailLength"));
		UsrQuotation usrQuotation = new UsrQuotation();
		DataSet detail = new DataSet();
		String header[] = new String[] {"QUOTATION_D_ID", "ROW_INDEX", "UNIT", "PRICE", "AMOUNT", "DESCRIPTION", "USER_ID"};
		int result = -1;

		try {
			if (detailLength > 0) {
				detail.addName(header);
				for (int i=0; i<detailLength; i++) {
					detail.addRow();
					detail.setValue(i, "QUOTATION_D_ID", req.getValue("quotationDId"+delimiter+i));
					detail.setValue(i, "ROW_INDEX", req.getValue("rowIndex"+delimiter+i));
					detail.setValue(i, "UNIT", req.getValue("unit"+delimiter+i));
					detail.setValue(i, "PRICE", req.getValue("price"+delimiter+i));
					detail.setValue(i, "AMOUNT", req.getValue("amount"+delimiter+i));
					detail.setValue(i, "DESCRIPTION", req.getValue("description"+delimiter+i));
					detail.setValue(i, "USER_ID", userId);
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

				usrQuotation.setProviderLogoPath(webLogoPath + "/" + fileName);
			}

			usrQuotation.setQuotationNumber(req.getValue("quotationNumber"));
			usrQuotation.setIssueDate(CommonUtil.toDate(req.getValue("issueDate"), dateFormat));
			usrQuotation.setUserId(userId);
			usrQuotation.setProviderOrgId(req.getValue("providerOrgId"));
			usrQuotation.setProviderName(req.getValue("providerName"));
			usrQuotation.setProviderTelephone(CommonUtil.remove(req.getValue("providerTelephone"), " "));
			usrQuotation.setProviderMobile(CommonUtil.remove(req.getValue("providerMobile"), " "));
			usrQuotation.setProviderEmail(req.getValue("providerEmail"));
			usrQuotation.setProviderAddress(req.getValue("providerAddress"));
			usrQuotation.setProviderAbn(CommonUtil.remove(req.getValue("providerAbn"), " "));
			usrQuotation.setProviderAcn(CommonUtil.remove(req.getValue("providerAcn"), " "));
			usrQuotation.setClientOrgId("");
			usrQuotation.setClientUserId("");
			usrQuotation.setClientName(req.getValue("clientName"));
			usrQuotation.setClientTelephone(CommonUtil.remove(req.getValue("clientTelephone"), " "));
			usrQuotation.setClientMobile(CommonUtil.remove(req.getValue("clientMobile"), " "));
			usrQuotation.setClientEmail(req.getValue("clientEmail"));
			usrQuotation.setClientAddress(req.getValue("clientAddress"));
			usrQuotation.setNetAmt(CommonUtil.toDouble(req.getValue("netAmt")));
			usrQuotation.setGstAmt(CommonUtil.toDouble(req.getValue("gstAmt")));
			usrQuotation.setTotalAmt(CommonUtil.toDouble(req.getValue("totalAmt")));
			usrQuotation.setDescription(req.getValue("description"));
			usrQuotation.setAdditionalRemark(req.getValue("additionalRemark"));

			if (CommonUtil.isBlank(quotationId)) {
				usrQuotation.setQuotationId(CommonUtil.uid());
				usrQuotation.setInsertUserId(userId);
				usrQuotation.setInsertDate(CommonUtil.toDate(CommonUtil.getSysdate()));

				result = usrQuotationDao.insert(usrQuotation, detail);
			} else {
				usrQuotation.setQuotationId(quotationId);
				usrQuotation.setUpdateUserId(userId);
				usrQuotation.setUpdateDate(CommonUtil.toDate(CommonUtil.getSysdate()));

				result = usrQuotationDao.update(quotationId, usrQuotation, detail);
			}

			if (result <= 0) {
				throw new FrameworkException("E801", getMessage("E801", paramEntity));
			}

			paramEntity.setAjaxResponseDataSet(usrQuotation.getDataSet());
			paramEntity.setSuccess(true);
			paramEntity.setMessage("I801", getMessage("I801", paramEntity));
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity doDelete(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		int result = 0;

		try {
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

	public ParamEntity doExport(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		QueryAdvisor queryAdvisor = paramEntity.getQueryAdvisor();
		ExportHelper exportHelper;
		String columnHeader[] = new String[] {};
		String pageTitle = "", fileName = "";
		String fileType = requestDataSet.getValue("fileType");
		String dataRange = requestDataSet.getValue("dataRange");

		try {
			exportHelper = ExportUtil.getExportHelper(fileType);
			exportHelper.setPageTitle(pageTitle);
			exportHelper.setColumnHeader(columnHeader);
			exportHelper.setFileName(fileName);
			exportHelper.setPdfWidth(1000);

			if (CommonUtil.containsIgnoreCase(dataRange, "all"))
				queryAdvisor.setPagination(false);
			else {
				queryAdvisor.setPagination(true);
			}

			exportHelper.setSourceDataSet(new DataSet());

			paramEntity.setSuccess(true);
			paramEntity.setFileToExport(exportHelper.createFile());
			paramEntity.setFileNameToExport(exportHelper.getFileName());
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}
}