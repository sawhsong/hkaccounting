/**************************************************************************************************
 * project
 * Description - Rkm0404 - Asset Expense
 *	- Generated by Source Generator
 *************************************************************************************************/
package project.app.rkm.rkm0404;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;

import zebra.data.DataSet;
import zebra.data.ParamEntity;
import zebra.data.QueryAdvisor;
import zebra.exception.FrameworkException;
import zebra.export.ExportHelper;
import zebra.util.CommonUtil;
import zebra.util.ConfigUtil;
import zebra.util.ExportUtil;

import project.common.extend.BaseBiz;
import project.common.module.commoncode.CommonCodeManager;
import project.conf.resource.ormapper.dao.SysAssetType.SysAssetTypeDao;
import project.conf.resource.ormapper.dao.SysBoard.SysBoardDao;
import project.conf.resource.ormapper.dao.SysBoardFile.SysBoardFileDao;
import project.conf.resource.ormapper.dao.UsrAsset.UsrAssetDao;
import project.conf.resource.ormapper.dto.oracle.SysAssetType;
import project.conf.resource.ormapper.dto.oracle.SysBoard;
import project.conf.resource.ormapper.dto.oracle.SysRepaymentType;
import project.conf.resource.ormapper.dto.oracle.UsrAsset;
import project.conf.resource.ormapper.dto.oracle.UsrIncome;

public class Rkm0404BizImpl extends BaseBiz implements Rkm0404Biz {
	@Autowired
	private UsrAssetDao usrAssetDao;
	@Autowired
	private SysAssetTypeDao sysAssetTypeDao;

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
		String orgId = CommonUtil.nvl((String)session.getAttribute("OrgIdForAdminTool"), (String)session.getAttribute("OrgId"));

