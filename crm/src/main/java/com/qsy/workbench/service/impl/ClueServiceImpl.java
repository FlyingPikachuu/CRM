package com.qsy.workbench.service.impl;

import com.qsy.settings.pojo.User;
import com.qsy.utils.Constants;
import com.qsy.utils.DateUtils;
import com.qsy.utils.IDUtils;
import com.qsy.workbench.dao.*;
import com.qsy.workbench.pojo.*;
import com.qsy.workbench.service.CLueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/4/14 - 9:38
 */
@Service
public class ClueServiceImpl implements CLueService {

    @Autowired
    private ClueMapper clueMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Autowired
    private ContactMapper contactMapper;

    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Autowired
    private ContactRemarkMapper contactRemarkMapper;

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Autowired
    private ContactActivityRelationMapper contactActivityRelationMapper;

    @Autowired
    private TransactionMapper transactionMapper;
    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;

    @Override
    public int addClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryClueForPageByCondition(Map<String, Object> map) {
        return clueMapper.selectClueForPageByCondition(map);
    }

    @Override
    public int queryCountOfClueByCondition(Map<String, Object> map) {
        return clueMapper.selectCountOfClueByCondition(map);
    }

    @Override
    public Clue queryClueForDetailById(String id) {
        return clueMapper.selectClueForDetailById(id);
    }

    @Override
    public void saveConvertClue(Map<String, Object> map) {
        String clueId=(String) map.get("clueId");
        User user=(User)map.get(Constants.SESSION_USER);
        Clue clue = clueMapper.selectClueForConvertById(clueId);
        Customer c = new Customer();
        c.setId(IDUtils.getId());
        c.setCreateTime(DateUtils.formatDateTime(new Date()));
        c.setCreateBy(user.getId());
        c.setAddress(clue.getAddress());
        c.setContactSummary(clue.getContactSummary());
        c.setDescription(clue.getDescription());
        c.setName(clue.getCompany());
        c.setNextContactTime(clue.getNextContactTime());
        c.setPhone(clue.getPhone());
        c.setWebsite(clue.getWebsite());
        c.setOwner(user.getId());
        //添加一条客户记录
        customerMapper.insertCustomer(c);

        Contact ct = new Contact();
        ct.setId(IDUtils.getId());
        ct.setAddress(clue.getAddress());
        ct.setCreateBy(user.getId());
        ct.setCreateTime(DateUtils.formatDateTime(new Date()));
        ct.setContactSummary(clue.getContactSummary());
        ct.setDescription(clue.getDescription());
        ct.setAppellation(clue.getAppellation());
        ct.setCustomerId(c.getId());
        ct.setFullname(clue.getFullname());
        ct.setEmail(clue.getEmail());
        ct.setMphone(clue.getMphone());
        ct.setJob(clue.getJob());
        ct.setOwner(user.getId());
        ct.setSource(clue.getSource());
        ct.setNextContactTime(clue.getNextContactTime());
        //添加一条联系人记录
        contactMapper.insertContact(ct);

        List<ClueRemark> crList = clueRemarkMapper.selectClueRemarkForConvertByClueId(clueId);

        if(crList!=null&&crList.size()>0){
            ArrayList<CustomerRemark> curList = new ArrayList<>();
            List<ContactRemark> corList=new ArrayList<>();
            CustomerRemark cur=null;
            ContactRemark cor=null;
            for (ClueRemark cr : crList) {
                cur=new CustomerRemark();
                cur.setId(IDUtils.getId());
                cur.setCreateBy(cr.getCreateBy());
                cur.setCreateTime(cr.getCreateTime());
                cur.setCustomerId(c.getId());
                cur.setEditBy(cr.getEditBy());
                cur.setEditFlag(cr.getEditFlag());
                cur.setEditTime(cr.getEditTime());
                cur.setNoteContent(cr.getNoteContent());
                curList.add(cur);

                cor=new ContactRemark();
                cor.setId(IDUtils.getId());
                cor.setCreateBy(cr.getCreateBy());
                cor.setCreateTime(cr.getCreateTime());
                cor.setContactId(ct.getId());
                cor.setEditBy(cr.getEditBy());
                cor.setEditFlag(cr.getEditFlag());
                cor.setEditTime(cr.getEditTime());
                cor.setNoteContent(cr.getNoteContent());
                corList.add(cor);
            }
            //转换线索备注信息到客户备注表
            customerRemarkMapper.insertCustomerRemark(curList);
            //转换线索备注信息到联系人备注表
            contactRemarkMapper.insertContactRemark(corList);
        }
        //根据ClueId查找线索活动关联记录
        List<ClueActivityRelation> carList = clueActivityRelationMapper.selectClueActivityRelationByClueId(clueId);
        if(carList!=null&&carList.size()>0){
            List<ContactActivityRelation> coarList = new ArrayList<>();
            ContactActivityRelation coar=null;
            for (ClueActivityRelation car : carList) {
                coar = new ContactActivityRelation();
                coar.setId(IDUtils.getId());
                coar.setContactId(ct.getId());
                coar.setActivityId(coar.getActivityId());
                coarList.add(coar);
            }
            contactActivityRelationMapper.insertContactActivityRelation(coarList);
        }

        //如果创建交易，从前台获取数据
        String isCreateTran = (String)map.get("isCreateTran");

        if("true".equals(isCreateTran)){
            Transaction ts = new Transaction();
            ts.setId(IDUtils.getId());
            ts.setMoney((String) map.get("money"));
            ts.setStage((String) map.get("stage"));
            ts.setActivityId((String) map.get("activityId"));
            ts.setContactId(ct.getId());
            ts.setCustomerId(c.getId());
            ts.setExpectedDate((String) map.get("expectDate"));
            ts.setName((String) map.get("tradeName"));
            transactionMapper.insertTransaction(ts);

            if(crList!=null&&crList.size()>0){
                List<TransactionRemark> trList = new ArrayList<>();
                TransactionRemark tr= null;
                for (ClueRemark cr : crList) {
                    tr = new TransactionRemark();
                    tr.setId(IDUtils.getId());
                    tr.setCreateBy(cr.getCreateBy());
                    tr.setCreateTime(cr.getCreateTime());
                    tr.setEditBy(cr.getEditBy());
                    tr.setNoteContent(cr.getNoteContent());
                    tr.setTranId(ts.getId());
                    tr.setEditFlag(cr.getEditFlag());
                    trList.add(tr);
                }
                //添加交易备注
                transactionRemarkMapper.insertTransactionRemark(trList);
            }
        }

        //删除当前线索下的所有备注
        clueRemarkMapper.deleteClueRemarkByClueId(clueId);
        //删除当前线索关联与市场活动关联关系
        clueActivityRelationMapper.deleteClueActivityRelationByClueId(clueId);
        //删除当前线索
        clueMapper.deleteClue(clue.getId());



    }
}
