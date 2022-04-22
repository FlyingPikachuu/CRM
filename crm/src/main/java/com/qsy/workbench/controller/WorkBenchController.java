package com.qsy.workbench.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author qsy
 * @create 2022/3/30 - 16:16
 */
@Controller
public class WorkBenchController {
    @RequestMapping("/workbench/main/index.do")
    public String index(){
        return "workbench/main/index";
    }
}