		try {
			queryAdvisor.setObject("orgId", orgId);
			queryAdvisor.setObject("langCode", (String)session.getAttribute("langCode"));
			queryAdvisor.setRequestDataSet(requestDataSet);
			queryAdvisor.setPagination(true);

			paramEntity.setAjaxResponseDataSet(usrAssetDao.getAssetDataSetByCriteria(queryAdvisor));
			paramEntity.setTotalResultRows(queryAdvisor.getTotalResultRows());
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getEdit(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		String assetId = requestDataSet.getValue("assetId");

		try {
			paramEntity.setAjaxResponseDataSet(usrAssetDao.getAssetDataSetByAssetIdForUpdate(assetId));
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity calculateDataEntry(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		DataSet result = new DataSet(new String[] {"netAsset"});
		double grossAsset = CommonUtil.toDouble(requestDataSet.getValue("grossAsset"));
		double gst = CommonUtil.toDouble(requestDataSet.getValue("gst"));
		double netAsset = 0;

		try {
			result.addRow();

			netAsset = (grossAsset - gst);

			result.setValue("netAsset", CommonUtil.toString(netAsset, "#,##0.00"));

			paramEntity.setAjaxResponseDataSet(result);
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity exeSave(ParamEntity paramEntity) throws Exception {
		DataSet dsReq = paramEntity.getRequestDataSet();
		DataSet dsFile = paramEntity.getRequestFileDataSet();
		HttpSession session = paramEntity.getSession();
		UsrAsset usrAsset = new UsrAsset();
		SysAssetType sysAssetType = new SysAssetType();
		String assetId = CommonUtil.nvl(dsReq.getValue("deAssetId"), "-1");
		String dateFormat = ConfigUtil.getProperty("format.date.java");
		String userId = (String)session.getAttribute("UserId");
		String orgId = CommonUtil.nvl((String)session.getAttribute("OrgIdForAdminTool"), (String)session.getAttribute("OrgId"));
		String orgCategory = CommonUtil.nvl((String)session.getAttribute("OrgCategoryForAdminTool"), (String)session.getAttribute("OrgCategory"));
		String saveType = (CommonUtil.equals(assetId, "-1")) ? "I" : "U";
		int result = -1;

		try {
			if (CommonUtil.equals(saveType, "I")) {
				usrAsset.setAssetId(CommonUtil.uid());
			} else {
				usrAsset = usrAssetDao.getAssetById(assetId);
			}

			usrAsset.setAssetYear(dsReq.getValue("financialYear"));
			usrAsset.setQuarterName(dsReq.getValue("quarterName"));
			usrAsset.setOrgId(orgId);
			sysAssetType = sysAssetTypeDao.getAssetTypeByOrgCategoryAssetType(orgCategory, dsReq.getValue("deAssetType"));
			usrAsset.setAssetTypeId(sysAssetType.getAssetTypeId());
			usrAsset.setAssetDate(CommonUtil.toDate(dsReq.getValue("deDate"), dateFormat));
			usrAsset.setGrossAmt(CommonUtil.toDouble(dsReq.getValue("deGrossAsset")));
			usrAsset.setGstAmt(CommonUtil.toDouble(dsReq.getValue("deGst")));
			usrAsset.setNetAmt(CommonUtil.toDouble(dsReq.getValue("deNetAsset")));
			usrAsset.setDescription(dsReq.getValue("deRemark"));

			if (CommonUtil.equals(saveType, "I")) {
				usrAsset.setIsCompleted("N");
				usrAsset.setInsertUserId(userId);
				usrAsset.setInsertDate(CommonUtil.getSysdateAsDate());

				result = usrAssetDao.insert(usrAsset, dsFile);
			} else {
				usrAsset.setUpdateUserId(userId);
				usrAsset.setUpdateDate(CommonUtil.getSysdateAsDate());

				result = usrAssetDao.update(assetId, usrAsset, dsFile);
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
/*
	public ParamEntity exeComplete(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		String chkForDel = requestDataSet.getValue("chkForDel");
		String incomeIds[] = CommonUtil.splitWithTrim(chkForDel, ConfigUtil.getProperty("delimiter.record"));
		int result = 0;

		try {
			result = usrAssetDao.exeCompleteByIncomeIds(incomeIds);

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

	public ParamEntity exeDelete(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		String chkForDel = requestDataSet.getValue("chkForDel");
		String incomeIds[] = CommonUtil.splitWithTrim(chkForDel, ConfigUtil.getProperty("delimiter.record"));
		int result = 0;

		try {
			result = usrAssetDao.deleteByIncomeIds(incomeIds);

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

	public ParamEntity exeExport(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		QueryAdvisor queryAdvisor = paramEntity.getQueryAdvisor();
		HttpSession session = paramEntity.getSession();
		String orgId = CommonUtil.nvl((String)session.getAttribute("OrgIdForAdminTool"), (String)session.getAttribute("OrgId"));
		String orgCategory = CommonUtil.nvl((String)session.getAttribute("OrgCategoryForAdminTool"), (String)session.getAttribute("OrgCategory"));
		ExportHelper exportHelper;
		String columnHeader[], fileHeader[];
		String pageTitle, fileName;
		String fileType = requestDataSet.getValue("fileType");
		String dataRange = requestDataSet.getValue("dataRange");

		try {
			pageTitle = "Other Sales Income List";
			fileName = "OtherSalesIncomeList";
			columnHeader = new String[] {"INCOME_DATE", "GROSS_AMT", "GST_AMT", "NET_AMT", "IS_COMPLETED", "DESCRIPTION"};
			fileHeader = new String[] {"Date", "Gross Sales", "GST", "Net Sales", "Is Completed", "Description"};

			exportHelper = ExportUtil.getExportHelper(fileType);
			exportHelper.setPageTitle(pageTitle);
			exportHelper.setColumnHeader(columnHeader);
			exportHelper.setFileHeader(fileHeader);
			exportHelper.setFileName(fileName);
			exportHelper.setPdfWidth(1000);

			queryAdvisor.setObject("orgId", orgId);
			queryAdvisor.setObject("orgCategory", orgCategory);
			queryAdvisor.setObject("langCode", (String)session.getAttribute("langCode"));
			queryAdvisor.setRequestDataSet(requestDataSet);
			if (CommonUtil.containsIgnoreCase(dataRange, "all"))
				queryAdvisor.setPagination(false);
			else {
				queryAdvisor.setPagination(true);
			}

			exportHelper.setSourceDataSet(usrAssetDao.getOtherIncomeDataSetByCriteria(queryAdvisor));

			paramEntity.setSuccess(true);
			paramEntity.setFileToExport(exportHelper.createFile());
			paramEntity.setFileNameToExport(exportHelper.getFileName());
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}
*/
}