package zebra.taglib;

import javax.servlet.jsp.JspWriter;

import zebra.base.TaglibSupport;
import zebra.util.CommonUtil;

public class Checkbox extends TaglibSupport {
	private String name;
	private String value;
	private String text;
	private String id;
	private String isChecked;
	private String isDisabled;
	private String script;
	private String labelClassName;
	private String inputClassName;
	private String labelStyle;
	private String inputStyle;
	private String displayType;	// inline / block
	private String isBootstrap;
	private String status;
	private String options;	// for data validator

	public int doStartTag() {
		try {
			JspWriter jspWriter = pageContext.getOut();
			StringBuffer html = new StringBuffer();
			String disabledString = "", classSuffix = "";

			if (CommonUtil.equalsIgnoreCase(isBootstrap, "true") || CommonUtil.equalsIgnoreCase(isBootstrap, "yes")) {
				if (CommonUtil.equalsIgnoreCase(isDisabled, "true") || CommonUtil.equalsIgnoreCase(isDisabled, "yes") || CommonUtil.equalsIgnoreCase(status, "disabled")) {
					disabledString = " disabled";
				}

				if (CommonUtil.equalsIgnoreCase(displayType, "block")) {
					html.append("<div class=\"checkbox"+disabledString+"\"><label");

					if (CommonUtil.isNotBlank(labelClassName)) {html.append(" class=\""+labelClassName+"\"");}
					if (CommonUtil.isNotBlank(labelStyle)) {html.append(" style=\""+labelStyle+"\"");}
					html.append("><input type=\"checkbox\" name=\""+name+"\" value=\""+value+"\"");
					if (CommonUtil.isNotBlank(id)) {html.append(" id=\""+id+"\"");}
					if (CommonUtil.isNotBlank(disabledString)) {html.append(" "+disabledString);}
					if (CommonUtil.isNotBlank(inputClassName)) {html.append(" class=\""+inputClassName+"\"");}
					if (CommonUtil.isNotBlank(inputStyle)) {html.append(" style=\""+inputStyle+"\"");}
					if (CommonUtil.equalsIgnoreCase(isChecked, "true") || CommonUtil.equalsIgnoreCase(isChecked, "yes")) {html.append(" checked");}
					if (CommonUtil.isNotBlank(options)) {html.append(" "+options);}
					if (CommonUtil.isNotBlank(script)) {html.append(" onclick=\""+script+"\"");}

					html.append("/>"+text+"</label></div>");
				} else {
					html.append("<label class=\"checkbox-inline"+disabledString);

					if (CommonUtil.isNotBlank(labelClassName)) {html.append(" "+labelClassName+"");}
					html.append("\"");
					if (CommonUtil.isNotBlank(labelStyle)) {html.append(" style=\""+labelStyle+"\"");}
					html.append("><input type=\"checkbox\" name=\""+name+"\" value=\""+value+"\"");
					if (CommonUtil.isNotBlank(id)) {html.append(" id=\""+id+"\"");}
					if (CommonUtil.isNotBlank(disabledString)) {html.append(" "+disabledString);}
					if (CommonUtil.isNotBlank(inputClassName)) {html.append(" class=\""+inputClassName+"\"");}
					if (CommonUtil.isNotBlank(inputStyle)) {html.append(" style=\""+inputStyle+"\"");}
					if (CommonUtil.equalsIgnoreCase(isChecked, "true") || CommonUtil.equalsIgnoreCase(isChecked, "yes")) {html.append(" checked");}
					if (CommonUtil.isNotBlank(options)) {html.append(" "+options);}
					if (CommonUtil.isNotBlank(script)) {html.append(" onclick=\""+script+"\"");}

					html.append("/>"+text+"</label>");
				}
			} else {
				if (CommonUtil.equalsIgnoreCase(isDisabled, "true") || CommonUtil.equalsIgnoreCase(isDisabled, "yes") || CommonUtil.equalsIgnoreCase(status, "disabled")) {
					classSuffix = "Dis";
					disabledString = " disabled";
				} else {
					classSuffix = "En";
				}

				if (CommonUtil.equalsIgnoreCase(displayType, "block")) {
					html.append("<label class=\"lblCheck"+classSuffix);

					html.append(" block");
					if (CommonUtil.isNotBlank(labelClassName)) {html.append(" "+labelClassName+"");}
					html.append("\"");
					if (CommonUtil.isNotBlank(labelStyle)) {html.append(" style=\""+labelStyle+"\"");}
					html.append("><input type=\"checkbox\" name=\""+name+"\" value=\""+value+"\" class=\"chk"+classSuffix);
					if (CommonUtil.isNotBlank(id)) {html.append(" id=\""+id+"\"");}
					if (CommonUtil.isNotBlank(inputClassName)) {html.append(" "+inputClassName+"");}
					html.append("\"");
					if (CommonUtil.isNotBlank(inputStyle)) {html.append(" style=\""+inputStyle+"\"");}
					if (CommonUtil.isNotBlank(disabledString)) {html.append(" "+disabledString);}
					if (CommonUtil.equalsIgnoreCase(isChecked, "true") || CommonUtil.equalsIgnoreCase(isChecked, "yes")) {html.append(" checked");}
					if (CommonUtil.isNotBlank(options)) {html.append(" "+options);}
					if (CommonUtil.isNotBlank(script)) {html.append(" onclick=\""+script+"\"");}

					html.append("/>"+text+"</label>");
				} else {
					html.append("<label class=\"lblCheck"+classSuffix);

					if (CommonUtil.isNotBlank(labelClassName)) {html.append(" "+labelClassName+"");}
					html.append("\"");
					if (CommonUtil.isNotBlank(labelStyle)) {html.append(" style=\""+labelStyle+"\"");}
					html.append("><input type=\"checkbox\" name=\""+name+"\" value=\""+value+"\" class=\"chk"+classSuffix);
					if (CommonUtil.isNotBlank(inputClassName)) {html.append(" "+inputClassName+"");}
					html.append("\"");
					if (CommonUtil.isNotBlank(inputStyle)) {html.append(" style=\""+inputStyle+"\"");}
					if (CommonUtil.isNotBlank(disabledString)) {html.append(" "+disabledString);}
					if (CommonUtil.equalsIgnoreCase(isChecked, "true") || CommonUtil.equalsIgnoreCase(isChecked, "yes")) {html.append(" checked");}
					if (CommonUtil.isNotBlank(options)) {html.append(" "+options);}
					if (CommonUtil.isNotBlank(script)) {html.append(" onclick=\""+script+"\"");}

					html.append("/>"+text+"</label>");
				}
			}

			jspWriter.print(html.toString());
		} catch (Exception ex) {
			logger.error(ex);
		}

		return SKIP_BODY;
	}
	/*!
	 * getter / setter
	 */
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getScript() {
		return script;
	}

