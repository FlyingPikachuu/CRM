package com.qsy.workbench.service;

import com.qsy.workbench.pojo.ContactActivityRelation;

import java.util.List;

/**
 * @author qsy
 * @create 2022/5/9 - 10:46
 */
public interface ContactActivityRelationService {

    //批量添加，将与线索管理的市场活动添加联系人市场活动表中
    int addContactActivityRelation(List<ContactActivityRelation> carList);

    //解除关联关系,根据ContactId和activityId删除线索和市场活动的关联关系
    int deleteContactActivityRelationByActivityIdContactId(ContactActivityRelation contactActivityRelation);
}
