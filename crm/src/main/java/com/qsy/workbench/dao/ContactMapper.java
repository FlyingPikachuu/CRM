package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.Contact;
import com.qsy.workbench.pojo.Customer;
import com.qsy.workbench.pojo.FunnelVO;
import com.qsy.workbench.pojo.LBVO;

import java.util.List;
import java.util.Map;

public interface ContactMapper {
    int deleteByPrimaryKey(String id);

    int insert(Contact row);

    int insertSelective(Contact row);

    Contact selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Contact row);

    int updateByPrimaryKey(Contact row);

    //添加一条联系人记录
    int insertContact(Contact contact);

    //创建交易时查询联系人
    List<Contact> selectContactForSaveTran(String name);

    //根据条件分页查询联系人
    List<Contact> selectContactByConditionForPage(Map<String,Object> map);
    //根据条件分页查询联系人总条数
    int selectCountOfContactByCondition(Map<String,Object> map);
    //根据id查询联系人信息显示到修改模态窗口
    Contact selectContactById(String id);
    //根据id修改指定联系人
    int updateContactById(Contact contact);
    //根据ids批量删除联系人
    int deleteContactByIds(String[] ids);

    //查询联系人明细
    Contact selectContactByIdForDetail(String id);

    //根据customerId查询联系人
    List<Contact> selectContactByCustomerId(String customerId);

    //根据customerId删除联系人
    int deleteContactByCustomerId(String[] customerId);


    //根据联系人来源查询线索数量 piechart
    List<FunnelVO> selectCountOfContactBySource();
    //查询当月职员创建联系人TOP10
    List<LBVO> selectCountOfContactByOwnerAndCreate();
}