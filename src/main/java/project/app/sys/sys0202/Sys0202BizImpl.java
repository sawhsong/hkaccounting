package project.app.sys.sys0202;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;

import project.common.extend.BaseBiz;
import project.common.module.commoncode.CommonCodeManager;
import project.conf.resource.ormapper.dao.SysCommonCode.SysCommonCodeDao;
import project.conf.resource.ormapper.dto.oracle.SysCommonCode;
import zebra.data.DataSet;
import zebra.data.ParamEntity;
import zebra.data.QueryAdvisor;
import zebra.exception.FrameworkException;
import zebra.export.ExportHelper;
import zebra.util.CommonUtil;
import zebra.util.ConfigUtil;
import zebra.util.ExportUtil;

public class Sys0202BizImpl extends BaseBiz implements Sys0202Biz {
	@Autowired
	private SysCommonCodeDao sysCommonCodeDao;

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
		String codeCategory = requestDataSet.getValue("codeCategory");

		try {
			queryAdvisor.setPagination(true);
			queryAdvisor.addAutoFillCriteria(codeCategory, "code_category = '"+codeCategory+"'");

			paramEntity.setObject("codeTypeDataSet", sysCommonCodeDao.getActiveCodeTypeDataSet());
			paramEntity.setAjaxResponseDataSet(sysCommonCodeDao.getActiveCommonCodeDataSet(queryAdvisor));
			paramEntity.setTotalResultRows(queryAdvisor.getTotalResultRows());
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getDetail(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();

		try {
			paramEntity.setObject("resultDataSet", sysCommonCodeDao.getCommonCodeDataSetByCodeType(requestDataSet.getValue("codeType")));
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getInsert(ParamEntity paramEntity) throws Exception {
		try {
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getUpdate(ParamEntity paramEntity) throws Exception {
		try {
			paramEntity = getDetail(paramEntity);
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity exeInsert(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		HttpSession session = paramEntity.getSession();
		String delimiter = ConfigUtil.getProperty("delimiter.data");
		String codeType = CommonUtil.upperCase(requestDataSet.getValue("codeTypeMaster"));
		String processFrom = (String)paramEntity.getObject("processFrom");
		DataSet detailDataSet;
		int detailLength = CommonUtil.toInt(requestDataSet.getValue("detailLength"));
		int result = -1, masterDataRow = -1;
		SysCommonCode sysCommonCode = new SysCommonCode();

		try {
			sysCommonCode.setCodeType(codeType);
			sysCommonCode.setCommonCode("0000000000");
			sysCommonCode.setDescriptionEn(requestDataSet.getValue("descriptionEnMaster"));
			sysCommonCode.setDescriptionKo(requestDataSet.getValue("descriptionKoMaster"));
			sysCommonCode.setProgramConstants(codeType + "_0000000000");
			sysCommonCode.setSortOrder("000");
			sysCommonCode.setIsActive(CommonUtil.nvl(requestDataSet.getValue("isActiveMaster"), "N"));
			sysCommonCode.setIsDefault(CommonCodeManager.getCodeByConstants("SIMPLE_YN_N"));
			sysCommonCode.setInsertUserId((String)session.getAttribute("UserId"));
			if (CommonUtil.equalsIgnoreCase(processFrom, "update")) {
				detailDataSet = (DataSet)paramEntity.getObject("detailDataSet");
				masterDataRow = (int)paramEntity.getObject("masterDataRow");

				sysCommonCode.setIsDefault(detailDataSet.getValue(masterDataRow, "IS_DEFAULT"));
				sysCommonCode.setInsertUserId(detailDataSet.getValue(masterDataRow, "INSERT_USER_ID"));
				sysCommonCode.setInsertDate(CommonUtil.toDate(detailDataSet.getValue(masterDataRow, "INSERT_DATE")));
				sysCommonCode.setUpdateUserId((String)session.getAttribute("UserId"));
				sysCommonCode.setUpdateDate(CommonUtil.toDate(CommonUtil.getSysdate()));
			}

			result = sysCommonCodeDao.insert(sysCommonCode);
			if (result <= 0) {
				throw new FrameworkException("E801", getMessage("E801", paramEntity));
			}

			result = 0;
			for (int i=0; i<detailLength; i++) {
				String commonCode = requestDataSet.getValue("commonCodeDetail" + delimiter + i);

				sysCommonCode.setCommonCode(commonCode);
				sysCommonCode.setDescriptionEn(requestDataSet.getValue("descriptionEnDetail" + delimiter + i));
				sysCommonCode.setDescriptionKo(requestDataSet.getValue("descriptionKoDetail" + delimiter + i));
				sysCommonCode.setProgramConstants(codeType + "_" + CommonUtil.upperCase(commonCode));
				sysCommonCode.setSortOrder(requestDataSet.getValue("sortOrderDetail" + delimiter + i));
				sysCommonCode.setIsActive(CommonUtil.nvl(requestDataSet.getValue("isActiveDetail" + delimiter + i), "N"));

				result += sysCommonCodeDao.insert(sysCommonCode);
			}

			if (result != detailLength) {
				throw new FrameworkException("E801", getMessage("E801", paramEntity));
			}

			paramEntity.setSuccess(true);
			paramEntity.setMessage("I801", getMessage("I801"));
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}

		return paramEntity;
	}

	public ParamEntity exeUpdate(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		String codeType = CommonUtil.upperCase(requestDataSet.getValue("codeTypeMaster"));
		DataSet detailDataSet;
		int result = -1;
		int masterDataRow = -1;

		try {
			detailDataSet = sysCommonCodeDao.getCommonCodeDataSetByCodeType(codeType);
			masterDataRow = detailDataSet.getRowIndex("COMMON_CODE", "0000000000");

			result = sysCommonCodeDao.delete(codeType);
			if (result <= 0) {
				throw new FrameworkException("E801", getMessage("E801", paramEntity));
			}

			paramEntity.setObject("processFrom", "update");
			paramEntity.setObject("masterDataRow", masterDataRow);
			paramEntity.setObject("detailDataSet", detailDataSet);
			paramEntity = exeInsert(paramEntity);

			paramEntity.setSuccess(true);
			paramEntity.setMessage("I801", getMessage("I801", paramEntity));
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		
		return paramEntity;
	}

	public ParamEntity exeDelete(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		String codeType = requestDataSet.getValue("codeType");
		String chkForDel = requestDataSet.getValue("chkForDel");
		String[] codeTypes = CommonUtil.splitWithTrim(chkForDel, ConfigUtil.getProperty("delimiter.record"));
		int result = -1;

		try {
			if (CommonUtil.isBlank(codeType)) {
				result = sysCommonCodeDao.delete(codeTypes);
			} else {
				result = sysCommonCodeDao.delete(codeType);
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
		String dataRange = requestDataSet.getValue("dataRange");
		String codeType = requestDataSet.getValue("commonCodeType");

		try {
			String pageTitle = "Common Code List";
			String fileName = "CommonCodeList";
			String[] columnHeader = {"code_type", "common_code", "description_en", "program_constants"};

			exportHelper = ExportUtil.getExportHelper(requestDataSet.getValue("fileType"));
			exportHelper.setPageTitle(pageTitle);
			exportHelper.setColumnHeader(columnHeader);
			exportHelper.setFileName(fileName);
			exportHelper.setPdfWidth(1000);

			queryAdvisor.addAutoFillCriteria(codeType, "code_type = '"+codeType+"'");
			if (CommonUtil.containsIgnoreCase(dataRange, "all"))
				queryAdvisor.setPagination(false);
			else {
				queryAdvisor.setPagination(true);
			}

			exportHelper.setSourceDataSet(sysCommonCodeDao.getActiveCommonCodeDataSet(queryAdvisor));

			paramEntity.setSuccess(true);
			paramEntity.setFileToExport(exportHelper.createFile());
			paramEntity.setFileNameToExport(exportHelper.getFileName());
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}

		return paramEntity;
	}
}