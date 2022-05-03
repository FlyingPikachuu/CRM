package com.qsy.workbench.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author qsy
 * @create 2022/4/25 - 10:00
 */
@Controller
public class CustomerController {
    @RequestMapping("workbench/customer/index.do")
    public  String index(){
        return "workbench/customer/index";
    }
}