	public void setScript(String script) {
		this.script = script;
	}

	public String getLabelClassName() {
		return labelClassName;
	}

	public void setLabelClassName(String labelClassName) {
		this.labelClassName = labelClassName;
	}

	public String getInputClassName() {
		return inputClassName;
	}

	public void setInputClassName(String inputClassName) {
		this.inputClassName = inputClassName;
	}

	public String getLabelStyle() {
		return labelStyle;
	}

	public void setLabelStyle(String labelStyle) {
		this.labelStyle = labelStyle;
	}

	public String getInputStyle() {
		return inputStyle;
	}

	public void setInputStyle(String inputStyle) {
		this.inputStyle = inputStyle;
	}

	public String getDisplayType() {
		return displayType;
	}

	public void setDisplayType(String displayType) {
		this.displayType = displayType;
	}

	public String getIsBootstrap() {
		return isBootstrap;
	}

	public void setIsBootstrap(String isBootstrap) {
		this.isBootstrap = isBootstrap;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getOptions() {
		return options;
	}

	public void setOptions(String options) {
		this.options = options;
	}

	public String getIsChecked() {
		return isChecked;
	}

	public void setIsChecked(String isChecked) {
		this.isChecked = isChecked;
	}

	public String getIsDisabled() {
		return isDisabled;
	}

	public void setIsDisabled(String isDisabled) {
		this.isDisabled = isDisabled;
	}
}