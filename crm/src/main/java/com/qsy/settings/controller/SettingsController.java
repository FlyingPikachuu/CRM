package com.qsy.settings.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author qsy
 * @create 2022/4/20 - 11:05
 */
@Controller
public class SettingsController {

    @RequestMapping("/settings/index.do")
    public String index(){
        return "/settings/index";
    }
}
