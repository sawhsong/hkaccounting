/**************************************************************************************************
 * project
 * Description - Rkm0202 - Sales Income
 *	- Generated by Source Generator
 *************************************************************************************************/
package project.app.rkm.rkm0202;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;

import project.common.extend.BaseBiz;
import project.common.module.commoncode.CommonCodeManager;
import project.conf.resource.ormapper.dao.SysBoard.SysBoardDao;
import project.conf.resource.ormapper.dao.UsrIncome.UsrIncomeDao;
import project.conf.resource.ormapper.dto.oracle.SysBoard;
import project.conf.resource.ormapper.dto.oracle.UsrIncome;
import zebra.data.DataSet;
import zebra.data.ParamEntity;
import zebra.data.QueryAdvisor;
import zebra.exception.FrameworkException;
import zebra.export.ExportHelper;
import zebra.util.CommonUtil;
import zebra.util.ConfigUtil;
import zebra.util.ExportUtil;

public class Rkm0202BizImpl extends BaseBiz implements Rkm0202Biz {
	@Autowired
	private UsrIncomeDao usrIncomeDao;
	@Autowired
	private SysBoardDao sysBoardDao;

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

			paramEntity.setAjaxResponseDataSet(usrIncomeDao.getSalesIncomeDataSetByCriteria(queryAdvisor));
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getEdit(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		String incomeIdDate = requestDataSet.getValue("incomeIdDate");
		String incomeId = "", incomeDate = "";

		try {
			incomeId = CommonUtil.split(incomeIdDate, "_")[0];
			incomeDate = CommonUtil.split(incomeIdDate, "_")[1];

			paramEntity.setAjaxResponseDataSet(usrIncomeDao.getIncomeDataSetByIdForUpdate(incomeId, incomeDate));
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity calculateDataEntry(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		DataSet result = new DataSet(new String[] {"grossSales", "gst", "netSales"});
		double grossSales = 0, gst = 0, netSales = 0;
		double nonCash = CommonUtil.toDouble(requestDataSet.getValue("nonCash"));
		double cash = CommonUtil.toDouble(requestDataSet.getValue("cash"));
		double gstFree = CommonUtil.toDouble(requestDataSet.getValue("gstFree"));

		try {
			result.addRow();

			grossSales = (nonCash + cash);
			gst = (grossSales - gstFree) * 0.1;
			netSales = (grossSales - gst);

			result.setValue("grossSales", CommonUtil.toString(grossSales, "#,##0.00"));
			result.setValue("gst", CommonUtil.toString(gst, "#,##0.00"));
			result.setValue("netSales", CommonUtil.toString(netSales, "#,##0.00"));

			paramEntity.setAjaxResponseDataSet(result);
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity exeSave(ParamEntity paramEntity) throws Exception {
		DataSet dsReq = paramEntity.getRequestDataSet();
		HttpSession session = paramEntity.getSession();
		UsrIncome usrIncome = new UsrIncome();
		String incomeId = dsReq.getValue("deIncomeId");
		String uid = (CommonUtil.equals(incomeId, "-1")) ? CommonUtil.uid() : incomeId;
		String dateFormat = ConfigUtil.getProperty("format.date.java");
		String userId = (String)session.getAttribute("UserId");
		String orgId = (String)session.getAttribute("OrgId");
		int result = -1;

		try {
			usrIncome.setIncomeId(uid);
			usrIncome.setIncomeYear(dsReq.getValue("financialYear"));
			usrIncome.setQuarterName(dsReq.getValue("quarterName"));
			usrIncome.setOrgId(orgId);
			usrIncome.setIncomeEntryType("SALES");
			usrIncome.setRecordKeepingType(dsReq.getValue("deRecordKeepingType"));
			usrIncome.setIncomeTypeId(null);
			usrIncome.setIncomeDate(CommonUtil.toDate(dsReq.getValue("deDate"), dateFormat));
			usrIncome.setNonCashAmt(CommonUtil.toDouble(dsReq.getValue("deNonCash")));
			usrIncome.setCashAmt(CommonUtil.toDouble(dsReq.getValue("deCash")));
			usrIncome.setGrossAmt(CommonUtil.toDouble(dsReq.getValue("deGrossSales")));
			usrIncome.setGstFreeAmt(CommonUtil.toDouble(dsReq.getValue("deGstFree")));
			usrIncome.setGstAmt(CommonUtil.toDouble(dsReq.getValue("deGst")));
//			usrIncome.setAppliedGst(null);
			usrIncome.setNetAmt(CommonUtil.toDouble(dsReq.getValue("deNetSales")));
			usrIncome.setIsCompleted("N");
			usrIncome.setDescription(dsReq.getValue("deRemark"));
			usrIncome.setInsertUserId(userId);
			usrIncome.setInsertDate(CommonUtil.toDate(CommonUtil.getSysdate()));

			if (CommonUtil.equals(incomeId, "-1")) {
				result = usrIncomeDao.insert(usrIncome);
			} else {
				result = usrIncomeDao.update(incomeId, usrIncome);
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





	public ParamEntity exeDelete(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		String articleId = requestDataSet.getValue("articleId");
		String chkForDel = requestDataSet.getValue("chkForDel");
		String articleIds[] = CommonUtil.splitWithTrim(chkForDel, ConfigUtil.getProperty("delimiter.record"));
		int result = 0;

		try {
			if (CommonUtil.isBlank(articleId)) {
				result = sysBoardDao.delete(articleIds);
			} else {
				result = sysBoardDao.delete(articleId);
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

	public ParamEntity exeExport(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		QueryAdvisor queryAdvisor = paramEntity.getQueryAdvisor();
		ExportHelper exportHelper;
		String columnHeader[];
		String pageTitle, fileName;
		String fileType = requestDataSet.getValue("fileType");
		String dataRange = requestDataSet.getValue("dataRange");

		try {
			pageTitle = "Board List";
			fileName = "BoardList";
			columnHeader = new String[]{"article_id", "writer_name", "writer_email", "article_subject", "created_date"};

			exportHelper = ExportUtil.getExportHelper(fileType);
			exportHelper.setPageTitle(pageTitle);
			exportHelper.setColumnHeader(columnHeader);
			exportHelper.setFileName(fileName);
			exportHelper.setPdfWidth(1000);

			queryAdvisor.setRequestDataSet(requestDataSet);
			if (CommonUtil.containsIgnoreCase(dataRange, "all"))
				queryAdvisor.setPagination(false);
			else {
				queryAdvisor.setPagination(true);
			}

			exportHelper.setSourceDataSet(sysBoardDao.getNoticeBoardDataSetByCriteria(queryAdvisor));

			paramEntity.setSuccess(true);
			paramEntity.setFileToExport(exportHelper.createFile());
			paramEntity.setFileNameToExport(exportHelper.getFileName());
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}
}