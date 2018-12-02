/**************************************************************************************************
 * project
 * Description - Sba0204 - User Management
 *	- Generated by Source Generator
 *************************************************************************************************/
package project.app.sba.sba0204;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;

import project.common.extend.BaseBiz;
import project.common.module.datahelper.DataHelper;
import project.conf.resource.ormapper.dao.SysAuthGroup.SysAuthGroupDao;
import project.conf.resource.ormapper.dao.SysUser.SysUserDao;
import project.conf.resource.ormapper.dto.oracle.SysUser;
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

public class Sba0204BizImpl extends BaseBiz implements Sba0204Biz {
	@Autowired
	private SysUserDao sysUserDao;
	@Autowired
	private SysAuthGroupDao sysAuthGroupDao;

	public ParamEntity getDefault(ParamEntity paramEntity) throws Exception {
		try {
			setAuthorityGroup(paramEntity);
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
		String langCode = (String)session.getAttribute("langCode");

		try {
			queryAdvisor.setObject("langCode", langCode);
			queryAdvisor.setRequestDataSet(requestDataSet);
			queryAdvisor.setPagination(true);

			setAuthorityGroup(paramEntity);

			paramEntity.setAjaxResponseDataSet(sysUserDao.getUserDataSetBySearchCriteria(queryAdvisor));
			paramEntity.setTotalResultRows(queryAdvisor.getTotalResultRows());
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getDetail(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		String userId = requestDataSet.getValue("userId");
		SysUser sysUser = new SysUser();

		try {
			sysUser = sysUserDao.getUserByUserId(userId);
			sysUser.setInsertUserName(DataHelper.getUserNameById(sysUser.getInsertUserId()));
			sysUser.setUpdateUserName(DataHelper.getUserNameById(sysUser.getUpdateUserId()));

			paramEntity.setObject("sysUser", sysUser);
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getInsert(ParamEntity paramEntity) throws Exception {
		String[] maxRowPerPage = CommonUtil.split(ConfigUtil.getProperty("view.data.maxRowsPerPage"), ConfigUtil.getProperty("delimiter.data"));
		String[] pageNumPerPage = CommonUtil.split(ConfigUtil.getProperty("view.data.pageNumsPerPage"), ConfigUtil.getProperty("delimiter.data"));
		String photoPath = ConfigUtil.getProperty("path.image.photo")+"/"+"DefaultUser_128_Black.png";
		String defaultAuthGroup = "Z";

		try {
			setAuthorityGroup(paramEntity);

			paramEntity.setObject("maxRowPerPage", maxRowPerPage);
			paramEntity.setObject("pageNumPerPage", pageNumPerPage);
			paramEntity.setObject("photoPath", photoPath);
			paramEntity.setObject("defaultAuthGroup", defaultAuthGroup);
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getUpdate(ParamEntity paramEntity) throws Exception {
		String[] maxRowPerPage = CommonUtil.split(ConfigUtil.getProperty("view.data.maxRowsPerPage"), ConfigUtil.getProperty("delimiter.data"));
		String[] pageNumPerPage = CommonUtil.split(ConfigUtil.getProperty("view.data.pageNumsPerPage"), ConfigUtil.getProperty("delimiter.data"));
		String photoPath = ConfigUtil.getProperty("path.image.photo")+"/"+"DefaultUser_128_Black.png";
		String defaultAuthGroup = "Z";

		try {
			setAuthorityGroup(paramEntity);

			paramEntity = getDetail(paramEntity);
			paramEntity.setObject("maxRowPerPage", maxRowPerPage);
			paramEntity.setObject("pageNumPerPage", pageNumPerPage);
			paramEntity.setObject("photoPath", photoPath);
			paramEntity.setObject("defaultAuthGroup", defaultAuthGroup);
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity getActionContextMenu(ParamEntity paramEntity) throws Exception {
		try {
			setAuthorityGroup(paramEntity);
			paramEntity.setSuccess(true);
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}
		return paramEntity;
	}

	public ParamEntity exeInsert(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		DataSet fileDataSet = paramEntity.getRequestFileDataSet();
		HttpSession session = paramEntity.getSession();
		String defaultFileName = "DefaultUser_128_Black.png";
		String userId = CommonUtil.uid();
		String rootPath = (String)MemoryBean.get("applicationRealPath");
		String pathToSave = ConfigUtil.getProperty("path.image.photo");
		SysUser sysUser = new SysUser();
		int result = -1;

		try {
			sysUser.setUserId(userId);
			sysUser.setUserName(requestDataSet.getValue("userName"));
			sysUser.setLoginId(requestDataSet.getValue("loginId"));
			sysUser.setLoginPassword(requestDataSet.getValue("password"));
			sysUser.setOrgId(requestDataSet.getValue("orgId"));
			sysUser.setAuthGroupId(requestDataSet.getValue("authGroup"));
			sysUser.setLanguage(requestDataSet.getValue("language"));
			sysUser.setThemeType(requestDataSet.getValue("themeType"));
			sysUser.setUserType(requestDataSet.getValue("userType"));
			sysUser.setEmail(requestDataSet.getValue("email"));
			sysUser.setMaxRowPerPage(CommonUtil.toDouble(requestDataSet.getValue("maxRowsPerPage")));
			sysUser.setPageNumPerPage(CommonUtil.toDouble(requestDataSet.getValue("pageNumsPerPage")));
			sysUser.setUserStatus(requestDataSet.getValue("userStatus"));
			sysUser.setIsActive(requestDataSet.getValue("isActive"));
			sysUser.setInsertUserId((String)session.getAttribute("UserId"));
			sysUser.setInsertDate(CommonUtil.toDate(CommonUtil.getSysdate()));

			if (fileDataSet.getRowCnt() > 0) {
				String fileName = fileDataSet.getValue("NEW_NAME");
				String fullPath = "";

				fileName = userId + "_" + fileName;
				fullPath = rootPath + pathToSave + "/" + fileName;
				FileUtil.moveFile(fileDataSet, fullPath);

				sysUser.setPhotoPath(pathToSave + "/" + fileName);
			} else {
				sysUser.setPhotoPath(pathToSave + "/" + defaultFileName);
			}

			result = sysUserDao.insert(sysUser);
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

	public ParamEntity exeUpdate(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		DataSet fileDataSet = paramEntity.getRequestFileDataSet();
		HttpSession session = paramEntity.getSession();
		String userId = requestDataSet.getValue("userId");
		String rootPath = (String)MemoryBean.get("applicationRealPath");
		String pathToSave = ConfigUtil.getProperty("path.image.photo");
		SysUser sysUser = new SysUser();
		int result = -1;

		try {
			sysUser = sysUserDao.getUserByUserId(userId);

			sysUser.setUserName(requestDataSet.getValue("userName"));
			sysUser.setLoginId(requestDataSet.getValue("loginId"));
			sysUser.setOrgId(requestDataSet.getValue("orgId"));
			sysUser.setAuthGroupId(requestDataSet.getValue("authGroup"));
			sysUser.setLanguage(requestDataSet.getValue("language"));
			sysUser.setThemeType(requestDataSet.getValue("themeType"));
			sysUser.setUserType(requestDataSet.getValue("userType"));
			sysUser.setEmail(requestDataSet.getValue("email"));
			sysUser.setMaxRowPerPage(CommonUtil.toDouble(requestDataSet.getValue("maxRowsPerPage")));
			sysUser.setPageNumPerPage(CommonUtil.toDouble(requestDataSet.getValue("pageNumsPerPage")));
			sysUser.setUserStatus(requestDataSet.getValue("userStatus"));
			sysUser.setIsActive(requestDataSet.getValue("isActive"));
			sysUser.setUpdateUserId((String)session.getAttribute("UserId"));
			sysUser.setUpdateDate(CommonUtil.toDate(CommonUtil.getSysdate()));

			if (fileDataSet.getRowCnt() > 0) {
				String fileName = fileDataSet.getValue("NEW_NAME");
				String fullPath = "";

				fileName = userId + "_" + fileName;
				fullPath = rootPath + pathToSave + "/" + fileName;
				FileUtil.moveFile(fileDataSet, fullPath);

				sysUser.setPhotoPath(pathToSave + "/" + fileName);
			}

			sysUser.addUpdateColumnFromField();

			result = sysUserDao.update(userId, sysUser);
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
		String userId = requestDataSet.getValue("userId");
		String chkForDel = requestDataSet.getValue("chkForDel");
		String userIds[] = CommonUtil.splitWithTrim(chkForDel, ConfigUtil.getProperty("delimiter.record"));
		int result = -1;

		try {
			if (CommonUtil.isBlank(userId)) {
				result = sysUserDao.delete(userIds);
			} else {
				result = sysUserDao.delete(userId);
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

	public ParamEntity exeActionContextMenu(ParamEntity paramEntity) throws Exception {
		DataSet requestDataSet = paramEntity.getRequestDataSet();
		String mode = requestDataSet.getValue("mode");
		String chkForDel = requestDataSet.getValue("chkForDel");
		String userIds[] = CommonUtil.splitWithTrim(chkForDel, ConfigUtil.getProperty("delimiter.record"));
		SysUser sysUser = new SysUser();
		int result = 0;

		try {
			if (CommonUtil.equals(mode, "UpdateAuthGroup")) {
				sysUser.addUpdateColumn("auth_group_id", requestDataSet.getValue("authGroup"));
			} else if (CommonUtil.equals(mode, "UpdateUserType")) {
				sysUser.addUpdateColumn("user_type", requestDataSet.getValue("userType"));
			} else if (CommonUtil.equals(mode, "UpdateUserStatus")) {
				sysUser.addUpdateColumn("user_status", requestDataSet.getValue("userStatus"));
			} else if (CommonUtil.equals(mode, "UpdateActiveStatus")) {
				sysUser.addUpdateColumn("is_active", requestDataSet.getValue("activeStatus"));
			}

			sysUser.addUpdateColumn("update_date", CommonUtil.getSysdate(), "date");

			result = sysUserDao.updateByUserIds(userIds, sysUser);
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
		HttpSession session = paramEntity.getSession();
		String langCode = (String)session.getAttribute("langCode");

		try {
			String pageTitle = "User List";
			String fileName = "UserList";
			String[] columnHeader = {"user_id", "user_name", "login_id", "org_id", "auth_group_name", "user_type", "user_status", "email", "is_active", "update_date"};

			exportHelper = ExportUtil.getExportHelper(requestDataSet.getValue("fileType"));
			exportHelper.setPageTitle(pageTitle);
			exportHelper.setColumnHeader(columnHeader);
			exportHelper.setFileName(fileName);
			exportHelper.setPdfWidth(2000);

			queryAdvisor.setObject("langCode", langCode);
			queryAdvisor.setRequestDataSet(requestDataSet);
			if (CommonUtil.containsIgnoreCase(dataRange, "all"))
				queryAdvisor.setPagination(false);
			else {
				queryAdvisor.setPagination(true);
			}

			exportHelper.setSourceDataSet(sysUserDao.getUserDataSetBySearchCriteria(queryAdvisor));

			paramEntity.setSuccess(true);
			paramEntity.setFileToExport(exportHelper.createFile());
			paramEntity.setFileNameToExport(exportHelper.getFileName());
		} catch (Exception ex) {
			throw new FrameworkException(paramEntity, ex);
		}

		return paramEntity;
	}

	private void setAuthorityGroup(ParamEntity paramEntity) throws Exception {
		QueryAdvisor qaAuth = paramEntity.getQueryAdvisor();
		qaAuth.addOrderByClause("group_id");
		paramEntity.setObject("authGroupDataSet", sysAuthGroupDao.getAllAuthGroupDataSet(qaAuth));
	}
}