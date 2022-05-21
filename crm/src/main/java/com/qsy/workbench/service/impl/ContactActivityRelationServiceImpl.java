package com.qsy.workbench.service.impl;

import com.qsy.workbench.dao.ContactActivityRelationMapper;
import com.qsy.workbench.pojo.ContactActivityRelation;
import com.qsy.workbench.service.ContactActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author qsy
 * @create 2022/5/9 - 10:46
 */
@Service
public class ContactActivityRelationServiceImpl implements ContactActivityRelationService {
    @Autowired
    private ContactActivityRelationMapper contactActivityRelationMapper;
    @Override
    public int addContactActivityRelation(List<ContactActivityRelation> carList) {
        return contactActivityRelationMapper.insertContactActivityRelation(carList);
    }

    @Override
    public int deleteContactActivityRelationByActivityIdContactId(ContactActivityRelation contactActivityRelation) {
        return contactActivityRelationMapper.deleteContactActivityRelationByActivityIdContactId(contactActivityRelation);
    }
}
