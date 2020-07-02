package com.example.dockertest.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @program: docker-test
 * @description: 查询controoler
 * @packagename: com.example.dockertest.controller
 * @author: jie.ao@hand-china.com
 * @date: 2020-07-02 15:23
 **/
@RestController
public class HelloController {
    @RequestMapping("/hello")
    public String hello() {
        return "HELLO WORLD112";
    }
}
