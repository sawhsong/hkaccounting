/**************************************************************************************************
 * project
 * Description - Rpt0202 - 
 *	- Generated by Source Generator
 *************************************************************************************************/
package project.app.rpt.rpt0202;

import org.springframework.beans.factory.annotation.Autowired;

import project.common.extend.BaseAction;

public class Rpt0202Action extends BaseAction {
	@Autowired
	private Rpt0202Biz biz;

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

	public String getDetail() throws Exception {
		biz.getDetail(paramEntity);
		return "detail";
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