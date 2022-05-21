package com.qsy.workbench.service;

import com.qsy.workbench.pojo.Contact;
import com.qsy.workbench.pojo.FunnelVO;
import com.qsy.workbench.pojo.LBVO;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/5/3 - 15:21
 */
public interface ContactService {
    List<Contact> queryContactForSaveTran(String fullname);

    //创建联系人
    void saveContact(Map<String,Object> map);

    //根据条件分页查询联系人
    List<Contact> queryContactByConditionForPage(Map<String,Object> map);
    //根据条件分页查询联系人总条数
    int queryCountOfContactByCondition(Map<String,Object> map);
    //根据id查询联系人信息显示到修改模态窗口
    Contact queryContactById(String id);

    void editContact(Map<String,Object> map);
    void deleteContact(String[] ids);

    Contact queryContactByIdForDetail(String id);

    List<Contact> queryContactByCustomerId(String customerId);

    //根据联系人来源查询线索数量 piechart
    List<FunnelVO> queryCountOfContactBySource();
    //查询当月职员创建联系人TOP10
    List<LBVO> queryCountOfContactByOwnerAndCreate();

}
