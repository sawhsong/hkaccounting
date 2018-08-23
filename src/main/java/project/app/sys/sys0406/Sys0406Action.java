package project.app.sys.sys0406;

import org.springframework.beans.factory.annotation.Autowired;

import project.common.extend.BaseAction;
import project.common.module.menu.MenuManager;

public class Sys0406Action extends BaseAction {
	@Autowired
	private Sys0406Biz biz;

	public String getDefault() throws Exception {
		biz.getDefault(paramEntity);
		return "list";
	}

	public String getList() throws Exception {
		biz.getList(paramEntity);
		return "list";
	}

	public String exeInsert() throws Exception {
		try {
			biz.exeInsert(paramEntity);
			MenuManager.reload();
		} catch (Exception ex) {
		}
		setRequestAttribute("paramEntity", paramEntity);
		return "ajaxResponse";
	}
}