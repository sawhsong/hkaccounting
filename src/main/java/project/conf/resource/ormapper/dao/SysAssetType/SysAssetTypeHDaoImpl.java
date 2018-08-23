/**************************************************************************************************
 * Framework Generated HDAOImpl Source
 * - SYS_ASSET_TYPE - Asset Entry Type
 *************************************************************************************************/
package project.conf.resource.ormapper.dao.SysAssetType;

import project.common.extend.BaseHDao;
import project.conf.resource.ormapper.dto.oracle.SysAssetType;
import zebra.data.DataSet;
import zebra.data.QueryAdvisor;
import zebra.util.ConfigUtil;

public class SysAssetTypeHDaoImpl extends BaseHDao implements SysAssetTypeDao {
	public DataSet getAssetTypeDataSetByCriteria(QueryAdvisor queryAdvisor) throws Exception {
		DataSet requestDataSet = queryAdvisor.getRequestDataSet();
		String orgCategory = requestDataSet.getValue("orgCategory");
		String dateFormat = ConfigUtil.getProperty("format.date.java");
		String langCode = (String)queryAdvisor.getObject("langCode");

		queryAdvisor.addWhereClause("asset_type.org_category(+) = '"+orgCategory+"'");
		queryAdvisor.addVariable("dateFormat", dateFormat);
		queryAdvisor.addVariable("langCode", langCode);
		queryAdvisor.addOrderByClause("com_code.sort_order");

		return selectAsDataSet(queryAdvisor, "query.SysAssetType.getAssetTypeDataSetByCriteria");
	}

	public DataSet getAssetTypeDataSetByOrgCategory(String orgCategory) throws Exception {
		QueryAdvisor queryAdvisor = new QueryAdvisor();

		queryAdvisor.addWhereClause("org_category = '"+orgCategory+"'");
		queryAdvisor.addWhereClause("parent_asset_type is null");
		queryAdvisor.addOrderByClause("sort_order");

		return selectAllAsDataSet(queryAdvisor, new SysAssetType());
	}
}