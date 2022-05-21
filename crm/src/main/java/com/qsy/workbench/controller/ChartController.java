package com.qsy.workbench.controller;

import com.qsy.utils.ReturnInfoObject;
import com.qsy.workbench.pojo.FunnelVO;
import com.qsy.workbench.pojo.LBVO;
import com.qsy.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/5/4 - 16:19
 */
@Controller
public class ChartController {
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private ContactService contactService;
    @RequestMapping("/workbench/chart/activity/transactionChartIndex.do")
    public String activityChartIndex(){
        return "workbench/chart/activity/index";
    }
    @RequestMapping("/workbench/chart/activity/queryActivityGroupByOwner.do")
    @ResponseBody
    public Object queryActivityGroupByOwner(@RequestParam Map<String,Object> map){
        List<LBVO> funnelVOList = activityService.queryActivityGroupByOwner(map);
        List<String> name = new ArrayList<>();
        List<Integer> value= new ArrayList<>();
        for (LBVO lbvo : funnelVOList) {
            name.add(lbvo.getName());
            value.add(lbvo.getValue());
        }
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        returnInfoObject.setReturnData(name);
        returnInfoObject.setReturnData2(value);
        return  returnInfoObject;
    }
    @RequestMapping("/workbench/chart/activity/activityPieChart.do")
    @ResponseBody
    public Object activityPieChart(@RequestParam Map<String,Object> map){
        List<LBVO> lbvoList = activityService.queryActivityGroupByOwner(map);

        return  lbvoList;
    }

    @RequestMapping("/workbench/chart/activity/queryCountOfActivityInProgressGroupByOwner.do")
    @ResponseBody
    public Object queryCountOfActivityInProgressGroupByOwner(){
        List<LBVO> lbvoList = activityService.queryCountOfActivityInProgressGroupByOwner();
        List<String> name = new ArrayList<>();
        List<Integer> value= new ArrayList<>();
        for (LBVO lbvo : lbvoList) {
            name.add(lbvo.getName());
            value.add(lbvo.getValue());
        }
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        returnInfoObject.setReturnData(name);
        returnInfoObject.setReturnData2(value);
        return  returnInfoObject;
    }

    @RequestMapping("/workbench/chart/activity/queryCountOfActivityByCreateMonth.do")
    @ResponseBody
    public Object queryCountOfActivityByCreateMonth(){
        List<LBVO> lbvoList = activityService.queryCountOfActivityByCreateMonth();
        List<Integer> integerList = activityService.queryMaxOfCreateActivityInAYear();
        List<String> name = new ArrayList<>();
        List<Integer> value= new ArrayList<>();
        for (LBVO lbvo : lbvoList) {
            name.add(lbvo.getName()+"月");
            value.add(lbvo.getValue());
        }
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        returnInfoObject.setReturnData(name);
        returnInfoObject.setReturnData2(value);
        returnInfoObject.setReturnData3(integerList);
        return  returnInfoObject;
    }

    @RequestMapping("/workbench/chart/activity/queryCountOfActivityByOwnerAndCreate.do")
    @ResponseBody
    public Object queryCountOfActivityByOwnerAndCreate(){
        List<LBVO> lbvoList = activityService.queryCountOfActivityByOwnerAndCreate();
        List<String> name = new ArrayList<>();
        List<Integer> value= new ArrayList<>();
        for (LBVO lbvo : lbvoList) {
            name.add(lbvo.getName());
            value.add(lbvo.getValue());
        }
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        returnInfoObject.setReturnData(name);
        returnInfoObject.setReturnData2(value);
        return  returnInfoObject;
    }


    @RequestMapping("/workbench/chart/clue/clueChartIndex.do")
    public String clueChartIndex(){
        return "workbench/chart/clue/index";
    }
    @RequestMapping("/workbench/chart/clue/queryCountOfClueByCreateMonth.do")
    @ResponseBody
    public Object queryCountOfClueByCreateMonth(){
        List<LBVO> lbvoList = clueService.queryCountOfClueByCreateMonth();
        List<Integer> integerList = clueService.queryMaxOfCreateClueInAYear();
        List<String> name = new ArrayList<>();
        List<Integer> value= new ArrayList<>();
        for (LBVO lbvo : lbvoList) {
            name.add(lbvo.getName()+"月");
            value.add(lbvo.getValue());
        }
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        returnInfoObject.setReturnData(name);
        returnInfoObject.setReturnData2(value);
        returnInfoObject.setReturnData3(integerList);
        return  returnInfoObject;
    }

    @RequestMapping("/workbench/chart/clue/queryCountOfClueByOwnerAndCreate.do")
    @ResponseBody
    public Object queryCountOfClueByOwnerAndCreate(){
        List<LBVO> lbvoList = clueService.queryCountOfClueByOwnerAndCreate();
        List<String> name = new ArrayList<>();
        List<Integer> value= new ArrayList<>();
        for (LBVO lbvo : lbvoList) {
            name.add(lbvo.getName());
            value.add(lbvo.getValue());
        }
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        returnInfoObject.setReturnData(name);
        returnInfoObject.setReturnData2(value);
        return  returnInfoObject;
    }

    @RequestMapping("/workbench/chart/clue/queryCountOfClueByState.do")
    @ResponseBody
    public Object queryCountOfClueByState(){
        List<FunnelVO> funnelVOList = clueService.queryCountOfClueByState();

        return  funnelVOList;
    }

