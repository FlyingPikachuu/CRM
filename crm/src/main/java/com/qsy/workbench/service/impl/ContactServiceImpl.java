package com.qsy.workbench.service.impl;

import com.qsy.settings.pojo.User;
import com.qsy.utils.Constants;
import com.qsy.utils.DateUtils;
import com.qsy.utils.IDUtils;
import com.qsy.workbench.dao.*;
import com.qsy.workbench.pojo.Contact;
import com.qsy.workbench.pojo.Customer;
import com.qsy.workbench.pojo.FunnelVO;
import com.qsy.workbench.pojo.LBVO;
import com.qsy.workbench.service.ContactService;
import org.springframework.beans.PropertyValue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/5/3 - 15:22
 */
@Service
public class ContactServiceImpl implements ContactService {
    @Autowired
    private ContactMapper contactMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactRemarkMapper contactRemarkMapper;
    @Autowired
    private TransactionMapper transactionMapper;
    @Autowired
    private ContactActivityRelationMapper contactActivityRelationMapper;
    @Override
    public List<Contact> queryContactForSaveTran(String fullname) {
        return contactMapper.selectContactForSaveTran(fullname);
    }

    @Override
    public void saveContact(Map<String, Object> map) {
        String customerName= (String)map.get("customerName");
        System.out.println("==============="+(customerName.equals("")));
        Customer customer = customerMapper.selectCustomerByName(customerName);
        System.out.println(customer);
        User user = (User)map.get(Constants.SESSION_USER);
        if((customerName!=null&&!customerName.trim().equals(""))&&customer==null){
            customer = new Customer();
            customer.setId(IDUtils.getId());
            customer.setOwner(user.getId());
            customer.setName(customerName);
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));
            customerMapper.insertCustomer(customer);
        }

        Contact cot = new Contact();
        cot.setId(IDUtils.getId());
        cot.setAppellation((String) map.get("appellation"));
        cot.setBirth((String) map.get("birth"));
        if(customer==null){
            cot.setCustomerId("");
        }else{
            cot.setCustomerId(customer.getId());
        }
        cot.setOwner((String) map.get("owner"));
        cot.setNextContactTime((String) map.get("nextContactTime"));
        cot.setSource((String) map.get("source"));
        cot.setDescription((String) map.get("description"));
        cot.setJob((String) map.get("job"));
        cot.setMphone((String) map.get("mphone"));
        cot.setContactSummary((String) map.get("contactSummary"));
        cot.setEmail((String) map.get("email"));
        cot.setFullname((String) map.get("fullname"));
        cot.setCreateTime(DateUtils.formatDateTime(new Date()));
        cot.setCreateBy(user.getId());
        cot.setAddress((String) map.get("address"));

        contactMapper.insertContact(cot);

    }

    @Override
    public List<Contact> queryContactByConditionForPage(Map<String, Object> map) {
        return contactMapper.selectContactByConditionForPage(map);
    }

    @Override
    public int queryCountOfContactByCondition(Map<String, Object> map) {
        return contactMapper.selectCountOfContactByCondition(map);
    }

    @Override
    public Contact queryContactById(String id) {
        return contactMapper.selectContactById(id);
    }

    @Override
    public void editContact(Map<String, Object> map) {
        String customerName= (String)map.get("customerName");
        Customer customer = customerMapper.selectCustomerByName(customerName);
        User user = (User)map.get(Constants.SESSION_USER);
        if((customerName!=null&&!customerName.trim().equals(""))&&customer==null){
            customer = new Customer();
            customer.setId(IDUtils.getId());
            customer.setOwner(user.getId());
            customer.setName(customerName);
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));
            customerMapper.insertCustomer(customer);
        }

        Contact cot = new Contact();
        cot.setId((String) map.get("id"));
        cot.setAppellation((String) map.get("appellation"));
        cot.setBirth((String) map.get("birth"));
        if(customer==null){
            cot.setCustomerId("");
        }else{
            cot.setCustomerId(customer.getId());
        }
        cot.setOwner((String) map.get("owner"));
        cot.setNextContactTime((String) map.get("nextContactTime"));
        cot.setSource((String) map.get("source"));
        cot.setDescription((String) map.get("description"));
        cot.setJob((String) map.get("job"));
        cot.setMphone((String) map.get("mphone"));
        cot.setContactSummary((String) map.get("contactSummary"));
        cot.setEmail((String) map.get("email"));
        cot.setFullname((String) map.get("fullname"));
        cot.setEditBy(user.getId());
        cot.setEditTime(DateUtils.formatDateTime(new Date()));
        cot.setAddress((String) map.get("address"));
        contactMapper.updateContactById(cot);

    }

    @Override
    public void deleteContact(String[] ids) {
        //删除备注信息
        contactRemarkMapper.deleteContactRemarkByContactId(ids);
        //修改交易信息
        transactionMapper.updateTransactionByContactId(ids);
        //删除关联信息
        contactActivityRelationMapper.deleteContactActivityRelationByContactId(ids);
        //删除联系人信息
        contactMapper.deleteContactByIds(ids);
    }

    @Override
    public Contact queryContactByIdForDetail(String id) {
        return  contactMapper.selectContactByIdForDetail(id);
    }

    @Override
    public List<Contact> queryContactByCustomerId(String customerId) {
        return contactMapper.selectContactByCustomerId(customerId);
    }

    @Override
    public List<FunnelVO> queryCountOfContactBySource() {
        return contactMapper.selectCountOfContactBySource();
    }

    @Override
    public List<LBVO> queryCountOfContactByOwnerAndCreate() {
        return contactMapper.selectCountOfContactByOwnerAndCreate();
    }


}
