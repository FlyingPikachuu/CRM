package com.qsy.workbench.controller;

import com.qsy.settings.pojo.DicValue;
import com.qsy.settings.pojo.User;
import com.qsy.settings.service.DicValueService;
import com.qsy.settings.service.UserService;
import com.qsy.utils.Constants;
import com.qsy.utils.ReturnInfoObject;
import com.qsy.workbench.pojo.*;
import com.qsy.workbench.service.*;
import org.junit.validator.PublicClassValidator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

/**
 * @author qsy
 * @create 2022/4/25 - 9:54
 */
@Controller
public class TransactionController {
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactService contactService;
    @Autowired
    private TransactionHistoryService transactionHistoryService;
    @Autowired
    private TransactionRemarkService transactionRemarkService;
    @RequestMapping("/workbench/transaction/index.do")
    public String index(Model model){
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> typeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");

        model.addAttribute("stageList",stageList);
        model.addAttribute("typeList",typeList);
        model.addAttribute("sourceList",sourceList);
        return "/workbench/transaction/index";
    }
    @RequestMapping("/workbench/transaction/queryTransactionByConditionForPage.do")
    @ResponseBody
    public Object queryTransactionByConditionForPage(String owner,String name,String customer,String stage,String type,String source,
                                                     String contact,int pageNo,int pageSize){
        System.out.println("=================="+pageNo+pageSize);
        Map<String, Object> map = new HashMap<>();
        map.put("owner",owner);
        map.put("name",name);
        map.put("customer",customer);
        map.put("stage",stage);
        map.put("type",type);
        map.put("source",source);
        map.put("contact",contact);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        System.out.println("+++++++++++++"+map);
        List<Transaction> tList = transactionService.queryTransactionByConditionForPage(map);
        System.out.println("++++++++++++"+tList);
        int totalRows = transactionService.queryCountOfTransactionByCondition(map);
        System.out.println("++++++++++++"+totalRows);


        Map<String, Object> ret = new HashMap<>();
        ret.put("tList",tList);
        ret.put("totalRows",totalRows);
        System.out.println("==============================================");
        System.out.println(ret);

        return  ret;
    }
    @RequestMapping("/workbench/transaction/toSave.do")
    public String toSave(Model model){
        List<User> userList = userService.queryAllUser();
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> typeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");

        model.addAttribute("userList",userList);
        model.addAttribute("stageList",stageList);
        model.addAttribute("typeList",typeList);
        model.addAttribute("sourceList",sourceList);

        return "/workbench/transaction/save";
    }

    @RequestMapping("/workbench/transaction/getPossibilityByStage.do")
    @ResponseBody
    public Object getPossibilityByStage(String stageValue){
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(stageValue);

        return possibility;
    }

    @RequestMapping("/workbench/transaction/queryCustomerNameByName.do")
    @ResponseBody
    public Object queryCustomerNameByName(String customerName){
        List<String> customerNameList = customerService.queryCustomerNameByName(customerName);
        return customerNameList;
    }

    @RequestMapping("/workbench/transaction/queryActivity.do")
    @ResponseBody
    public Object queryActivity(String name){
        List<Activity> activityList = activityService.queryActivityForSaveTran(name);
        return activityList;
    }
    @RequestMapping("/workbench/transaction/queryContact.do")
    @ResponseBody
    public Object queryContact(String fullname){
        List<Contact> contactList = contactService.queryContactForSaveTran(fullname);
        return contactList;
    }


    @RequestMapping("/workbench/transaction/saveTransaction.do")
    @ResponseBody
    public Object saveTransaction(@RequestParam Map<String,Object> map, HttpSession session){
        map.put(Constants.SESSION_USER,session.getAttribute(Constants.SESSION_USER));
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            transactionService.saveTransaction(map);
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return  returnInfoObject;
    }
    @RequestMapping("/workbench/transaction/queryTransactionForDetailById.do/{id}")
    public String queryTransactionForDetailById(@PathVariable String id,Model model){
        Transaction ts = transactionService.queryTransactionForDetailById(id);
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        String possibility = bundle.getString(ts.getStage());
        ts.setPossibility(possibility);
        List<TransactionRemark> trList = transactionRemarkService.queryTransactionRemarkForDetailByTranId(id);
        List<TransactionHistory> thList = transactionHistoryService.queryTransactionHistoryForDetailByTranId(id);
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");

        model.addAttribute("ts",ts);
        model.addAttribute("trList",trList);
        model.addAttribute("thList",thList);
        model.addAttribute("stageList",stageList);
        return "/workbench/transaction/detail";
    }

    @RequestMapping("/workbench/transaction/toEdit.do/{id}")
    public String toEdit(@PathVariable String id,Model model){
        List<User> userList = userService.queryAllUser();
        Transaction tran = transactionService.queryTranById(id);
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        DicValue dicValue = dicValueService.queryDicValueById(tran.getStage());
        String possibility = bundle.getString(dicValue.getValue());
        tran.setPossibility(possibility);
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> typeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");

        model.addAttribute("userList",userList);
        model.addAttribute("stageList",stageList);
        model.addAttribute("typeList",typeList);
        model.addAttribute("sourceList",sourceList);
        model.addAttribute("tran",tran);
        return "/workbench/transaction/edit";
    }

    @RequestMapping("/workbench/transaction/editTran.do")
    @ResponseBody
    public Object editTran(@RequestParam Map<String,Object> map,HttpSession session){
        map.put(Constants.SESSION_USER,session.getAttribute(Constants.SESSION_USER));
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            transactionService.editTransaction(map);
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return returnInfoObject;
    }
    @RequestMapping("/workbench/transaction/deleteTranByIds.do")
    @ResponseBody
    public Object deleteTranByIds(String[] ids) {
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
                transactionService.deleteTranByIds(ids);
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return returnInfoObject;
    }

    //点击交易阶段图表修改交易阶段，添加交易历史
    @RequestMapping("/workbench/transaction/editTranStage.do")
    @ResponseBody
    public Object editTranStage(@RequestParam Map<String,Object> map,HttpSession session){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        map.put(Constants.SESSION_USER,session.getAttribute(Constants.SESSION_USER));
        try {
            transactionService.editTranStage(map);
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return  returnInfoObject;
    }
}
