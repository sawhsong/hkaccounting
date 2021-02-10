/**************************************************************************************************
 * project
 * Description - Sys0802 - Financial Period Type
 *	- Generated by Source Generator
 *************************************************************************************************/
package project.app.sys.sys0802;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;

import project.common.extend.BaseBiz;
import project.conf.resource.ormapper.dao.SysFinancialPeriod.SysFinancialPeriodDao;
import project.conf.resource.ormapper.dto.oracle.SysFinancialPeriod;
import zebra.data.DataSet;
import zebra.data.ParamEntity;
import zebra.data.QueryAdvisor;
import zebra.exception.FrameworkException;
import zebra.util.CommonUtil;
import zebra.util.ConfigUtil;

public class Sys0802BizImpl extends BaseBiz implements Sys0802Biz {
	@Autowired
	private SysFinancialPeriodDao sysFinancialPeriodDao;

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

		try {
			queryAdvisor.setRequestDataSet(requestDataSet);
			queryAdvisor.setPagination(true);

			paramEntity.setAjaxResponseDataSet(sysFinancialPeriodDao.getPeriodDataSetByCriteria(queryAdvisor));
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

	public ParamEntity getFinancialPeriod(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		String periodYear = requestDataSet.getValue("periodYear");
		String quarterCode = requestDataSet.getValue("quarterCode");

		try {
			paramEntity.setAjaxResponseDataSet(sysFinancialPeriodDao.getDataSetByPeriodYearAndCode(periodYear, quarterCode));
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity doSave(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		HttpSession session = paramEntity.getSession();
		String dateFormat = ConfigUtil.getProperty("format.date.java");
		String loggedInUserId = (String)session.getAttribute("UserId");
		String periodYear = requestDataSet.getValue("periodYear");
		String quarterCode = requestDataSet.getValue("quarterCode");
		SysFinancialPeriod sysFinancialPeriod = new SysFinancialPeriod();
		int result = -1;

		try {
			sysFinancialPeriod = sysFinancialPeriodDao.getFinancialPeriodByPeriodYearAndCode(periodYear, quarterCode);
			if (sysFinancialPeriod == null || CommonUtil.isBlank(sysFinancialPeriod.getPeriodYear())) {
				sysFinancialPeriod.setPeriodYear(requestDataSet.getValue("periodYear"));
				sysFinancialPeriod.setQuarterCode(requestDataSet.getValue("quarterCode"));
				sysFinancialPeriod.setFinancialYear(requestDataSet.getValue("financialYearFrom")+"-"+requestDataSet.getValue("financialYearTo"));
				sysFinancialPeriod.setQuarterName(requestDataSet.getValue("quarterName"));
				sysFinancialPeriod.setDateFrom(CommonUtil.toDate(requestDataSet.getValue("dateFrom"), dateFormat));
				sysFinancialPeriod.setDateTo(CommonUtil.toDate(requestDataSet.getValue("dateTo"), dateFormat));
				sysFinancialPeriod.setInsertUserId(loggedInUserId);
				sysFinancialPeriod.setInsertDate(CommonUtil.getSysdateAsDate());

				result = sysFinancialPeriodDao.insert(sysFinancialPeriod);
			} else {
				sysFinancialPeriod.setFinancialYear(requestDataSet.getValue("financialYearFrom")+"-"+requestDataSet.getValue("financialYearTo"));
				sysFinancialPeriod.setQuarterName(requestDataSet.getValue("quarterName"));
				sysFinancialPeriod.setDateFrom(CommonUtil.toDate(requestDataSet.getValue("dateFrom"), dateFormat));
				sysFinancialPeriod.setDateTo(CommonUtil.toDate(requestDataSet.getValue("dateTo"), dateFormat));
				sysFinancialPeriod.setUpdateUserId(loggedInUserId);
				sysFinancialPeriod.setUpdateDate(CommonUtil.getSysdateAsDate());
				sysFinancialPeriod.addUpdateColumnFromField();

				result = sysFinancialPeriodDao.updateWithKey(sysFinancialPeriod, periodYear, quarterCode);
			}

			if (result <= 0) {
				throw new FrameworkException("E801", getMessage("E801", paramEntity));
			}

			paramEntity.setAjaxResponseDataSet(sysFinancialPeriodDao.getDataSetByPeriodYearAndCode(periodYear, quarterCode));
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity doDelete(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		String periodYear = requestDataSet.getValue("periodYear");
		String quarterCode = requestDataSet.getValue("quarterCode");
		String chkForDel = requestDataSet.getValue("chkForDel");
		String keyIds[] = CommonUtil.splitWithTrim(chkForDel, ConfigUtil.getProperty("delimiter.record"));
		int result = 0;

		try {
			if (CommonUtil.isBlank(periodYear) && CommonUtil.isBlank(quarterCode)) {
				result = sysFinancialPeriodDao.deleteWithKeys(keyIds);
			} else {
				result = sysFinancialPeriodDao.deleteWithKey(periodYear, quarterCode);
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
}