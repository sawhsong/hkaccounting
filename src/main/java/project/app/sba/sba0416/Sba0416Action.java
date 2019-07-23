/**************************************************************************************************
 * project
 * Description - Sba0416 - Tax Table Mgmt.
 *	- Generated by Source Generator
 *************************************************************************************************/
package project.app.sba.sba0416;

import org.springframework.beans.factory.annotation.Autowired;

import project.common.extend.BaseAction;

public class Sba0416Action extends BaseAction {
	@Autowired
	private Sba0416Biz biz;

	public String getDefault() throws Exception {
		biz.getDefault(paramEntity);
		return "list";
	}

	public String getList() throws Exception {
		try {
			biz.getList(paramEntity);
		} catch (Exception ex) {
		}
		setRequestAttribute("paramEntity", paramEntity);
		return "ajaxResponse";
	}

	public String getUpload() throws Exception {
		biz.getUpload(paramEntity);
		return "upload";
	}

	public String getInsert() throws Exception {
		biz.getInsert(paramEntity);
		return "insert";
	}

	public String getUpdate() throws Exception {
		biz.getUpdate(paramEntity);
		return "update";
	}

	public String exeInsert() throws Exception {
		try {
			biz.exeInsert(paramEntity);
		} catch (Exception ex) {
		}
		setRequestAttribute("paramEntity", paramEntity);
		return "ajaxResponse";
	}

	public String exeUpdate() throws Exception {
		try {
			biz.exeUpdate(paramEntity);
		} catch (Exception ex) {
		}
		setRequestAttribute("paramEntity", paramEntity);
		return "ajaxResponse";
	}

	public String exeDelete() throws Exception {
		try {
			biz.exeDelete(paramEntity);
		} catch (Exception ex) {
		}
		setRequestAttribute("paramEntity", paramEntity);
		return "ajaxResponse";
	}

	public String exeExport() throws Exception {
		biz.exeExport(paramEntity);
		setRequestAttribute("paramEntity", paramEntity);
		return "export";
	}
}