package com.qsy.workbench.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author qsy
 * @create 2022/4/25 - 10:00
 */
@Controller
public class ContactController {
    @RequestMapping("workbench/contact/index.do")
    public String index(){
        return "workbench/contact/index";
    }
}