    @RequestMapping("/workbench/chart/clue/queryCountOfClueBySource.do")
    @ResponseBody
    public Object queryCountOfClueBySource(){
        List<FunnelVO> funnelVOList = clueService.queryCountOfClueBySource();

        return  funnelVOList;
    }
    @RequestMapping("/workbench/chart/customerAndContacts/customerAndContactsChartIndex.do")
    public String customerAndContactsChartIndex(){
        return "workbench/chart/customerAndContacts/index";
    }
    @RequestMapping("/workbench/chart/customerAndContacts/queryCountOfContactBySource.do")
    @ResponseBody
    public Object queryCountOfContactBySource(){
        List<FunnelVO> funnelVOList = contactService.queryCountOfContactBySource();
        return  funnelVOList;
    }
    @RequestMapping("/workbench/chart/customerAndContacts/queryCountOfCustomerByCutAddress.do")
    @ResponseBody
    public Object queryCountOfCustomerByCutAddress(){
        List<FunnelVO> funnelVOList = customerService.queryCountOfCustomerByCutAddress();
        return  funnelVOList;
    }
    @RequestMapping("/workbench/chart/customerAndContacts/queryCountOfCustomerByCreateMonth.do")
    @ResponseBody
    public Object queryCountOfCustomerByCreateMonth(){
        List<LBVO> lbvoList = customerService.queryCountOfCustomerByCreateMonth();
        List<String> name = new ArrayList<>();
        List<Integer> value= new ArrayList<>();
        List<Integer> value2 = new ArrayList<>();
        for (LBVO lbvo : lbvoList) {
            name.add(lbvo.getName()+"月");
            value.add(lbvo.getValue());
            value2.add(lbvo.getValue2());
        }
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        returnInfoObject.setReturnData(name);
        returnInfoObject.setReturnData2(value);
        returnInfoObject.setReturnData3(value2);
        return  returnInfoObject;
    }

    @RequestMapping("/workbench/chart/customerAndContacts/queryCountOfCustomerByOwnerAndCreate.do")
    @ResponseBody
    public Object queryCountOfCustomerByOwnerAndCreate(){
        List<LBVO> lbvoList = customerService.queryCountOfCustomerByOwnerAndCreate();
        List<String> name = new ArrayList<>();
        List<Integer> value= new ArrayList<>();
        for (LBVO lbvo : lbvoList) {
            name.add(lbvo.getName());
            value.add(lbvo.getValue());
        }
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        returnInfoObject.setReturnData(name);
        returnInfoObject.setReturnData2(value);
        return  returnInfoObject;
    }
    @RequestMapping("/workbench/chart/customerAndContacts/queryCountOfContactByOwnerAndCreate.do")
    @ResponseBody
    public Object queryCountOfContactByOwnerAndCreate(){
        List<LBVO> lbvoList = contactService.queryCountOfContactByOwnerAndCreate();
        List<String> name = new ArrayList<>();
        List<Integer> value= new ArrayList<>();

        for (LBVO lbvo : lbvoList) {
            name.add(lbvo.getName());
            value.add(lbvo.getValue());

        }
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        returnInfoObject.setReturnData(name);
        returnInfoObject.setReturnData2(value);
        return  returnInfoObject;
    }


    @RequestMapping("/workbench/chart/transaction/transactionChartIndex.do")
    public String transactionChartIndex(){
        return "workbench/chart/transaction/index";
    }
    @RequestMapping("/workbench/chart/transaction/queryCountOfTranGroupByStage.do")
    @ResponseBody
    public Object queryCountOfTranGroupByStage(@RequestParam Map<String,Object> map){
        List<FunnelVO> funnelVOList = transactionService.queryCountOfTranGroupByStage(map);
        return  funnelVOList;
    }

    @RequestMapping("/workbench/chart/transaction/queryCountOfTranAndSumMoneyGroupByCut.do")
    @ResponseBody
    public Object queryCountOfTranAndSumMoneyGroupByCut(){
        List<LBVO> lbvoList = transactionService.queryCountOfTranAndSumMoneyGroupByCut();
        List<String> name = new ArrayList<>();
        List<Integer> value= new ArrayList<>();
        List<Integer> value2 = new ArrayList<>();
        for (LBVO lbvo : lbvoList) {
            name.add(lbvo.getName());
            value.add(lbvo.getValue());
            value2.add(lbvo.getValue2());
        }
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        returnInfoObject.setReturnData(name);
        returnInfoObject.setReturnData2(value);
        returnInfoObject.setReturnData3(value2);
        return  returnInfoObject;
    }

    @RequestMapping("/workbench/chart/transaction/queryCountOfTranByCreateMonth.do")
    @ResponseBody
    public Object queryCountOfTranByCreateMonth(){
        List<LBVO> lbvoList = transactionService.queryCountOfTranByCreateMonth();
        List<String> name = new ArrayList<>();
        List<Integer> value= new ArrayList<>();
        List<Integer> value2 = new ArrayList<>();
        for (LBVO lbvo : lbvoList) {
            name.add(lbvo.getName()+"月");
            value.add(lbvo.getValue());
            value2.add(lbvo.getValue2());
        }
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        returnInfoObject.setReturnData(name);
        returnInfoObject.setReturnData2(value);
        returnInfoObject.setReturnData3(value2);
        return  returnInfoObject;
    }

    @RequestMapping("/workbench/chart/transaction/querySumMoneyGroupByOwner.do")
    @ResponseBody
    public Object querySumMoneyGroupByOwner(){
        List<LBVO> lbvoList = transactionService.querySumMoneyGroupByOwner();
        List<String> name = new ArrayList<>();
        List<Integer> value= new ArrayList<>();
        for (LBVO lbvo : lbvoList) {
            name.add(lbvo.getName());
            value.add(lbvo.getValue());
        }
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        returnInfoObject.setReturnData(name);
        returnInfoObject.setReturnData2(value);
        return  returnInfoObject;
    }

}
