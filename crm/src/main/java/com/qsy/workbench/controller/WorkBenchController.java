package com.qsy.workbench.controller;

import com.qsy.settings.pojo.User;
import com.qsy.settings.service.PermissionService;
import com.qsy.settings.service.RolePermissionRelationService;
import com.qsy.utils.Constants;
import com.qsy.utils.MyStringUtils;
import com.qsy.workbench.pojo.Customer;
import com.qsy.workbench.pojo.PieVO;
import com.qsy.workbench.service.ActivityService;
import com.qsy.workbench.service.ClueService;
import com.qsy.workbench.service.CustomerService;
import com.qsy.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/3/30 - 16:16
 */
@Controller
public class WorkBenchController {
    @Autowired
    private PermissionService permissionService;
    @Autowired
    private RolePermissionRelationService rolePermissionRelationService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private TransactionService transactionService;
    @RequestMapping("/workbench/main/index.do")
    public String index(Model model){
        List<Customer> customerList = customerService.queryCustomerByAddress();
        model.addAttribute("customerList",customerList);
        return "workbench/main/index";
    }
    @RequestMapping("/workbench/main/index2.do")
    public String index2(){
        return "workbench/main/index2";
    }
    @RequestMapping("/workbench/main/showPieChart.do")
    @ResponseBody
    public  Object showPieChart(@RequestParam Map<String,Object> map){
        int[] ret = new int[4];
        PieVO pieVO = activityService.queryCountOfRelationActivity(map);
        PieVO pieVO1 = clueService.queryCountOfClue(map);
        PieVO pieVO2 = customerService.queryCountOfCustomer(map);
        PieVO pieVO3 = transactionService.queryCountOfTran(map);
        ret[0] = (int) Math.round(pieVO.getNum()/pieVO.getSum()*100);
        ret[1] = (int) Math.round(pieVO1.getNum()/pieVO1.getSum()*100);
        ret[2] = (int) Math.round(pieVO2.getNum()/pieVO2.getSum()*100);
        ret[3] = (int) Math.round(pieVO3.getNum()/pieVO3.getSum()*100);
        return ret;
    }
    @RequestMapping("/workbench/showMenu.do")
    @ResponseBody
    public Object showMenu(HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        String roleno = user.getRoleno();
        String[] split = roleno.split(",");
        List<String> strings = rolePermissionRelationService.queryPidByRoleIds(split);
        String s = MyStringUtils.stringListUnionRet(strings);
        System.out.println(s);
        List<String> nameList = permissionService.queryNameListByIds(s.split(","));
        return nameList;
    }

    @RequestMapping("/workbench/main/showNew.do")
    @ResponseBody
    public  Object showNew(@RequestParam Map<String,Object> map){

        int ret[] = new int[4];
        ret[0]= activityService.queryCountOfNewActivity(map);
        ret[1] =clueService.queryCountOfNewClue(map);
        ret[2]= customerService.queryCountOfNewCustomer(map);
        ret[3]= transactionService.queryCountOfNewTran(map);
        return ret;
    }


}
